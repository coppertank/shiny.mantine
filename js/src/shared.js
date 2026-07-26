import React, { useEffect, useRef, useState } from 'react';

// ---------------------------------------------------------------------------
// Shiny <-> React bridge primitives shared between the main bundle (core
// components) and the lazily-loaded satellite chunks (js/src/satellites/*).
// Kept in their own module (rather than duplicated per chunk) so webpack
// bundles exactly one copy, included in the main chunk since index.js
// imports it eagerly; satellite chunks reference that already-loaded copy
// instead of re-downloading it.
// ---------------------------------------------------------------------------

export const inputUpdateHandlers = {};

export function setShinyValue(inputId, value, opts) {
  if (window.Shiny && inputId) window.Shiny.setInputValue(inputId, value, opts);
}

// See the comment above these HOCs in index.js's history for the full
// rationale of the skipEcho ref: a server-pushed value (via
// inputUpdateHandlers[inputId], i.e. updateMantineXxx()) must never itself
// look like a fresh user edit and echo back out through setShinyValue().

// A component whose value changes via a native DOM `onChange` event (e.g.
// TextInput): the new value is `event.currentTarget.value`.
export function withShinyEventInput(Component) {
  return function Wrapped({ inputId, value: initialValue, onChange, ...props }) {
    const [value, setValue] = useState(initialValue ?? '');
    const skipEcho = useRef(false);

    useEffect(() => {
      if (skipEcho.current) { skipEcho.current = false; return; }
      setShinyValue(inputId, value);
    }, [inputId, value]);

    useEffect(() => {
      inputUpdateHandlers[inputId] = (v) => { skipEcho.current = true; setValue(v); };
      return () => { delete inputUpdateHandlers[inputId]; };
    }, [inputId]);

    return React.createElement(Component, {
      ...props,
      value,
      onChange: (event) => {
        setValue(event.currentTarget.value);
        if (onChange) onChange(event);
      },
    });
  };
}

// A component whose `onChange` receives the new value directly as its only
// argument (e.g. Select): `(value) => ...`.
export function withShinyValueInput(Component) {
  return function Wrapped({ inputId, value: initialValue, onChange, ...props }) {
    const [value, setValue] = useState(initialValue ?? null);
    const skipEcho = useRef(false);

    useEffect(() => {
      if (skipEcho.current) { skipEcho.current = false; return; }
      setShinyValue(inputId, value);
    }, [inputId, value]);

    useEffect(() => {
      inputUpdateHandlers[inputId] = (v) => { skipEcho.current = true; setValue(v); };
      return () => { delete inputUpdateHandlers[inputId]; };
    }, [inputId]);

    return React.createElement(Component, {
      ...props,
      value,
      onChange: (newValue) => {
        setValue(newValue);
        if (onChange) onChange(newValue);
      },
    });
  };
}

// A component whose click sends a fixed value decided on the R side (e.g.
// Burger's toggle, SpotlightAction's id): every click reports the same
// `value`.
export function withShinyClickValue(Component) {
  return function Wrapped({ inputId, value, onClick, ...props }) {
    return React.createElement(Component, {
      ...props,
      onClick: (event) => {
        setShinyValue(inputId, value, { priority: 'event' });
        if (onClick) onClick(event);
      },
    });
  };
}

// ---------------------------------------------------------------------------
// Generic channel for updating props from R (updateMantineProps()), beyond
// an input's `value`. See index.js for propUpdateHandlers' message-handler
// registration (kept there since it's registered unconditionally at load,
// same as inputUpdateHandlers' handler).
// ---------------------------------------------------------------------------
export const propUpdateHandlers = {};

export function withReactiveProps(Component) {
  return function Wrapped({ mantineId, ...props }) {
    const [patch, setPatch] = useState({});

    useEffect(() => {
      if (!mantineId) return undefined;
      propUpdateHandlers[mantineId] = (newProps) => setPatch((prev) => ({ ...prev, ...newProps }));
      return () => { delete propUpdateHandlers[mantineId]; };
    }, [mantineId]);

    return React.createElement(Component, { ...props, ...patch });
  };
}
