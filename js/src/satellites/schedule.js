import React, { useState, useEffect } from 'react';
import {
  DayView, WeekView, MonthView, YearView, AgendaView, MobileMonthView,
  ResourcesDayView, ResourcesWeekView, ResourcesMonthView, Schedule,
} from '@mantine/schedule';
import '@mantine/dates/styles.css';
import '@mantine/schedule/styles.css';
import { setShinyValue, withReactiveProps } from '../shared';

// ---------------------------------------------------------------------------
// @mantine/schedule: calendar/scheduling views (day/week/month/year/agenda,
// plus resource-grouped variants). Every view is a fully controlled
// component (date/events, and for MobileMonthView also selectedDate) and
// several callback props (onEventClick, onEventDrop, onEventResize,
// onTimeSlotClick, onSlotDragEnd, ...) - render-prop customization
// (renderEvent, renderEventBody, renderResourceLabel, renderHeader,
// getTimeSlotProps, getCurrentTime) and per-event predicates (canDragEvent,
// canResizeEvent) are JS functions that can't cross the R/JSON bridge, so
// they're not exposed: every event is draggable/resizable whenever
// withEventsDragAndDrop/withEventResize is set, and default rendering is
// used throughout (same trade-off already made for Combobox/TableOfContents
// /OverflowList elsewhere in this package).
//
// Multiple distinct interactions are reported to Shiny under suffixed
// input ids off the same `inputId` (same convention as Dropzone's
// `${inputId}_rejected`):
//   input[[inputId]]            - the currently displayed date (or, for
//                                  AgendaView, unused - see below)
//   input[[paste0(inputId, "_event_click")]]  - id of the clicked event
//   input[[paste0(inputId, "_slot_click")]]   - clicked time slot payload
//   input[[paste0(inputId, "_slot_select")]]  - {rangeStart, rangeEnd} from
//                                  a drag-to-select (withDragSlotSelect)
//   input[[paste0(inputId, "_event_drop")]]   - {eventId, newStart, newEnd,
//                                  resourceId?} after a drag-and-drop
//   input[[paste0(inputId, "_event_resize")]] - same shape, after a resize
// `events` is also kept in local state (seeded from the `events` prop,
// reset whenever a fresh `events` prop arrives via updateMantineProps())
// so a drag/resize is reflected immediately without waiting on a server
// round-trip, exactly like SortableList/SortableTable elsewhere in this
// package.
// ---------------------------------------------------------------------------

function applyEventTimeChange(events, payload) {
  return events.map((ev) => {
    if (String(ev.id) !== String(payload.eventId)) return ev;
    const next = { ...ev, start: payload.newStart, end: payload.newEnd };
    if (payload.resourceId !== undefined) next.resourceId = payload.resourceId;
    return next;
  });
}

function createShinyScheduleView(Component) {
  return function Wrapped({
    inputId, date: initialDate, events: initialEvents,
    onDateChange, onEventClick, onTimeSlotClick, onAllDaySlotClick,
    onSlotDragEnd, onEventDrop, onEventResize,
    ...props
  }) {
    const [date, setDate] = useState(initialDate ?? null);
    const [events, setEvents] = useState(initialEvents || []);

    useEffect(() => { setDate(initialDate ?? null); }, [initialDate]);
    useEffect(() => { setEvents(initialEvents || []); }, [initialEvents]);
    useEffect(() => { setShinyValue(inputId, date); }, [inputId, date]);

    return React.createElement(Component, {
      ...props,
      date,
      events,
      onDateChange: (newDate) => {
        setDate(newDate);
        if (onDateChange) onDateChange(newDate);
      },
      onEventClick: (event) => {
        setShinyValue(`${inputId}_event_click`, event ? event.id : null, { priority: 'event' });
        if (onEventClick) onEventClick(event);
      },
      onTimeSlotClick: (payload) => {
        setShinyValue(`${inputId}_slot_click`, payload, { priority: 'event' });
        if (onTimeSlotClick) onTimeSlotClick(payload);
      },
      onAllDaySlotClick: (slotDate) => {
        setShinyValue(`${inputId}_all_day_click`, slotDate, { priority: 'event' });
        if (onAllDaySlotClick) onAllDaySlotClick(slotDate);
      },
      onSlotDragEnd: (rangeStart, rangeEnd) => {
        setShinyValue(`${inputId}_slot_select`, { rangeStart, rangeEnd }, { priority: 'event' });
        if (onSlotDragEnd) onSlotDragEnd(rangeStart, rangeEnd);
      },
      onEventDrop: (payload) => {
        setEvents((prev) => applyEventTimeChange(prev, payload));
        setShinyValue(`${inputId}_event_drop`, payload, { priority: 'event' });
        if (onEventDrop) onEventDrop(payload);
      },
      onEventResize: (payload) => {
        setEvents((prev) => applyEventTimeChange(prev, payload));
        setShinyValue(`${inputId}_event_resize`, payload, { priority: 'event' });
        if (onEventResize) onEventResize(payload);
      },
    });
  };
}

// AgendaView: read-only list (no date/drag-and-drop of its own), just
// events + click reporting over a fixed [rangeStart, rangeEnd] window.
function ShinyAgendaView({ inputId, onEventClick, ...props }) {
  return React.createElement(AgendaView, {
    ...props,
    onEventClick: (event) => {
      setShinyValue(`${inputId}_event_click`, event ? event.id : null, { priority: 'event' });
      if (onEventClick) onEventClick(event);
    },
  });
}

