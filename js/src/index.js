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
  useModalsStack,
  useDrawersStack,
  ModalRoot,
  DrawerRoot,
  PaginationRoot,
  HueSlider,
  AlphaSlider,
  AngleSlider,
  RadioIndicator,
  CheckboxIndicator,
  Combobox,
  useCombobox,
  ComboboxPopover,
  OverflowList,
  TableOfContents,
  Cascader,
  FloatingWindow,
} from '@mantine/core';
import { DragDropContext, Droppable, Draggable } from '@hello-pangea/dnd';
import { generatedComponents } from './generated-components';
import { reorder, createBuildElement } from './serialization';
import {
  inputUpdateHandlers,
  setShinyValue,
  withShinyEventInput,
  withShinyValueInput,
  withShinyClickValue,
  propUpdateHandlers,
  withReactiveProps,
} from './shared';
import { lazyLeaf, lazyWrapper } from './lazy';
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
import './bootstrap-overrides.css';

// ---------------------------------------------------------------------------
// Shiny <-> React bridge
//
// We don't reuse shiny.react's InputAdapter/ButtonAdapter (they're compiled
// against the React 18 copy shared by shiny.react and would use hooks tied
// to that React module, incompatible with our own React 19 copy). The
// functions below reimplement the same concept (Shiny.setInputValue + an
// update channel via custom message) using exclusively our own React.
// ---------------------------------------------------------------------------

if (window.Shiny) {
  window.Shiny.addCustomMessageHandler('shinyMantineUpdateInput', ({ inputId, value }) => {
    const handler = inputUpdateHandlers[inputId];
    if (handler) handler(value);
  });
}

