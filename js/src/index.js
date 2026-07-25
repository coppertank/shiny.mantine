import React, {
  useState, useEffect, useRef, useContext, useMemo,
} from 'react';
import { createRoot } from 'react-dom/client';
import {
  MantineProvider,
  Button,
  Card,
  Text,
  Title,
  Paper,
  TextInput,
  Select,
  Switch,
  AppShell,
  NavLink,
  Burger,
  ScrollArea,
  Group,
  Stack,
  SimpleGrid,
  Badge,
  Divider,
  Avatar,
  ThemeIcon,
  Container,
  Box,
  Grid,
  HoverCard,
  UnstyledButton,
  Center,
  Anchor,
  Tabs,
  ActionIcon,
  Menu,
  Progress,
  useMantineColorScheme,
  useComputedColorScheme,
  CopyButton as MantineCopyButton,
  Table,
  RingProgress,
  Image,
  Tooltip,
  SegmentedControl,
  Checkbox,
  Autocomplete,
  NumberInput,
  PasswordInput,
  Slider,
  RangeSlider,
  Radio,
  RadioGroup,
  Chip,
  ChipGroup,
  MultiSelect,
  TagsInput,
  Rating,
  PinInput,
  JsonInput,
  ColorInput,
  ColorPicker,
  FileInput,
  NativeSelect,
  Textarea,
  Pagination,
  Accordion,
  Modal,
  Drawer,
  Dialog,
  Popover,
  Affix,
  LoadingOverlay,
  Menubar,
  Splitter,
  Stepper,
  Tree,
  useTree,
  TreeSelect,
  Collapse,
  CheckboxGroup,
  SwitchGroup,
  CheckboxCard,
  RadioCard,
  FileButton,
  MaskInput,
  DirectionProvider,
  Notification,
  Transition,
  Portal,
  ScrollAreaAutosize,
  NativeScrollArea,
} from '@mantine/core';
import { Dropzone as MantineDropzone } from '@mantine/dropzone';
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
import { Notifications, notifications } from '@mantine/notifications';
import '@mantine/notifications/styles.css';
import { ModalsProvider, modals } from '@mantine/modals';
import { Spotlight } from '@mantine/spotlight';
import '@mantine/spotlight/styles.css';
import {
  LineChart, BarChart, AreaChart, PieChart, DonutChart,
  RadarChart, CompositeChart, RadialBarChart, BubbleChart, FunnelChart,
  Sparkline, ScatterChart, Treemap, Heatmap, SankeyChart,
} from '@mantine/charts';
import '@mantine/charts/styles.css';
import {
  CodeHighlight, InlineCodeHighlight, CodeHighlightTabs, CodeHighlightAdapterProvider, plainTextAdapter,
} from '@mantine/code-highlight';
import '@mantine/code-highlight/styles.css';
import { NavigationProgress, nprogress } from '@mantine/nprogress';
import '@mantine/nprogress/styles.css';
import { RichTextEditor } from '@mantine/tiptap';
import '@mantine/tiptap/styles.css';
import { useEditor } from '@tiptap/react';
import StarterKit from '@tiptap/starter-kit';
import Underline from '@tiptap/extension-underline';
import Link from '@tiptap/extension-link';
import TextAlign from '@tiptap/extension-text-align';
import Placeholder from '@tiptap/extension-placeholder';
import { Carousel } from '@mantine/carousel';
import { DragDropContext, Droppable, Draggable } from '@hello-pangea/dnd';
import { generatedComponents } from './generated-components';
import { reorder, createBuildElement } from './serialization';
import {
  IconHome2,
  IconLayoutDashboard,
  IconSettings,
  IconUsers,
  IconSearch,
  IconChevronDown,
  IconCode,
  IconBook,
  IconChartBar,
  IconFingerprint,
  IconSun,
  IconMoon,
  IconCopy,
  IconCheck,
  IconBrandGoogle,
  IconBrandFacebook,
  IconBrandGithub,
  IconBrandDiscord,
  IconPlus,
  IconBrandTwitter,
  IconBrandInstagram,
  IconBrandYoutube,
  IconBrandLinkedin,
  IconArrowUpRight,
  IconArrowDownRight,
  IconTrendingUp,
  IconTrendingDown,
  IconPhone,
  IconMail,
  IconGripVertical,
  IconUpload,
  IconX,
  IconMapPin,
  IconHeart,
  IconStar,
  IconDots,
  IconEdit,
  IconTrash,
  IconLogout,
  IconChevronRight,
  IconChartLine,
  IconChartPie,
  IconFileText,
  IconBell,
  IconExternalLink,
  IconDownload,
  IconCurrencyDollar,
  IconPercentage,
  IconCategory,
} from '@tabler/icons-react';
import '@mantine/core/styles.css';
import '@mantine/dropzone/styles.css';
import '@mantine/carousel/styles.css';

// ---------------------------------------------------------------------------
// Shiny <-> React bridge
//
// We don't reuse shiny.react's InputAdapter/ButtonAdapter (they're compiled
// against the React 18 copy shared by shiny.react and would use hooks tied
// to that React module, incompatible with our own React 19 copy). The
// functions below reimplement the same concept (Shiny.setInputValue + an
// update channel via custom message) using exclusively our own React.
// ---------------------------------------------------------------------------

const inputUpdateHandlers = {};

if (window.Shiny) {
  window.Shiny.addCustomMessageHandler('shinyMantineUpdateInput', ({ inputId, value }) => {
    const handler = inputUpdateHandlers[inputId];
    if (handler) handler(value);
  });
}

function setShinyValue(inputId, value, opts) {
  if (window.Shiny && inputId) window.Shiny.setInputValue(inputId, value, opts);
}