// MobileMonthView: the selected day (selectedDate/onSelectedDateChange) is
// the primary value reported to Shiny under `inputId` itself, matching
// every other stateful input in this package - month navigation
// (date/onDateChange) is secondary and reported under `${inputId}_month`.
// No drag-and-drop support of its own.
function ShinyMobileMonthView({
  inputId, date: initialDate, selectedDate: initialSelectedDate, events,
  onDateChange, onSelectedDateChange, ...props
}) {
  const [date, setDate] = useState(initialDate ?? null);
  const [selectedDate, setSelectedDate] = useState(initialSelectedDate ?? null);

  useEffect(() => { setDate(initialDate ?? null); }, [initialDate]);
  useEffect(() => { setSelectedDate(initialSelectedDate ?? null); }, [initialSelectedDate]);
  useEffect(() => { setShinyValue(inputId, selectedDate); }, [inputId, selectedDate]);
  useEffect(() => { setShinyValue(`${inputId}_month`, date); }, [inputId, date]);

  return React.createElement(MobileMonthView, {
    ...props,
    date,
    events,
    selectedDate,
    onDateChange: (newDate) => {
      setDate(newDate);
      if (onDateChange) onDateChange(newDate);
    },
    onSelectedDateChange: (newDate) => {
      setSelectedDate(newDate);
      if (onSelectedDateChange) onSelectedDateChange(newDate);
    },
  });
}

// Schedule: the unified wrapper with built-in view-level switching
// (day/week/month/year, plus its own header controls) - same event/date
// wiring as createShinyScheduleView(), with an extra `view`/`onViewChange`
// channel reported as `${inputId}_view`.
function ShinyScheduleRouter({
  inputId, date: initialDate, events: initialEvents, view: initialView,
  onDateChange, onViewChange, onEventClick, onTimeSlotClick, onAllDaySlotClick,
  onSlotDragEnd, onEventDrop, onEventResize,
  ...props
}) {
  const [date, setDate] = useState(initialDate ?? null);
  const [view, setView] = useState(initialView ?? null);
  const [events, setEvents] = useState(initialEvents || []);

  useEffect(() => { setDate(initialDate ?? null); }, [initialDate]);
  useEffect(() => { setView(initialView ?? null); }, [initialView]);
  useEffect(() => { setEvents(initialEvents || []); }, [initialEvents]);
  useEffect(() => { setShinyValue(inputId, date); }, [inputId, date]);
  useEffect(() => { setShinyValue(`${inputId}_view`, view); }, [inputId, view]);

  return React.createElement(Schedule, {
    ...props,
    date,
    view,
    events,
    onDateChange: (newDate) => {
      setDate(newDate);
      if (onDateChange) onDateChange(newDate);
    },
    onViewChange: (newView) => {
      setView(newView);
      if (onViewChange) onViewChange(newView);
    },
    onEventClick: (event) => {
      setShinyValue(`${inputId}_event_click`, event ? event.id : null, { priority: 'event' });
      if (onEventClick) onEventClick(event);
    },
    onTimeSlotClick: (payload) => {
      setShinyValue(`${inputId}_slot_click`, payload, { priority: 'event' });
      if (onTimeSlotClick) onTimeSlotClick(payload);
    },
    onAllDaySlotClick: (slotDate) => {
      setShinyValue(`${inputId}_all_day_click`, slotDate, { priority: 'event' });
      if (onAllDaySlotClick) onAllDaySlotClick(slotDate);
    },
    onSlotDragEnd: (rangeStart, rangeEnd) => {
      setShinyValue(`${inputId}_slot_select`, { rangeStart, rangeEnd }, { priority: 'event' });
      if (onSlotDragEnd) onSlotDragEnd(rangeStart, rangeEnd);
    },
    onEventDrop: (payload) => {
      setEvents((prev) => applyEventTimeChange(prev, payload));
      setShinyValue(`${inputId}_event_drop`, payload, { priority: 'event' });
      if (onEventDrop) onEventDrop(payload);
    },
    onEventResize: (payload) => {
      setEvents((prev) => applyEventTimeChange(prev, payload));
      setShinyValue(`${inputId}_event_resize`, payload, { priority: 'event' });
      if (onEventResize) onEventResize(payload);
    },
  });
}

export const components = {
  DayView: withReactiveProps(createShinyScheduleView(DayView)),
  WeekView: withReactiveProps(createShinyScheduleView(WeekView)),
  MonthView: withReactiveProps(createShinyScheduleView(MonthView)),
  YearView: withReactiveProps(createShinyScheduleView(YearView)),
  ResourcesDayView: withReactiveProps(createShinyScheduleView(ResourcesDayView)),
  ResourcesWeekView: withReactiveProps(createShinyScheduleView(ResourcesWeekView)),
  ResourcesMonthView: withReactiveProps(createShinyScheduleView(ResourcesMonthView)),
  AgendaView: withReactiveProps(ShinyAgendaView),
  MobileMonthView: withReactiveProps(ShinyMobileMonthView),
  Schedule: withReactiveProps(ShinyScheduleRouter),
};
