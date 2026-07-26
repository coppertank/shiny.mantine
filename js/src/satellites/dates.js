import {
  DateInput,
  DatePickerInput,
  DatePicker,
  TimeInput,
  MonthPickerInput,
  YearPickerInput,
  DateTimePicker,
  DatesProvider,
  TimePicker,
  TimeGrid,
  MiniCalendar,
  InlineDateTimePicker,
} from '@mantine/dates';
import '@mantine/dates/styles.css';
import { withReactiveProps, withShinyValueInput, withShinyEventInput } from '../shared';

export const components = {
  DateInput: withReactiveProps(withShinyValueInput(DateInput)),
  DatePickerInput: withReactiveProps(withShinyValueInput(DatePickerInput)),
  DatePicker: withReactiveProps(withShinyValueInput(DatePicker)),
  TimeInput: withReactiveProps(withShinyEventInput(TimeInput)),
  MonthPickerInput: withReactiveProps(withShinyValueInput(MonthPickerInput)),
  YearPickerInput: withReactiveProps(withShinyValueInput(YearPickerInput)),
  DateTimePicker: withReactiveProps(withShinyValueInput(DateTimePicker)),
  TimePicker: withReactiveProps(withShinyValueInput(TimePicker)),
  TimeGrid: withReactiveProps(withShinyValueInput(TimeGrid)),
  MiniCalendar: withReactiveProps(withShinyValueInput(MiniCalendar)),
  InlineDateTimePicker: withReactiveProps(withShinyValueInput(InlineDateTimePicker)),
  DatesProvider,
};