// A component whose value changes via a native DOM `onChange` event (e.g.
// TextInput): the new value is `event.currentTarget.value`.
function withShinyEventInput(Component) {
  return function Wrapped({ inputId, value: initialValue, onChange, ...props }) {
    const [value, setValue] = useState(initialValue ?? '');

    useEffect(() => { setShinyValue(inputId, value); }, [inputId, value]);

    useEffect(() => {
      inputUpdateHandlers[inputId] = setValue;
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
function withShinyValueInput(Component) {
  return function Wrapped({ inputId, value: initialValue, onChange, ...props }) {
    const [value, setValue] = useState(initialValue ?? null);

    useEffect(() => { setShinyValue(inputId, value); }, [inputId, value]);

    useEffect(() => {
      inputUpdateHandlers[inputId] = setValue;
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

// A boolean component whose value changes via
// `event.currentTarget.checked` (e.g. Switch/Checkbox): uses `checked`
// instead of `value`.
function withShinyCheckedInput(Component) {
  return function Wrapped({ inputId, value: initialValue, onChange, ...props }) {
    const [checked, setChecked] = useState(Boolean(initialValue));

    useEffect(() => { setShinyValue(inputId, checked); }, [inputId, checked]);

    useEffect(() => {
      inputUpdateHandlers[inputId] = (v) => setChecked(Boolean(v));
      return () => { delete inputUpdateHandlers[inputId]; };
    }, [inputId]);

    return React.createElement(Component, {
      ...props,
      checked,
      onChange: (event) => {
        setChecked(event.currentTarget.checked);
        if (onChange) onChange(event);
      },
    });
  };
}

// An "action" component (e.g. Button): every click increments a counter
// sent to Shiny, same behavior as shiny::actionButton().
function withShinyClick(Component) {
  return function Wrapped({ inputId, onClick, ...props }) {
    const clicks = useRef(0);
    return React.createElement(Component, {
      ...props,
      onClick: (event) => {
        clicks.current += 1;
        setShinyValue(inputId, clicks.current, { priority: 'event' });
        if (onClick) onClick(event);
      },
    });
  };
}

// A component whose click sends a fixed value decided on the R side (e.g.
// Burger's toggle): every click reports the same `value`.
function withShinyClickValue(Component) {
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

// Stepper reports which step the user clicked (its index) to Shiny via
// `onStepClick`, as an "event" input (same semantics as an actionButton
// click): the currently active step stays under the app's control (via
// `mantineId`/updateMantineProps()), Stepper does not auto-advance on its
// own — same division of responsibility as Tabs/Pages.
function withShinyStepClick(Component) {
  return function Wrapped({ inputId, onStepClick, ...props }) {
    return React.createElement(Component, {
      ...props,
      onStepClick: (step) => {
        if (inputId) setShinyValue(inputId, step, { priority: 'event' });
        if (onStepClick) onStepClick(step);
      },
    });
  };
}

// Tree has no plain `onNodeClick`/`value` prop — selection is managed by a
// controller object from the `useTree()` hook (passed as its `tree` prop),
// with an `onSelectedStateChange` callback we can hook into. We create that
// controller here (single-select: `multiple` defaults to false, so
// `selectedState` is a 0-or-1-element array) and report the clicked node's
// value to Shiny as an "event" input whenever it changes.
function ShinyTree({ inputId, data, ...props }) {
  const tree = useTree({
    onSelectedStateChange: (selectedState) => {
      if (inputId) setShinyValue(inputId, selectedState[0] ?? null, { priority: 'event' });
    },
  });
  // Tree does not select a node on click unless `selectOnClick` is
  // explicitly enabled (it defaults to undefined/false, only expanding on
  // click) — without it, `onSelectedStateChange` above would never fire.
  return React.createElement(Tree, {
    selectOnClick: true, ...props, data, tree,
  });
}

// Collapse's real Mantine prop is `expanded` — renamed to `opened` here so
// it matches the name every other overlay/toggle in the package uses
// (`Modal`/`Drawer`/`Dialog`/`Popover`), both at creation and via
// updateMantineProps(session, mantineId, opened = TRUE/FALSE).
function ShinyCollapse({ opened, ...props }) {
  return React.createElement(Collapse, { ...props, expanded: opened });
}

// FileButton is a render-prop component (its child is a function that
// receives the props to spread onto a trigger element, usually a Button) —
// we fix the trigger to a Mantine Button so the R API stays a plain
// component call like the rest of the package. As with Dropzone, only file
// *metadata* (name/size/type) is reported to Shiny, never file content: pair
// this with a real `shiny::fileInput()` if you need the actual upload.
function ShinyFileButton({
  inputId, label, accept, multiple, ...buttonProps
}) {
  return React.createElement(
    FileButton,
    {
      accept,
      multiple,
      onChange: (payload) => {
        const list = multiple ? (payload || []) : (payload ? [payload] : []);
        setShinyValue(inputId, {
          count: list.length,
          files: list.map((f) => ({ name: f.name, size: f.size, type: f.type })),
        });
      },
    },
    (triggerProps) => React.createElement(Button, { ...triggerProps, ...buttonProps }, label ?? 'Upload file'),
  );
}

// Transition is also a render-prop component (children is a function
// receiving the current transition `styles` to spread onto the animated
// element) — same fix as ShinyFileButton above: supply the render function
// ourselves and apply the styles to a plain wrapper div, so the R API is
// just `Transition(mounted = ..., children)` like every other component.
function ShinyTransition({ mounted, children, ...props }) {
  return React.createElement(
    Transition,
    { mounted, ...props },
    (styles) => React.createElement('div', { style: styles }, children),
  );
}

// ---------------------------------------------------------------------------
// Generic channel for updating props from R (updateMantineProps()), beyond
// an input's `value`. Same concept as shiny.react's `useUpdatedProps()`/
// `updateReactInput()`, but also available for components that aren't
// Shiny inputs (e.g. Modal, Drawer, Alert, Badge): any prop passed to
// `updateMantineProps(session, mantineId, ...)` gets "patched" over the
// current props of the component mounted with the same `mantineId`.
// Essential for opening/closing Modal/Drawer/Dialog from R.
// ---------------------------------------------------------------------------
const propUpdateHandlers = {};

if (window.Shiny) {
  window.Shiny.addCustomMessageHandler('shinyMantineUpdateProps', ({ id, props }) => {
    const handler = propUpdateHandlers[id];
    if (handler) handler(props);
  });
}

function withReactiveProps(Component) {
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

// ---------------------------------------------------------------------------
// @mantine/notifications: Mantine-styled notifications (instead of
// shiny::showNotification()'s Bootstrap toast) triggerable from R with
// showMantineNotification()/hideMantineNotification(). Requires a
// <Notifications/> mounted once in the page (see R/Notifications.R).
// ---------------------------------------------------------------------------
if (window.Shiny) {
  window.Shiny.addCustomMessageHandler('shinyMantineNotification', (payload) => {
    notifications.show(payload);
  });
  window.Shiny.addCustomMessageHandler('shinyMantineHideNotification', (id) => {
    notifications.hide(id);
  });
}

// ---------------------------------------------------------------------------
// @mantine/modals: imperative API (confirm/prompt) triggerable from R.
// Requires <ModalsProvider> mounted once (typically wrapping the whole
// content, like MantineProvider). Simple props only (no nested component
// trees: use Modal() for rich Mantine content).
// ---------------------------------------------------------------------------
if (window.Shiny) {
  window.Shiny.addCustomMessageHandler('shinyMantineOpenConfirmModal', ({ inputId, ...payload }) => {
    modals.openConfirmModal({
      ...payload,
      onConfirm: () => setShinyValue(inputId, true, { priority: 'event' }),
      onCancel: () => setShinyValue(inputId, false, { priority: 'event' }),
    });
  });
  window.Shiny.addCustomMessageHandler('shinyMantineOpenModal', (payload) => {
    modals.open(payload);
  });
  window.Shiny.addCustomMessageHandler('shinyMantineCloseModal', (id) => {
    modals.close(id);
  });
  // Shiny.addCustomMessageHandler() requires a handler with exactly one
  // argument (even though no payload is needed here) — a zero-arity
  // handler makes the registration throw and breaks the whole script.
  window.Shiny.addCustomMessageHandler('shinyMantineCloseAllModals', (_unused) => {
    modals.closeAll();
  });
}

// ---------------------------------------------------------------------------
// @mantine/nprogress: navigation-style progress bar at the top of the
// page, drivable from R with startMantineProgress()/setMantineProgress()/
// completeMantineProgress()/etc.
// ---------------------------------------------------------------------------
if (window.Shiny) {
  window.Shiny.addCustomMessageHandler('shinyMantineProgress', ({ action, value }) => {
    if (action === 'start') nprogress.start();
    else if (action === 'stop') nprogress.stop();
    else if (action === 'set') nprogress.set(value);
    else if (action === 'increment') nprogress.increment(value);
    else if (action === 'decrement') nprogress.decrement(value);
    else if (action === 'complete') nprogress.complete();
    else if (action === 'reset') nprogress.reset();
  });
}

// ---------------------------------------------------------------------------
// Client-side router: Pages()/Page() (R) allow switching "page" within a
// single React tree (no remount, no server round-trip needed for the
// switch itself). NavLink, when nested inside Pages(), besides reporting
// the click to Shiny (as always) also updates the local state that decides
// which Page() is visible, and automatically receives `active` to
// highlight the current menu item.
// ---------------------------------------------------------------------------

const PagesContext = React.createContext({ active: null, setActive: null });

function Pages({ active: initialActive, children }) {
  const [active, setActive] = useState(initialActive ?? null);
  const ctx = useMemo(() => ({ active, setActive }), [active]);
  return React.createElement(PagesContext.Provider, { value: ctx }, children);
}

function Page({ value, children }) {
  const { active } = useContext(PagesContext);
  if (active !== value) return null;
  return React.createElement(React.Fragment, null, children);
}

function withNavLink(Component) {
  return function Wrapped({
    inputId, value, pageValue, onClick, active, ...props
  }) {
    const pages = useContext(PagesContext);
    const targetPage = pageValue ?? value;
    const computedActive = active ?? (
      pages.active !== null && pages.setActive ? pages.active === targetPage : undefined
    );
    return React.createElement(Component, {
      ...props,
      ...(computedActive !== undefined ? { active: computedActive } : {}),
      onClick: (event) => {
        if (pages.setActive) pages.setActive(targetPage);
        setShinyValue(inputId, value, { priority: 'event' });
        if (onClick) onClick(event);
      },
    });
  };
}

// Makes Tabs "aware" of Pages(): if nested inside Pages(), the selected
// tab drives which Page() is visible (just like withNavLink), and
// conversely the active tab always reflects the current page — useful for
// a tabbed header that navigates the same pages as the Navbar. If used
// outside Pages(), it behaves like a normal controlled Tabs with local
// state.
function withPageTabs(Component) {
  return function Wrapped({
    inputId, value, defaultValue, onChange, ...props
  }) {
    const pages = useContext(PagesContext);
    const isPageAware = pages.setActive !== null;
    const [localValue, setLocalValue] = useState(value ?? defaultValue ?? null);
    const currentValue = isPageAware ? pages.active : localValue;

    return React.createElement(Component, {
      ...props,
      value: currentValue,
      onChange: (newValue) => {
        if (isPageAware) {
          pages.setActive(newValue);
        } else {
          setLocalValue(newValue);
        }
        setShinyValue(inputId, newValue, { priority: 'event' });
        if (onChange) onChange(newValue);
      },
    });
  };
}

// ---------------------------------------------------------------------------
// "Buttons" components (https://ui.mantine.dev/category/buttons/): most of
// that page are recipes, not standalone Mantine components. The ones that
// require real state/hooks (color scheme, clipboard, an anchored dropdown)
// are implemented here as dedicated components; the purely decorative
// ones (social buttons) stay pure R composition in R/Buttons.R on top of
// the existing Button().
// ---------------------------------------------------------------------------

// Implementation note: when a menu/dropdown (Menu.Target, HoverCard.Target,
// ...) needs to anchor to a button, we use Mantine's "raw" `Button` here
// (imported above, before being wrapped by withShinyClick for the
// registry), not the version wrapped by our adapters: our adapters are
// plain function components with no `React.forwardRef`, so a `ref` passed
// by Menu.Target for positioning would get lost.

// --- Color scheme toggle -----------------------------------------------
function ColorSchemeToggle({ inputId, onClick, ...props }) {
  const { setColorScheme } = useMantineColorScheme();
  const computed = useComputedColorScheme('light');
  return React.createElement(
    ActionIcon,
    {
      variant: 'default',
      size: 'lg',
      'aria-label': 'Toggle light/dark theme',
      ...props,
      onClick: (event) => {
        const next = computed === 'light' ? 'dark' : 'light';
        setColorScheme(next);
        setShinyValue(inputId, next, { priority: 'event' });
        if (onClick) onClick(event);
      },
    },
    computed === 'light'
      ? React.createElement(IconMoon, { size: 18 })
      : React.createElement(IconSun, { size: 18 }),
  );
}

// --- Copy to clipboard button --------------------------------------------
// Wraps Mantine's real CopyButton (render-prop) with a declarative API.
function CopyButtonWrapper({
  value, label, copiedLabel, inputId, ...props
}) {
  return React.createElement(MantineCopyButton, { value }, ({ copied, copy }) => (
    React.createElement(
      Button,
      {
        color: copied ? 'teal' : (props.color ?? 'blue'),
        leftSection: copied ? React.createElement(IconCheck, { size: 16 }) : React.createElement(IconCopy, { size: 16 }),
        ...props,
        onClick: () => {
          copy();
          setShinyValue(inputId, value, { priority: 'event' });
        },
      },
      copied ? (copiedLabel ?? 'Copied') : (label ?? 'Copy'),
    )
  ));
}

// --- Button with (dropdown) menu -----------------------------------------
// The whole button is the menu's target (click on the button =
// open/close). Items (R-side menuItem()) arrive as `children`.
function ButtonWithMenuComponent({
  label, color = 'blue', children, inputId, ...props
}) {
  // inputId is unused here: the button only opens/closes the menu, it's
  // the individual MenuItem()s (R-side menuItem()) that report clicks to
  // Shiny.
  return React.createElement(
    Menu,
    { position: 'bottom-start', withinPortal: true },
    React.createElement(
      Menu.Target,
      {},
      React.createElement(Button, {
        color,
        rightSection: React.createElement(IconChevronDown, { size: 16 }),
        ...props,
      }, label),
    ),
    React.createElement(Menu.Dropdown, {}, children),
  );
}

// --- Split button ----------------------------------------------------------
// Primary action (button, reports clicks to Shiny) + a separate small
// arrow that opens a menu of alternative actions (R-side MenuItem()s as
// `children`).
//
// Deliberately NOT `Button.Group`: that component only flattens the shared
// inner border-radius between adjacent `Button` elements (it targets
// `.mantine-Button-root` siblings), and the second half here is an
// `ActionIcon` nested inside a `Menu`/`Menu.Target`, not a direct `Button`
// sibling — so `Button.Group` never squares off the ActionIcon's left
// corners, leaving it fully rounded next to the button's squared-off right
// corners (a visibly mismatched seam). This mirrors Mantine's own "Split
// button" recipe: a plain zero-gap `Group`, with each half's *inner*
// corners explicitly zeroed via inline style (highest specificity, so it
// wins regardless of the theme's/`radius` prop's rounding) while its outer
// corners keep the normal (possibly caller-provided) `radius`.
function SplitButtonComponent({
  inputId, label, color = 'blue', children, onClick, radius, ...props
}) {
  const clicks = useRef(0);
  return React.createElement(
    Group,
    { wrap: 'nowrap', gap: 0 },
    React.createElement(Button, {
      color,
      radius,
      ...props,
      style: {
        borderTopRightRadius: 0,
        borderBottomRightRadius: 0,
        ...(props.style || {}),
      },
      onClick: (event) => {
        clicks.current += 1;
        setShinyValue(inputId, clicks.current, { priority: 'event' });
        if (onClick) onClick(event);
      },
    }, label),
    React.createElement(
      Menu,
      { position: 'bottom-end', withinPortal: true },
      React.createElement(
        Menu.Target,
        {},
        React.createElement(ActionIcon, {
          color, variant: 'filled', size: 36, radius, 'aria-label': 'More actions',
          style: { borderTopLeftRadius: 0, borderBottomLeftRadius: 0 },
        }, React.createElement(IconChevronDown, { size: 16 })),
      ),
      React.createElement(Menu.Dropdown, {}, children),
    ),
  );
}

// --- Button with loading progress ------------------------------------------
// On click, starts a simulated progress bar (no real task connected: it's
// meant to be adapted, e.g. by starting a real server-side job and
// advancing `progress` via an updateMantineTextInput-like custom message
// if real, rather than simulated, progress is needed).
function LoadingProgressButton({
  inputId, label, loadingLabel, onClick, ...props
}) {
  const [progress, setProgress] = useState(0);
  const [loading, setLoading] = useState(false);
  const intervalRef = useRef(null);

  useEffect(() => () => {
    if (intervalRef.current) clearInterval(intervalRef.current);
  }, []);

  const start = (event) => {
    if (loading) return;
    setLoading(true);
    setProgress(0);
    intervalRef.current = setInterval(() => {
      setProgress((p) => {
        const next = p + 10;
        if (next >= 100) {
          clearInterval(intervalRef.current);
          setLoading(false);
          setShinyValue(inputId, true, { priority: 'event' });
          return 0;
        }
        return next;
      });
    }, 200);
    if (onClick) onClick(event);
  };

  return React.createElement(
    Button,
    {
      ...props,
      disabled: loading || props.disabled,
      onClick: start,
      style: { position: 'relative', overflow: 'hidden', ...(props.style || {}) },
    },
    loading
      ? React.createElement('span', {
        style: {
          position: 'absolute',
          left: 0,
          top: 0,
          bottom: 0,
          width: `${progress}%`,
          backgroundColor: 'rgba(255,255,255,0.35)',
          transition: 'width 0.2s ease',
        },
      })
      : null,
    loading ? (loadingLabel ?? 'Loading...') : label,
  );
}

// ---------------------------------------------------------------------------
// Dropzone (file upload): reports the metadata of dropped files
// (name/size/type) to Shiny — file content is not uploaded over this
// channel, it's meant to let the server react (validation, kicking off a
// real upload via a regular shiny::fileInput() alongside it, ...).
// ---------------------------------------------------------------------------
function ShinyDropzone({
  inputId, children, onDrop, onReject, ...props
}) {
  return React.createElement(MantineDropzone, {
    ...props,
    onDrop: (files) => {
      // Wrapped in { count, files } (instead of a bare array) because a
      // JSON array with a single object gets "flattened" by R differently
      // than one with several objects (a classic jsonlite/Shiny gotcha) —
      // making `length(input$x)` unreliable for counting files. `count` is
      // always a single, stable number.
      const meta = files.map((f) => ({ name: f.name, size: f.size, type: f.type }));
      setShinyValue(inputId, { count: files.length, files: meta }, { priority: 'event' });
      if (onDrop) onDrop(files);
    },
    onReject: (fileRejections) => {
      setShinyValue(`${inputId}_rejected`, fileRejections.length, { priority: 'event' });
      if (onReject) onReject(fileRejections);
    },
  }, children);
}

// FileInput receives a File/File[]/null from Mantine (not JSON-serializable):
// only the metadata is reported to Shiny, same { count, files } schema as
// ShinyDropzone (`count` always reliable, even with a single file).
// MaskInput's masking (`@mantine/hooks`' useMask) mutates the native
// input's DOM value directly and synchronously while processing its own
// 'input' listener — by the time that event bubbles up, React's change
// tracker sees the DOM value already matches what it last recorded and
// never fires the synthetic `onChange` at all (a known React quirk with
// libraries that reassign `input.value` outside of React's own render
// cycle). MaskInput exposes `onChangeRaw(raw, display)` specifically for
// this: it is called directly as a plain JS callback, bypassing the DOM
// event system entirely, so this is used instead of `onChange`. It's also
// mounted uncontrolled (`defaultValue`, no `value` prop) since a
// React-controlled value would fight the same internal mutation. For
// server-initiated updates, the DOM node's value is set through React's own
// native input setter plus a synthetic 'input' event, so the mask hook's
// listener reprocesses it exactly as if the user had typed it.
function ShinyMaskInput({ inputId, value: initialValue, onChangeRaw, ...props }) {
  const ref = useRef(null);

  useEffect(() => {
    inputUpdateHandlers[inputId] = (newValue) => {
      const el = ref.current;
      if (!el) return;
      const nativeSetter = Object.getOwnPropertyDescriptor(window.HTMLInputElement.prototype, 'value').set;
      nativeSetter.call(el, newValue ?? '');
      el.dispatchEvent(new Event('input', { bubbles: true }));
    };
    return () => { delete inputUpdateHandlers[inputId]; };
  }, [inputId]);

  return React.createElement(MaskInput, {
    ...props,
    ref,
    defaultValue: initialValue,
    onChangeRaw: (raw, display) => {
      setShinyValue(inputId, display);
      if (onChangeRaw) onChangeRaw(raw, display);
    },
  });
}

function ShinyFileInput({ inputId, onChange, ...props }) {
  return React.createElement(FileInput, {
    ...props,
    onChange: (payload) => {
      const files = Array.isArray(payload) ? payload : (payload ? [payload] : []);
      const meta = files.map((f) => ({ name: f.name, size: f.size, type: f.type }));
      setShinyValue(inputId, { count: files.length, files: meta });
      if (onChange) onChange(payload);
    },
  });
}

// Spotlight (command palette, Cmd+K by default): `actions` arrives as plain
// data from R ([{id, label, description, leftSection}, ...]); every
// selection reports `id` to Shiny via `inputId`, same pattern as
// menuItem()/navLinkItem().
function ShinySpotlight({ inputId, actions, ...props }) {
  const mappedActions = (actions || []).map((a) => ({
    ...a,
    onClick: () => setShinyValue(inputId, a.id, { priority: 'event' }),
  }));
  return React.createElement(Spotlight, { ...props, actions: mappedActions });
}

// CodeHighlight requires a syntax-highlighting "adapter"
// (highlight.js/shiki, not included to avoid bloating the bundle): always
// use plainTextAdapter (no colors, but no extra dependencies) so the
// component works out of the box with no extra setup.
function ShinyCodeHighlight(props) {
  return React.createElement(
    CodeHighlightAdapterProvider,
    { adapter: plainTextAdapter },
    React.createElement(CodeHighlight, props),
  );
}

function ShinyInlineCodeHighlight(props) {
  return React.createElement(
    CodeHighlightAdapterProvider,
    { adapter: plainTextAdapter },
    React.createElement(InlineCodeHighlight, props),
  );
}

function ShinyCodeHighlightTabs(props) {
  return React.createElement(
    CodeHighlightAdapterProvider,
    { adapter: plainTextAdapter },
    React.createElement(CodeHighlightTabs, props),
  );
}

// ---------------------------------------------------------------------------
// @mantine/tiptap: rich text editor. Reduced scope compared to full tiptap
// (no tables/images/collaboration): only basic formatting (bold, italic,
// lists, headings, links, alignment), which covers the vast majority of
// use cases in a Shiny form. The content's HTML is reported to Shiny as a
// regular input (like a textarea), not as an "event": every edit updates
// `input$inputId`.
function ShinyRichTextEditor({
  inputId, content: initialContent, placeholder, ...props
}) {
  const editor = useEditor({
    extensions: [
      StarterKit,
      Underline,
      Link,
      TextAlign.configure({ types: ['heading', 'paragraph'] }),
      ...(placeholder ? [Placeholder.configure({ placeholder })] : []),
    ],
    content: initialContent || '',
    onUpdate: ({ editor: ed }) => {
      setShinyValue(inputId, ed.getHTML());
    },
  });

  useEffect(() => {
    if (!editor) return undefined;
    setShinyValue(inputId, editor.getHTML());
    inputUpdateHandlers[inputId] = (html) => {
      if (html !== editor.getHTML()) editor.commands.setContent(html || '');
    };
    return () => { delete inputUpdateHandlers[inputId]; };
  }, [editor, inputId]);

  return React.createElement(
    RichTextEditor,
    { editor, ...props },
    React.createElement(
      RichTextEditor.Toolbar,
      { sticky: true },
      React.createElement(
        RichTextEditor.ControlsGroup,
        null,
        React.createElement(RichTextEditor.Bold),
        React.createElement(RichTextEditor.Italic),
        React.createElement(RichTextEditor.Underline),
        React.createElement(RichTextEditor.Strikethrough),
        React.createElement(RichTextEditor.ClearFormatting),
        React.createElement(RichTextEditor.Highlight),
        React.createElement(RichTextEditor.Code),
      ),
      React.createElement(
        RichTextEditor.ControlsGroup,
        null,
        React.createElement(RichTextEditor.H1),
        React.createElement(RichTextEditor.H2),
        React.createElement(RichTextEditor.H3),
        React.createElement(RichTextEditor.H4),
      ),
      React.createElement(
        RichTextEditor.ControlsGroup,
        null,
        React.createElement(RichTextEditor.Blockquote),
        React.createElement(RichTextEditor.Hr),
        React.createElement(RichTextEditor.BulletList),
        React.createElement(RichTextEditor.OrderedList),
      ),
      React.createElement(
        RichTextEditor.ControlsGroup,
        null,
        React.createElement(RichTextEditor.Link),
        React.createElement(RichTextEditor.Unlink),
      ),
      React.createElement(
        RichTextEditor.ControlsGroup,
        null,
        React.createElement(RichTextEditor.AlignLeft),
        React.createElement(RichTextEditor.AlignCenter),
        React.createElement(RichTextEditor.AlignRight),
        React.createElement(RichTextEditor.AlignJustify),
      ),
      React.createElement(
        RichTextEditor.ControlsGroup,
        null,
        React.createElement(RichTextEditor.Undo),
        React.createElement(RichTextEditor.Redo),
      ),
    ),
    React.createElement(RichTextEditor.Content),
  );
}

// ---------------------------------------------------------------------------
// Overlays that can be opened/closed both from R
// (updateMantineProps(..., opened=TRUE)) and by the user (click on X /
// outside / Escape). Local state synced with the `opened` prop (which
// withReactiveProps can update) via useEffect: without local state,
// closing by clicking X would have no immediate effect (the "source of
// truth" would live only outside the component); without the useEffect, a
// updateMantineProps() call after the first opening would not
// reopen/reclose the overlay.
function withControlledOpen(Component) {
  return function Wrapped({
    inputId, opened, onClose, ...props
  }) {
    const [localOpened, setLocalOpened] = useState(Boolean(opened));

    useEffect(() => { setLocalOpened(Boolean(opened)); }, [opened]);

    return React.createElement(Component, {
      ...props,
      opened: localOpened,
      onClose: () => {
        setLocalOpened(false);
        setShinyValue(inputId, false, { priority: 'event' });
        if (onClose) onClose();
      },
    });
  };
}

// ---------------------------------------------------------------------------
// Drag'n'drop: reorderable list and table. Receives `items` (plain data,
// not nested React elements: [{value, label}, ...] for the list, [{value,
// cells:[...]}, ...] + `columns` for the table) and reports the new order
// (an array of `value`) to Shiny after every drag.
// ---------------------------------------------------------------------------
function SortableList({ inputId, items: initialItems, withHandle }) {
  const [items, setItems] = useState(initialItems || []);

  const onDragEnd = (result) => {
    if (!result.destination) return;
    const next = reorder(items, result.source.index, result.destination.index);
    setItems(next);
    setShinyValue(inputId, next.map((it) => it.value), { priority: 'event' });
  };

  return React.createElement(
    DragDropContext,
    { onDragEnd },
    React.createElement(Droppable, { droppableId: 'shiny-mantine-sortable-list' }, (provided) => (
      React.createElement(
        'div',
        { ref: provided.innerRef, ...provided.droppableProps },
        items.map((item, index) => React.createElement(
          Draggable,
          { key: String(item.value), draggableId: String(item.value), index },
          (provided2) => React.createElement(
            Paper,
            {
              ref: provided2.innerRef,
              ...provided2.draggableProps,
              ...(withHandle ? {} : provided2.dragHandleProps),
              withBorder: true,
              p: 'sm',
              mb: 'xs',
            },
            React.createElement(
              Group,
              {},
              withHandle
                ? React.createElement('span', { ...provided2.dragHandleProps, style: { display: 'flex' } }, React.createElement(IconGripVertical, { size: 18 }))
                : null,
              React.createElement(Text, {}, item.label),
            ),
          ),
        )),
        provided.placeholder,
      )
    )),
  );
}

function SortableTable({ inputId, items: initialItems, columns }) {
  const [items, setItems] = useState(initialItems || []);

  const onDragEnd = (result) => {
    if (!result.destination) return;
    const next = reorder(items, result.source.index, result.destination.index);
    setItems(next);
    setShinyValue(inputId, next.map((it) => it.value), { priority: 'event' });
  };

  return React.createElement(
    Table,
    {},
    React.createElement(Table.Thead, {}, React.createElement(
      Table.Tr,
      {},
      React.createElement(Table.Th, { style: { width: 40 } }, ''),
      (columns || []).map((c, i) => React.createElement(Table.Th, { key: i }, c)),
    )),
    React.createElement(
      DragDropContext,
      { onDragEnd },
      React.createElement(Droppable, { droppableId: 'shiny-mantine-sortable-table' }, (provided) => React.createElement(
        Table.Tbody,
        { ref: provided.innerRef, ...provided.droppableProps },
        items.map((item, index) => React.createElement(
          Draggable,
          { key: String(item.value), draggableId: String(item.value), index },
          (provided2) => React.createElement(
            Table.Tr,
            { ref: provided2.innerRef, ...provided2.draggableProps },
            React.createElement(Table.Td, { ...provided2.dragHandleProps, style: { width: 40 } }, React.createElement(IconGripVertical, { size: 16 })),
            item.cells.map((cell, i) => React.createElement(Table.Td, { key: i }, cell)),
          ),
        )),
        provided.placeholder,
      )),
    ),
  );
}

// ---------------------------------------------------------------------------
// DataTable: table with client-side search/sort/selection (used for
// "Table with selection" and "Table with search and sort"). `data` is an
// array of rows (objects with at least a `value` field as unique id);
// `columns` is an array of {key, label}.
// ---------------------------------------------------------------------------
function DataTable({
  inputId, data: initialData, columns, selectable, searchable, sortable,
}) {
  const [search, setSearch] = useState('');
  const [sortBy, setSortBy] = useState(null);
  const [reversed, setReversed] = useState(false);
  const [selected, setSelected] = useState([]);

  let rows = initialData || [];
  if (searchable && search) {
    const q = search.toLowerCase();
    rows = rows.filter((row) => columns.some((col) => String(row[col.key] ?? '').toLowerCase().includes(q)));
  }
  if (sortable && sortBy) {
    rows = [...rows].sort((a, b) => {
      const cmp = String(a[sortBy] ?? '').localeCompare(String(b[sortBy] ?? ''), undefined, { numeric: true });
      return reversed ? -cmp : cmp;
    });
  }

  const rowKey = JSON.stringify(rows.map((r) => r.value));
  const selKey = JSON.stringify(selected);
  useEffect(() => {
    setShinyValue(inputId, { visible: rows.map((r) => r.value), selected });
    // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [rowKey, selKey]);

  const toggleSort = (key) => {
    if (sortBy === key) setReversed(!reversed);
    else { setSortBy(key); setReversed(false); }
  };

  const toggleRow = (value) => {
    setSelected((prev) => (prev.includes(value) ? prev.filter((v) => v !== value) : [...prev, value]));
  };

  const toggleAll = () => {
    setSelected(selected.length === rows.length ? [] : rows.map((r) => r.value));
  };

  return React.createElement(
    Stack,
    {},
    searchable ? React.createElement(TextInput, {
      placeholder: 'Search...',
      value: search,
      onChange: (e) => setSearch(e.currentTarget.value),
      leftSection: React.createElement(IconSearch, { size: 14 }),
    }) : null,
    React.createElement(
      Table.ScrollContainer,
      { minWidth: 400 },
      React.createElement(
        Table,
        { highlightOnHover: true },
        React.createElement(
          Table.Thead,
          {},
          React.createElement(
            Table.Tr,
            {},
            selectable ? React.createElement(
              Table.Th,
              { style: { width: 40 } },
              React.createElement(Checkbox, {
                checked: rows.length > 0 && selected.length === rows.length,
                onChange: toggleAll,
              }),
            ) : null,
            columns.map((col) => React.createElement(
              Table.Th,
              {
                key: col.key,
                style: sortable ? { cursor: 'pointer', userSelect: 'none' } : undefined,
                onClick: sortable ? () => toggleSort(col.key) : undefined,
              },
              col.label + (sortable && sortBy === col.key ? (reversed ? ' ↓' : ' ↑') : ''),
            )),
          ),
        ),
        React.createElement(
          Table.Tbody,
          {},
          rows.map((row) => React.createElement(
            Table.Tr,
            { key: row.value },
            selectable ? React.createElement(
              Table.Td,
              {},
              React.createElement(Checkbox, { checked: selected.includes(row.value), onChange: () => toggleRow(row.value) }),
            ) : null,
            columns.map((col) => React.createElement(Table.Td, { key: col.key }, row[col.key])),
          )),
        ),
      ),
    ),
  );
}

// Shiny's bundled Bootstrap 3 CSS (attached by fluidPage()/bootstrapPage(),
// but *not* by a plain tagList() UI) sets `html { font-size: 10px; }`,
// while Mantine's entire rem-based size scale is calibrated for a 16px
// root. Since whether that CSS is even loaded depends entirely on the
// app's own choice of UI function, this can't be corrected with a fixed
// guess baked in on the R side (a static assumption would overcorrect on
// pages that never load Bootstrap and already have a 16px root) — instead,
// the real, already-computed root font-size is measured once at mount
// time (all page stylesheets have been applied by then) and theme.scale
// is set accordingly, using Mantine's own built-in --mantine-scale
// mechanism. See the fixShinyFontScale docs in R/MantineProvider.R.
function ShinyMantineProvider({ theme, fixShinyFontScale, ...props }) {
  const [resolvedTheme] = useState(() => {
    if (fixShinyFontScale === false) return theme;
    if (theme && theme.scale !== undefined) return theme;
    const rootFontSizePx = parseFloat(getComputedStyle(document.documentElement).fontSize) || 16;
    if (rootFontSizePx === 16) return theme;
    return { ...(theme || {}), scale: 16 / rootFontSizePx };
  });
  return React.createElement(MantineProvider, { ...props, theme: resolvedTheme });
}

// ---------------------------------------------------------------------------
// Component registry: name (string sent from R) -> React component.
// ---------------------------------------------------------------------------

const components = {
  MantineProvider: ShinyMantineProvider,
  Card,
  'Card.Section': Card.Section,
  Text,
  Title,
  Paper,
  Group,
  Stack,
  SimpleGrid,
  Badge: withReactiveProps(Badge),
  Divider,
  Avatar,
  ThemeIcon,
  Container,
  Box,
  Grid,
  'Grid.Col': Grid.Col,
  HoverCard,
  'HoverCard.Target': HoverCard.Target,
  'HoverCard.Dropdown': HoverCard.Dropdown,
  'HoverCard.Group': HoverCard.Group,
  UnstyledButton,
  Center,
  Anchor,
  ScrollArea,
  AppShell,
  'AppShell.Header': AppShell.Header,
  'AppShell.Navbar': AppShell.Navbar,
  'AppShell.Main': AppShell.Main,
  'AppShell.Aside': AppShell.Aside,
  'AppShell.Footer': AppShell.Footer,
  'AppShell.Section': AppShell.Section,
  Button: withShinyClick(Button),
  NavLink: withNavLink(NavLink),
  Burger: withShinyClickValue(Burger),
  TextInput: withReactiveProps(withShinyEventInput(TextInput)),
  Select: withReactiveProps(withShinyValueInput(Select)),
  Switch: withReactiveProps(withShinyCheckedInput(Switch)),
  Tabs: withPageTabs(Tabs),
  'Tabs.List': Tabs.List,
  'Tabs.Tab': Tabs.Tab,
  'Tabs.Panel': Tabs.Panel,
  Pages,
  Page,
  ActionIcon,
  'ActionIcon.Group': ActionIcon.Group,
  Progress,
  'Button.Group': Button.Group,
  Menu,
  'Menu.Target': Menu.Target,
  'Menu.Dropdown': Menu.Dropdown,
  'Menu.Label': Menu.Label,
  'Menu.Divider': Menu.Divider,
  'Menu.Item': withShinyClickValue(Menu.Item),
  'Menu.Sub': Menu.Sub,
  'Menu.Sub.Target': Menu.Sub.Target,
  'Menu.Sub.Dropdown': Menu.Sub.Dropdown,
  'Menu.Sub.Item': withShinyClickValue(Menu.Sub.Item),
  'Menu.CheckboxGroup': Menu.CheckboxGroup,
  'Menu.CheckboxItem': withReactiveProps(withShinyCheckedInput(Menu.CheckboxItem)),
  'Menu.RadioGroup': withReactiveProps(withShinyValueInput(Menu.RadioGroup)),
  'Menu.RadioItem': Menu.RadioItem,
  'Menu.Search': Menu.Search,
  'Menu.ContextMenu': Menu.ContextMenu,
  Menubar,
  'Menubar.Menu': Menubar.Menu,
  'Menubar.Target': Menubar.Target,
  'Menubar.Dropdown': Menubar.Dropdown,
  Splitter,
  'Splitter.Panel': Splitter.Pane,
  ColorSchemeToggle,
  CopyButton: CopyButtonWrapper,
  ButtonWithMenu: ButtonWithMenuComponent,
  SplitButton: SplitButtonComponent,
  LoadingProgressButton,
  Table,
  'Table.Thead': Table.Thead,
  'Table.Tbody': Table.Tbody,
  'Table.Tfoot': Table.Tfoot,
  'Table.Tr': Table.Tr,
  'Table.Th': Table.Th,
  'Table.Td': Table.Td,
  'Table.Caption': Table.Caption,
  'Table.ScrollContainer': Table.ScrollContainer,
  RingProgress,
  Image,
  Tooltip,
  SegmentedControl: withReactiveProps(withShinyValueInput(SegmentedControl)),
  Checkbox: withReactiveProps(withShinyCheckedInput(Checkbox)),
  Autocomplete: withReactiveProps(withShinyValueInput(Autocomplete)),
  NumberInput: withReactiveProps(withShinyValueInput(NumberInput)),
  PasswordInput: withReactiveProps(withShinyEventInput(PasswordInput)),
  Slider: withReactiveProps(withShinyValueInput(Slider)),
  RangeSlider: withReactiveProps(withShinyValueInput(RangeSlider)),
  Radio: withReactiveProps(Radio),
  RadioGroup: withReactiveProps(withShinyValueInput(RadioGroup)),
  // Chip "raw" (unwrapped): when it's a child of ChipGroup, Mantine
  // automatically links it to the group's internal context
  // (checked/onChange managed by ChipGroup itself) — wrapping it ourselves
  // with an adapter would break that link. For a standalone Chip (outside
  // ChipGroup) compose checked/onChange manually with mantineElement() if
  // needed.
  Chip: withReactiveProps(Chip),
  ChipGroup: withReactiveProps(withShinyValueInput(ChipGroup)),
  MultiSelect: withReactiveProps(withShinyValueInput(MultiSelect)),
  TagsInput: withReactiveProps(withShinyValueInput(TagsInput)),
  Rating: withReactiveProps(withShinyValueInput(Rating)),
  PinInput: withReactiveProps(withShinyValueInput(PinInput)),
  JsonInput: withReactiveProps(withShinyValueInput(JsonInput)),
  ColorInput: withReactiveProps(withShinyValueInput(ColorInput)),
  ColorPicker: withReactiveProps(withShinyValueInput(ColorPicker)),
  FileInput: withReactiveProps(ShinyFileInput),
  NativeSelect: withReactiveProps(withShinyEventInput(NativeSelect)),
  Textarea: withReactiveProps(withShinyEventInput(Textarea)),
  MaskInput: withReactiveProps(ShinyMaskInput),
  Pagination: withReactiveProps(withShinyValueInput(Pagination)),
  Accordion: withReactiveProps(withShinyValueInput(Accordion)),
  'Accordion.Item': Accordion.Item,
  'Accordion.Control': Accordion.Control,
  'Accordion.Panel': Accordion.Panel,
  // CheckboxGroup/SwitchGroup work exactly like RadioGroup/ChipGroup: the
  // group itself is stateful (array of checked values), but its children
  // must stay the *raw* Mantine component (no local checked/onChange
  // override) so Mantine's own group context can derive `checked` for each
  // item from its `value` — registered under a distinct name
  // (CheckboxGroupItem/SwitchGroupItem) so the pre-existing standalone
  // Checkbox()/Switch() inputs (which do own their checked state) keep
  // working unchanged.
  CheckboxGroup: withReactiveProps(withShinyValueInput(CheckboxGroup)),
  CheckboxGroupItem: Checkbox,
  SwitchGroup: withReactiveProps(withShinyValueInput(SwitchGroup)),
  SwitchGroupItem: Switch,
  CheckboxCard: withReactiveProps(CheckboxCard),
  RadioCard: withReactiveProps(RadioCard),
  Modal: withReactiveProps(withControlledOpen(Modal)),
  Drawer: withReactiveProps(withControlledOpen(Drawer)),
  Dialog: withReactiveProps(withControlledOpen(Dialog)),
  Popover: withReactiveProps(withControlledOpen(Popover)),
  'Popover.Target': Popover.Target,
  'Popover.Dropdown': Popover.Dropdown,
  Affix: withReactiveProps(Affix),
  LoadingOverlay: withReactiveProps(LoadingOverlay),
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
  DirectionProvider,
  Notification: withReactiveProps(Notification),
  Transition: withReactiveProps(ShinyTransition),
  Portal,
  ScrollAreaAutosize,
  NativeScrollArea,
  'Progress.Root': Progress.Root,
  'Progress.Section': withReactiveProps(Progress.Section),
  'Progress.Label': Progress.Label,
  Notifications,
  ModalsProvider,
  Spotlight: ShinySpotlight,
  LineChart: withReactiveProps(LineChart),
  BarChart: withReactiveProps(BarChart),
  AreaChart: withReactiveProps(AreaChart),
  PieChart: withReactiveProps(PieChart),
  DonutChart: withReactiveProps(DonutChart),
  RadarChart: withReactiveProps(RadarChart),
  CompositeChart: withReactiveProps(CompositeChart),
  RadialBarChart: withReactiveProps(RadialBarChart),
  BubbleChart: withReactiveProps(BubbleChart),
  FunnelChart: withReactiveProps(FunnelChart),
  Sparkline: withReactiveProps(Sparkline),
  ScatterChart: withReactiveProps(ScatterChart),
  Treemap: withReactiveProps(Treemap),
  Heatmap: withReactiveProps(Heatmap),
  SankeyChart: withReactiveProps(SankeyChart),
  CodeHighlight: withReactiveProps(ShinyCodeHighlight),
  InlineCodeHighlight: withReactiveProps(ShinyInlineCodeHighlight),
  CodeHighlightTabs: withReactiveProps(ShinyCodeHighlightTabs),
  NavigationProgress,
  RichTextEditor: ShinyRichTextEditor,
  Stepper: withReactiveProps(withShinyStepClick(Stepper)),
  'Stepper.Step': Stepper.Step,
  'Stepper.Completed': Stepper.Completed,
  Tree: withReactiveProps(ShinyTree),
  TreeSelect: withReactiveProps(withShinyValueInput(TreeSelect)),
  Collapse: withReactiveProps(ShinyCollapse),
  FileButton: ShinyFileButton,
  Dropzone: ShinyDropzone,
  'Dropzone.Accept': MantineDropzone.Accept,
  'Dropzone.Reject': MantineDropzone.Reject,
  'Dropzone.Idle': MantineDropzone.Idle,
  Carousel,
  'Carousel.Slide': Carousel.Slide,
  SortableList,
  SortableTable,
  DataTable,
  IconHome2,
  IconLayoutDashboard,
  IconSettings,
  IconUsers,
  IconSearch,
  IconChevronDown,
  IconCode,
  IconBook,
  IconChartBar,
  IconFingerprint,
  IconSun,
  IconMoon,
  IconCopy,
  IconCheck,
  IconBrandGoogle,
  IconBrandFacebook,
  IconBrandGithub,
  IconBrandDiscord,
  IconPlus,
  IconBrandTwitter,
  IconBrandInstagram,
  IconBrandYoutube,
  IconBrandLinkedin,
  IconArrowUpRight,
  IconArrowDownRight,
  IconTrendingUp,
  IconTrendingDown,
  IconPhone,
  IconMail,
  IconGripVertical,
  IconUpload,
  IconX,
  IconMapPin,
  IconHeart,
  IconStar,
  IconDots,
  IconEdit,
  IconTrash,
  IconLogout,
  IconChevronRight,
  IconChartLine,
  IconChartPie,
  IconFileText,
  IconBell,
  IconExternalLink,
  IconDownload,
  IconCurrencyDollar,
  IconPercentage,
  IconCategory,
};

// "Purely display" components generated by
// js/scripts/generate-components.js (see R/generated-components.R on the
// R side). Each wrapped with withReactiveProps() so it can be updated via
// updateMantineProps().
Object.keys(generatedComponents).forEach((key) => {
  components[key] = withReactiveProps(generatedComponents[key]);
});

// ---------------------------------------------------------------------------
// Deserialization: JSON tree generated by mantineElement() (R) -> React.
// ---------------------------------------------------------------------------

const { buildElement } = createBuildElement(components);

// ---------------------------------------------------------------------------
// Mount: reads the JSON embedded in the container and mounts the React tree.
// ---------------------------------------------------------------------------

const roots = {};

function doMount(containerId) {
  const container = document.getElementById(containerId);
  const dataNode = container.querySelector('.shiny-mantine-data');
  const data = JSON.parse(dataNode.textContent);
  const root = createRoot(container);
  roots[containerId] = root;
  root.render(buildElement(data));
}

// The bundle is loaded and executed before Shiny has finished initializing
// the session (websocket connected, `Shiny.setInputValue` & co. ready). If
// we mount right away, stateful components' `useEffect`s (e.g. TextInput)
// may call `Shiny.setInputValue` while it isn't ready yet, crashing the
// render (no Error Boundary => root unmounted). We wait for
// `Shiny.initializedPromise`, the same conceptual mechanism used by
// shiny.react (`onceShinyInitialized`).
function mount(containerId) {
  if (window.Shiny && window.Shiny.initializedPromise) {
    window.Shiny.initializedPromise.then(() => doMount(containerId));
  } else {
    doMount(containerId);
  }
}

// ---------------------------------------------------------------------------
// Generic Shiny output binding: mantineOutput()/renderMantine() (R side)
// let the server reactively recompute an entire Mantine sub-tree, like
// uiOutput()/renderUI() but for Mantine. Unlike the initial static mount,
// here the data arrives already deserialized via Shiny's standard output
// channel (no manual JSON.parse needed).
// ---------------------------------------------------------------------------
if (window.Shiny) {
  const outputBinding = new window.Shiny.OutputBinding();
  outputBinding.find = (scope) => scope.find('.shiny-mantine-output');
  outputBinding.renderValue = (el, data) => {
    if (data === null || data === undefined) return;
    let root = roots[el.id];
    if (!root) {
      root = createRoot(el);
      roots[el.id] = root;
    }
    root.render(buildElement(data));
  };
  window.Shiny.outputBindings.register(outputBinding, 'shiny.mantine.output');
}

window.jsmodule = {
  ...window.jsmodule,
  '@/shiny.mantine': { mount },
};