// A boolean component whose value changes via
// `event.currentTarget.checked` (e.g. Switch/Checkbox): uses `checked`
// instead of `value`.
function withShinyCheckedInput(Component) {
  return function Wrapped({ inputId, value: initialValue, onChange, ...props }) {
    const [checked, setChecked] = useState(Boolean(initialValue));
    const skipEcho = useRef(false);

    useEffect(() => {
      if (skipEcho.current) { skipEcho.current = false; return; }
      setShinyValue(inputId, checked);
    }, [inputId, checked]);

    useEffect(() => {
      inputUpdateHandlers[inputId] = (v) => { skipEcho.current = true; setChecked(Boolean(v)); };
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
if (window.Shiny) {
  window.Shiny.addCustomMessageHandler('shinyMantineUpdateProps', ({ id, props }) => {
    const handler = propUpdateHandlers[id];
    if (handler) handler(props);
  });
}

// ---------------------------------------------------------------------------
// @mantine/notifications, @mantine/modals, @mantine/nprogress: each is an
// imperative API (show a toast / open a confirm dialog / drive a progress
// bar) triggered directly by a custom message from R, with no React element
// of its own necessarily on screen yet - unlike a lazyLeaf()-wrapped
// component (whose own mount is what triggers the chunk fetch), these
// handlers must kick off the dynamic import() themselves, the first time
// each message type actually arrives. Every call below shares the same
// cached chunk request as the matching lazyLeaf()/lazyWrapper() entries in
// the components registry (see js/src/lazy.js), so using e.g. Notifications
// in the UI *and* showMantineNotification() from the server only ever
// downloads @mantine/notifications once.
// ---------------------------------------------------------------------------
if (window.Shiny) {
  window.Shiny.addCustomMessageHandler('shinyMantineNotification', (payload) => {
    import(/* webpackChunkName: "notifications" */ './satellites/notifications').then(({ notifications }) => notifications.show(payload));
  });
  window.Shiny.addCustomMessageHandler('shinyMantineHideNotification', (id) => {
    import(/* webpackChunkName: "notifications" */ './satellites/notifications').then(({ notifications }) => notifications.hide(id));
  });
}

if (window.Shiny) {
  window.Shiny.addCustomMessageHandler('shinyMantineOpenConfirmModal', ({ inputId, ...payload }) => {
    import(/* webpackChunkName: "modals" */ './satellites/modals').then(({ modals }) => modals.openConfirmModal({
      ...payload,
      onConfirm: () => setShinyValue(inputId, true, { priority: 'event' }),
      onCancel: () => setShinyValue(inputId, false, { priority: 'event' }),
    }));
  });
  window.Shiny.addCustomMessageHandler('shinyMantineOpenModal', (payload) => {
    import(/* webpackChunkName: "modals" */ './satellites/modals').then(({ modals }) => modals.open(payload));
  });
  window.Shiny.addCustomMessageHandler('shinyMantineCloseModal', (id) => {
    import(/* webpackChunkName: "modals" */ './satellites/modals').then(({ modals }) => modals.close(id));
  });
  // Shiny.addCustomMessageHandler() requires a handler with exactly one
  // argument (even though no payload is needed here) — a zero-arity
  // handler makes the registration throw and breaks the whole script.
  window.Shiny.addCustomMessageHandler('shinyMantineCloseAllModals', (_unused) => {
    import(/* webpackChunkName: "modals" */ './satellites/modals').then(({ modals }) => modals.closeAll());
  });
}

if (window.Shiny) {
  window.Shiny.addCustomMessageHandler('shinyMantineProgress', ({ action, value }) => {
    import(/* webpackChunkName: "nprogress" */ './satellites/nprogress').then(({ nprogress }) => {
      if (action === 'start') nprogress.start();
      else if (action === 'stop') nprogress.stop();
      else if (action === 'set') nprogress.set(value);
      else if (action === 'increment') nprogress.increment(value);
      else if (action === 'decrement') nprogress.decrement(value);
      else if (action === 'complete') nprogress.complete();
      else if (action === 'reset') nprogress.reset();
    });
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
// ModalStack()/DrawerStack(): a standalone Modal()/Drawer() (above) only
// ever manages its own `opened` boolean, so more than one open at once
// doesn't layer/animate correctly - each mounts an independent overlay and
// focus trap, competing rather than coordinating. Mantine's own fix for
// this is useModalsStack()/useDrawersStack() + <Modal.Stack>/<Drawer.Stack>:
// one shared controller (state/open/close/closeAll/register), with
// register(id) returning the {opened, onClose, stackId} props a stacked
// Modal/Drawer needs.
//
// ModalStackContext/DrawerStackContext hands that controller down to any
// Modal()/Drawer() mounted underneath; withStackableOpen (replacing
// withControlledOpen for just these two) picks it up when present. The R
// API is unchanged either way: updateMantineProps(session, mantineId,
// opened = TRUE/FALSE) keeps working, just translated into
// stack.open(mantineId)/stack.close(mantineId) instead of purely local
// state when the modal/drawer is inside a stack - so a Modal()/Drawer()
// doesn't need to "know" whether it's stacked.
// ---------------------------------------------------------------------------
const ModalStackContext = React.createContext(null);
const DrawerStackContext = React.createContext(null);

function stackIdsFromChildren(children) {
  return React.Children.toArray(children)
    .map((child) => child && child.props && child.props.mantineId)
    .filter(Boolean);
}

function withStackableOpen(Component, StackContext) {
  return function Wrapped({
    inputId, mantineId, opened: initialOpened, onClose, ...props
  }) {
    // Replaces the withReactiveProps(withControlledOpen(...)) composition
    // used for every other overlay: withReactiveProps() consumes
    // `mantineId` to key its patch subscription but does not forward it
    // down to the wrapped component, so a Modal/Drawer nested behind it
    // would never learn its own `mantineId` - needed here for stack
    // registration. Rather than change withReactiveProps() (used by ~100
    // other, non-stack-aware components, where forwarding `mantineId`
    // would leak it as an unrecognized DOM attribute), this HOC
    // duplicates its small patch-subscription mechanism directly.
    const [patch, setPatch] = useState({});
    useEffect(() => {
      if (!mantineId) return undefined;
      propUpdateHandlers[mantineId] = (newProps) => setPatch((prev) => ({ ...prev, ...newProps }));
      return () => { delete propUpdateHandlers[mantineId]; };
    }, [mantineId]);

    const opened = patch.opened !== undefined ? patch.opened : initialOpened;
    const otherPatch = { ...patch };
    delete otherPatch.opened;

    const stack = useContext(StackContext);
    const inStack = Boolean(stack && mantineId && stack.state[mantineId] !== undefined);

    const [localOpened, setLocalOpened] = useState(Boolean(opened));
    useEffect(() => { setLocalOpened(Boolean(opened)); }, [opened]);

    // Translate opened prop transitions (own local state above, whether
    // from the initial prop or an updateMantineProps() patch) into
    // stack.open()/stack.close() calls, so R's existing API keeps working
    // unchanged for a stacked modal/drawer too.
    const prevOpened = useRef(Boolean(opened));
    useEffect(() => {
      if (!inStack) return;
      if (opened && !prevOpened.current) stack.open(mantineId);
      if (!opened && prevOpened.current) stack.close(mantineId);
      prevOpened.current = Boolean(opened);
    }, [inStack, opened, mantineId, stack]);

    if (inStack) {
      const registered = stack.register(mantineId);
      return React.createElement(Component, {
        ...props,
        ...otherPatch,
        ...registered,
        onClose: () => {
          registered.onClose();
          setShinyValue(inputId, false, { priority: 'event' });
          if (onClose) onClose();
        },
      });
    }

    return React.createElement(Component, {
      ...props,
      ...otherPatch,
      opened: localOpened,
      onClose: () => {
        setLocalOpened(false);
        setShinyValue(inputId, false, { priority: 'event' });
        if (onClose) onClose();
      },
    });
  };
}

function ShinyModalStack({ closeAll, children }) {
  const ids = useMemo(() => stackIdsFromChildren(children), [children]);
  const stack = useModalsStack(ids);
  const prevCloseAll = useRef(false);
  useEffect(() => {
    if (closeAll && !prevCloseAll.current) stack.closeAll();
    prevCloseAll.current = Boolean(closeAll);
  }, [closeAll, stack]);

  return React.createElement(
    ModalStackContext.Provider,
    { value: stack },
    React.createElement(Modal.Stack, {}, children),
  );
}

function ShinyDrawerStack({ closeAll, children }) {
  const ids = useMemo(() => stackIdsFromChildren(children), [children]);
  const stack = useDrawersStack(ids);
  const prevCloseAll = useRef(false);
  useEffect(() => {
    if (closeAll && !prevCloseAll.current) stack.closeAll();
    prevCloseAll.current = Boolean(closeAll);
  }, [closeAll, stack]);

  return React.createElement(
    DrawerStackContext.Provider,
    { value: stack },
    React.createElement(Drawer.Stack, {}, children),
  );
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

// ---------------------------------------------------------------------------
// Combobox: Mantine's headless building block for fully custom select-like
// components (Select/MultiSelect/Autocomplete/TagsInput/PillsInput are all
// built on top of it internally). The real component requires a live
// useCombobox() store (an imperative JS object with methods, e.g.
// combobox.toggleDropdown()) passed as its `store` prop - unlike every
// other prop in this package, that store cannot be expressed as JSON and
// cross the R/JS bridge. ShinyCombobox below creates and owns that store
// internally, so the R API (R/Combobox.R) stays fully declarative.
// ---------------------------------------------------------------------------
const ComboboxRawContext = React.createContext(null);

function ShinyCombobox({
  inputId, opened: initialOpened, onOptionSubmit, children, ...props
}) {
  const [localOpened, setLocalOpened] = useState(Boolean(initialOpened));
  useEffect(() => { setLocalOpened(Boolean(initialOpened)); }, [initialOpened]);

  const combobox = useCombobox({
    opened: localOpened,
    onOpenedChange: setLocalOpened,
    onDropdownClose: () => combobox.resetSelectedOption(),
  });

  return React.createElement(
    ComboboxRawContext.Provider,
    { value: combobox },
    React.createElement(Combobox, {
      ...props,
      store: combobox,
      onOptionSubmit: (value) => {
        setLocalOpened(false);
        setShinyValue(inputId, value, { priority: 'event' });
        if (onOptionSubmit) onOptionSubmit(value);
      },
    }, children),
  );
}

// Combobox.Target only wires aria-*/keyboard handling in real Mantine -
// opening on click must be added by hand in every vanilla example
// (`onClick={() => combobox.toggleDropdown()}`). Since an R-built target
// (e.g. Button()) can't attach that itself, this clones the single child
// to splice the handler in automatically.
function ShinyComboboxTarget({ children, ...props }) {
  const combobox = useContext(ComboboxRawContext);
  const child = React.Children.only(children);
  return React.createElement(
    Combobox.Target,
    props,
    React.cloneElement(child, {
      onClick: (event) => {
        if (combobox) combobox.toggleDropdown();
        if (child.props.onClick) child.props.onClick(event);
      },
    }),
  );
}

// Combobox.Search: the free-text field inside a searchable custom
// combobox's dropdown - wired like any other Shiny text input
// (input[[inputId]] on every keystroke), so the server can re-render
// ComboboxOptions() (via renderMantine()/mantineOutput()) to filter as the
// user types, since an R-side filter function can't cross the bridge the
// way Mantine's own `filter` prop does. Also opens the dropdown on focus
// and keeps the store's selected-option index in sync, matching Mantine's
// own searchable examples.
function ShinyComboboxSearch({
  inputId, value: initialValue, onChange, onFocus, ...props
}) {
  const combobox = useContext(ComboboxRawContext);
  const [value, setValue] = useState(initialValue ?? '');

  useEffect(() => {
    inputUpdateHandlers[inputId] = (v) => setValue(v ?? '');
    return () => { delete inputUpdateHandlers[inputId]; };
  }, [inputId]);

  return React.createElement(Combobox.Search, {
    ...props,
    value,
    onChange: (event) => {
      const v = event.currentTarget.value;
      setValue(v);
      if (combobox) combobox.updateSelectedOptionIndex();
      setShinyValue(inputId, v);
      if (onChange) onChange(event);
    },
    onFocus: (event) => {
      if (combobox) combobox.openDropdown();
      if (onFocus) onFocus(event);
    },
  });
}

// ---------------------------------------------------------------------------
// OverflowList: real Mantine requires `renderItem`/`renderOverflow` render
// functions (not serializable). `children` here are already fully-built
// elements (one per item, built however the caller likes in R); the
// overflow indicator is a plain Badge whose label is `overflowLabel` with
// "{n}" substituted for the hidden count, since an arbitrary R-side render
// function can't cross the bridge either.
// ---------------------------------------------------------------------------
function ShinyOverflowList({ children, overflowLabel, ...props }) {
  const items = React.Children.toArray(children);
  return React.createElement(OverflowList, {
    ...props,
    data: items,
    renderItem: (item) => item,
    renderOverflow: (hidden) => React.createElement(
      Badge,
      {},
      (overflowLabel || '+{n}').replace('{n}', hidden.length),
    ),
  });
}

// ---------------------------------------------------------------------------
// TableOfContents: autonomously scans the real DOM (via use-scroll-spy) for
// headings matching `scrollSpySelector` and highlights whichever is
// currently in view. `getControlProps` (a JS callback) is hardcoded to
// Mantine's own documented recipe (scrollIntoView() + the heading text as
// label) - the only part that can't be customized from R.
// ---------------------------------------------------------------------------
function ShinyTableOfContents({ scrollSpySelector, scrollSpyOptions, ...props }) {
  return React.createElement(TableOfContents, {
    ...props,
    scrollSpyOptions: { selector: scrollSpySelector, ...scrollSpyOptions },
    getControlProps: ({ data }) => ({
      onClick: () => data.getNode().scrollIntoView(),
      children: data.value,
    }),
  });
}

// FloatingWindow: reports resize interactions to Shiny when inputId is set
// (onSizeChange/onResizeStart/onResizeEnd, added in Mantine 9.5.1) - the
// window's live drag *position* still isn't reported (needs a client-side
// ref, see the note in R/AdvancedComponents.R), only its resized size.
function ShinyFloatingWindow({
  inputId, onSizeChange, onResizeStart, onResizeEnd, ...props
}) {
  return React.createElement(FloatingWindow, {
    ...props,
    onSizeChange: (size) => {
      if (inputId) setShinyValue(inputId, size);
      if (onSizeChange) onSizeChange(size);
    },
    onResizeStart: () => {
      if (inputId) setShinyValue(`${inputId}_resize_start`, true, { priority: 'event' });
      if (onResizeStart) onResizeStart();
    },
    onResizeEnd: () => {
      if (inputId) setShinyValue(`${inputId}_resize_end`, true, { priority: 'event' });
      if (onResizeEnd) onResizeEnd();
    },
  });
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
  // FloatingWindow itself is hand-wired (see ShinyFloatingWindow above) to
  // report resize events (added in Mantine 9.5.1), no longer a plain
  // js/scripts/generate-components.js passthrough. Its
  // FloatingWindow.ResizeHandle sub-part (new in 9.5) is only reachable
  // via property access on FloatingWindow, unlike most other compound
  // sub-parts this package generates (which assume a separate flattened
  // named export exists, e.g. ListItem for List.Item) - hand-registered
  // here too.
  FloatingWindow: withReactiveProps(ShinyFloatingWindow),
  'FloatingWindow.ResizeHandle': withReactiveProps(FloatingWindow.ResizeHandle),
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
  HueSlider: withReactiveProps(withShinyValueInput(HueSlider)),
  AlphaSlider: withReactiveProps(withShinyValueInput(AlphaSlider)),
  AngleSlider: withReactiveProps(withShinyValueInput(AngleSlider)),
  Radio: withReactiveProps(Radio),
  RadioIndicator: withReactiveProps(RadioIndicator),
  CheckboxIndicator: withReactiveProps(CheckboxIndicator),
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
  PaginationRoot: withReactiveProps(withShinyValueInput(PaginationRoot)),
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
  Modal: withStackableOpen(Modal, ModalStackContext),
  ModalRoot: withStackableOpen(ModalRoot, ModalStackContext),
  ModalStack: withReactiveProps(ShinyModalStack),
  Drawer: withStackableOpen(Drawer, DrawerStackContext),
  DrawerRoot: withStackableOpen(DrawerRoot, DrawerStackContext),
  DrawerStack: withReactiveProps(ShinyDrawerStack),
  Dialog: withReactiveProps(withControlledOpen(Dialog)),
  Popover: withReactiveProps(withControlledOpen(Popover)),
  'Popover.Target': Popover.Target,
  'Popover.Dropdown': Popover.Dropdown,
  Affix: withReactiveProps(Affix),
  LoadingOverlay: withReactiveProps(LoadingOverlay),
  Combobox: withReactiveProps(ShinyCombobox),
  'Combobox.Target': ShinyComboboxTarget,
  'Combobox.EventsTarget': Combobox.EventsTarget,
  'Combobox.DropdownTarget': Combobox.DropdownTarget,
  'Combobox.Dropdown': Combobox.Dropdown,
  'Combobox.Options': Combobox.Options,
  'Combobox.Option': Combobox.Option,
  'Combobox.Search': withReactiveProps(ShinyComboboxSearch),
  'Combobox.Empty': Combobox.Empty,
  'Combobox.Footer': Combobox.Footer,
  'Combobox.Header': Combobox.Header,
  'Combobox.Group': Combobox.Group,
  'Combobox.Chevron': Combobox.Chevron,
  'Combobox.ClearButton': Combobox.ClearButton,
  'Combobox.HiddenInput': Combobox.HiddenInput,
  ComboboxPopover: withReactiveProps(withShinyValueInput(ComboboxPopover)),
  'ComboboxPopover.Target': ComboboxPopover.Target,
  OverflowList: withReactiveProps(ShinyOverflowList),
  TableOfContents: withReactiveProps(ShinyTableOfContents),
  // Every entry from here down through Carousel.Slide is backed by a
  // separate Mantine satellite package (dates, notifications, modals,
  // spotlight, charts, code-highlight, nprogress, tiptap, dropzone,
  // carousel), lazily fetched (JS + its own CSS) on first actual use via
  // lazyLeaf()/lazyWrapper() (js/src/lazy.js) rather than bundled
  // unconditionally into every app - see js/src/satellites/*.js for each
  // family's real component definitions.
  DateInput: lazyLeaf('dates', () => import(/* webpackChunkName: "dates" */ './satellites/dates'), 'DateInput'),
  DatePickerInput: lazyLeaf('dates', () => import(/* webpackChunkName: "dates" */ './satellites/dates'), 'DatePickerInput'),
  DatePicker: lazyLeaf('dates', () => import(/* webpackChunkName: "dates" */ './satellites/dates'), 'DatePicker'),
  TimeInput: lazyLeaf('dates', () => import(/* webpackChunkName: "dates" */ './satellites/dates'), 'TimeInput'),
  MonthPickerInput: lazyLeaf('dates', () => import(/* webpackChunkName: "dates" */ './satellites/dates'), 'MonthPickerInput'),
  YearPickerInput: lazyLeaf('dates', () => import(/* webpackChunkName: "dates" */ './satellites/dates'), 'YearPickerInput'),
  DateTimePicker: lazyLeaf('dates', () => import(/* webpackChunkName: "dates" */ './satellites/dates'), 'DateTimePicker'),
  TimePicker: lazyLeaf('dates', () => import(/* webpackChunkName: "dates" */ './satellites/dates'), 'TimePicker'),
  TimeGrid: lazyLeaf('dates', () => import(/* webpackChunkName: "dates" */ './satellites/dates'), 'TimeGrid'),
  MiniCalendar: lazyLeaf('dates', () => import(/* webpackChunkName: "dates" */ './satellites/dates'), 'MiniCalendar'),
  InlineDateTimePicker: lazyLeaf('dates', () => import(/* webpackChunkName: "dates" */ './satellites/dates'), 'InlineDateTimePicker'),
  MonthPicker: lazyLeaf('dates', () => import(/* webpackChunkName: "dates" */ './satellites/dates'), 'MonthPicker'),
  YearPicker: lazyLeaf('dates', () => import(/* webpackChunkName: "dates" */ './satellites/dates'), 'YearPicker'),
  TimeValue: lazyLeaf('dates', () => import(/* webpackChunkName: "dates" */ './satellites/dates'), 'TimeValue'),
  DatesProvider: lazyWrapper('dates', () => import(/* webpackChunkName: "dates" */ './satellites/dates'), 'DatesProvider'),
  DirectionProvider,
  Notification: withReactiveProps(Notification),
  Transition: withReactiveProps(ShinyTransition),
  Portal,
  ScrollAreaAutosize,
  NativeScrollArea,
  'Progress.Root': Progress.Root,
  'Progress.Section': withReactiveProps(Progress.Section),
  'Progress.Label': Progress.Label,
  Notifications: lazyLeaf('notifications', () => import(/* webpackChunkName: "notifications" */ './satellites/notifications'), 'Notifications'),
  ModalsProvider: lazyWrapper('modals', () => import(/* webpackChunkName: "modals" */ './satellites/modals'), 'ModalsProvider'),
  Spotlight: lazyLeaf('spotlight', () => import(/* webpackChunkName: "spotlight" */ './satellites/spotlight'), 'Spotlight'),
  SpotlightRoot: lazyLeaf('spotlight', () => import(/* webpackChunkName: "spotlight" */ './satellites/spotlight'), 'SpotlightRoot'),
  SpotlightSearch: lazyLeaf('spotlight', () => import(/* webpackChunkName: "spotlight" */ './satellites/spotlight'), 'SpotlightSearch'),
  SpotlightActionsList: lazyLeaf('spotlight', () => import(/* webpackChunkName: "spotlight" */ './satellites/spotlight'), 'SpotlightActionsList'),
  SpotlightActionsGroup: lazyLeaf('spotlight', () => import(/* webpackChunkName: "spotlight" */ './satellites/spotlight'), 'SpotlightActionsGroup'),
  SpotlightAction: lazyLeaf('spotlight', () => import(/* webpackChunkName: "spotlight" */ './satellites/spotlight'), 'SpotlightAction'),
  SpotlightEmpty: lazyLeaf('spotlight', () => import(/* webpackChunkName: "spotlight" */ './satellites/spotlight'), 'SpotlightEmpty'),
  SpotlightFooter: lazyLeaf('spotlight', () => import(/* webpackChunkName: "spotlight" */ './satellites/spotlight'), 'SpotlightFooter'),
  LineChart: lazyLeaf('charts', () => import(/* webpackChunkName: "charts" */ './satellites/charts'), 'LineChart'),
  BarChart: lazyLeaf('charts', () => import(/* webpackChunkName: "charts" */ './satellites/charts'), 'BarChart'),
  AreaChart: lazyLeaf('charts', () => import(/* webpackChunkName: "charts" */ './satellites/charts'), 'AreaChart'),
  PieChart: lazyLeaf('charts', () => import(/* webpackChunkName: "charts" */ './satellites/charts'), 'PieChart'),
  DonutChart: lazyLeaf('charts', () => import(/* webpackChunkName: "charts" */ './satellites/charts'), 'DonutChart'),
  RadarChart: lazyLeaf('charts', () => import(/* webpackChunkName: "charts" */ './satellites/charts'), 'RadarChart'),
  CompositeChart: lazyLeaf('charts', () => import(/* webpackChunkName: "charts" */ './satellites/charts'), 'CompositeChart'),
  RadialBarChart: lazyLeaf('charts', () => import(/* webpackChunkName: "charts" */ './satellites/charts'), 'RadialBarChart'),
  BubbleChart: lazyLeaf('charts', () => import(/* webpackChunkName: "charts" */ './satellites/charts'), 'BubbleChart'),
  FunnelChart: lazyLeaf('charts', () => import(/* webpackChunkName: "charts" */ './satellites/charts'), 'FunnelChart'),
  Sparkline: lazyLeaf('charts', () => import(/* webpackChunkName: "charts" */ './satellites/charts'), 'Sparkline'),
  ScatterChart: lazyLeaf('charts', () => import(/* webpackChunkName: "charts" */ './satellites/charts'), 'ScatterChart'),
  Treemap: lazyLeaf('charts', () => import(/* webpackChunkName: "charts" */ './satellites/charts'), 'Treemap'),
  Heatmap: lazyLeaf('charts', () => import(/* webpackChunkName: "charts" */ './satellites/charts'), 'Heatmap'),
  SankeyChart: lazyLeaf('charts', () => import(/* webpackChunkName: "charts" */ './satellites/charts'), 'SankeyChart'),
  BarsList: lazyLeaf('charts', () => import(/* webpackChunkName: "charts" */ './satellites/charts'), 'BarsList'),
  SunburstChart: lazyLeaf('charts', () => import(/* webpackChunkName: "charts" */ './satellites/charts'), 'SunburstChart'),
  BulletChart: lazyLeaf('charts', () => import(/* webpackChunkName: "charts" */ './satellites/charts'), 'BulletChart'),
  CodeHighlight: lazyLeaf('codeHighlight', () => import(/* webpackChunkName: "codeHighlight" */ './satellites/codeHighlight'), 'CodeHighlight'),
  InlineCodeHighlight: lazyLeaf('codeHighlight', () => import(/* webpackChunkName: "codeHighlight" */ './satellites/codeHighlight'), 'InlineCodeHighlight'),
  CodeHighlightTabs: lazyLeaf('codeHighlight', () => import(/* webpackChunkName: "codeHighlight" */ './satellites/codeHighlight'), 'CodeHighlightTabs'),
  NavigationProgress: lazyLeaf('nprogress', () => import(/* webpackChunkName: "nprogress" */ './satellites/nprogress'), 'NavigationProgress'),
  RichTextEditor: lazyLeaf('tiptap', () => import(/* webpackChunkName: "tiptap" */ './satellites/tiptap'), 'RichTextEditor'),
  DayView: lazyLeaf('schedule', () => import(/* webpackChunkName: "schedule" */ './satellites/schedule'), 'DayView'),
  WeekView: lazyLeaf('schedule', () => import(/* webpackChunkName: "schedule" */ './satellites/schedule'), 'WeekView'),
  MonthView: lazyLeaf('schedule', () => import(/* webpackChunkName: "schedule" */ './satellites/schedule'), 'MonthView'),
  YearView: lazyLeaf('schedule', () => import(/* webpackChunkName: "schedule" */ './satellites/schedule'), 'YearView'),
  AgendaView: lazyLeaf('schedule', () => import(/* webpackChunkName: "schedule" */ './satellites/schedule'), 'AgendaView'),
  MobileMonthView: lazyLeaf('schedule', () => import(/* webpackChunkName: "schedule" */ './satellites/schedule'), 'MobileMonthView'),
  ResourcesDayView: lazyLeaf('schedule', () => import(/* webpackChunkName: "schedule" */ './satellites/schedule'), 'ResourcesDayView'),
  ResourcesWeekView: lazyLeaf('schedule', () => import(/* webpackChunkName: "schedule" */ './satellites/schedule'), 'ResourcesWeekView'),
  ResourcesMonthView: lazyLeaf('schedule', () => import(/* webpackChunkName: "schedule" */ './satellites/schedule'), 'ResourcesMonthView'),
  Schedule: lazyLeaf('schedule', () => import(/* webpackChunkName: "schedule" */ './satellites/schedule'), 'Schedule'),
  Stepper: withReactiveProps(withShinyStepClick(Stepper)),
  'Stepper.Step': Stepper.Step,
  'Stepper.Completed': Stepper.Completed,
  Tree: withReactiveProps(ShinyTree),
  TreeSelect: withReactiveProps(withShinyValueInput(TreeSelect)),
  // Cascader's onChange(path, options) - withShinyValueInput's own
  // onChange(newValue) only declares/forwards the first argument (path),
  // exactly what should reach Shiny; the second (resolved option objects)
  // is simply dropped, same simplification already applied throughout
  // this package's other callback-based components.
  Cascader: withReactiveProps(withShinyValueInput(Cascader)),
  Collapse: withReactiveProps(ShinyCollapse),
  FileButton: ShinyFileButton,
  Dropzone: lazyLeaf('dropzone', () => import(/* webpackChunkName: "dropzone" */ './satellites/dropzone'), 'Dropzone'),
  'Dropzone.FullScreen': lazyLeaf('dropzone', () => import(/* webpackChunkName: "dropzone" */ './satellites/dropzone'), 'Dropzone.FullScreen'),
  'Dropzone.Accept': lazyLeaf('dropzone', () => import(/* webpackChunkName: "dropzone" */ './satellites/dropzone'), 'Dropzone.Accept'),
  'Dropzone.Reject': lazyLeaf('dropzone', () => import(/* webpackChunkName: "dropzone" */ './satellites/dropzone'), 'Dropzone.Reject'),
  'Dropzone.Idle': lazyLeaf('dropzone', () => import(/* webpackChunkName: "dropzone" */ './satellites/dropzone'), 'Dropzone.Idle'),
  Carousel: lazyLeaf('carousel', () => import(/* webpackChunkName: "carousel" */ './satellites/carousel'), 'Carousel'),
  'Carousel.Slide': lazyLeaf('carousel', () => import(/* webpackChunkName: "carousel" */ './satellites/carousel'), 'Carousel.Slide'),
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
