import React, { useEffect, useState } from 'react';

// ---------------------------------------------------------------------------
// Code-splitting for Mantine's satellite packages (dates, notifications,
// modals, spotlight, charts, code-highlight, nprogress, tiptap, dropzone,
// carousel): each ships its own JS + CSS that, before this module existed,
// was bundled unconditionally into inst/www/mantine.js and injected into
// every single Shiny app built with this package, whether or not that app
// actually used any component from that family (e.g. a bare
// `MantineProvider()` app was still paying for Tiptap's editor code and
// Recharts). Every satellite lives in its own webpack chunk (js/src/
// satellites/*.js, dynamically import()ed) and is fetched the first time a
// component from that family is actually mounted.
// ---------------------------------------------------------------------------

const modulePromises = {};

// Kicks off (once) and caches the dynamic import() for a given family, so
// several components backed by the same satellite (e.g. Dropzone/
// Dropzone.Accept/Dropzone.Reject/Dropzone.Idle) share a single chunk
// request instead of triggering it once per component.
function loadOnce(family, importFn) {
  if (!modulePromises[family]) modulePromises[family] = importFn();
  return modulePromises[family];
}

function useLazyModule(family, importFn) {
  const [mod, setMod] = useState(null);
  useEffect(() => {
    let alive = true;
    loadOnce(family, importFn).then((loaded) => { if (alive) setMod(loaded); });
    return () => { alive = false; };
  }, [family]);
  return mod;
}

// Every satellite chunk (js/src/satellites/*.js) exports its whole set of
// ready-to-register components as a single `components` dict (mirroring
// index.js's own registry) rather than many named exports - this sidesteps
// having to rename every import to dodge collisions between the raw
// Mantine component name (e.g. `DateInput` imported from `@mantine/dates`)
// and the Shiny-wired version registered under the same name.

// For leaf/display components (charts, DateInput, Spotlight, ...): renders
// nothing until the chunk backing `family` resolves, then the real
// component with every prop (including `children`) forwarded unchanged.
// The blank gap only ever happens once per family per page load - Shiny
// prop updates re-render with the already-resolved component instantly.
export function lazyLeaf(family, importFn, exportName) {
  return function LazyLeaf(props) {
    const mod = useLazyModule(family, importFn);
    if (!mod) return null;
    return React.createElement(mod.components[exportName], props);
  };
}

// For provider/wrapper components that render `children` regardless of
// their own state (ModalsProvider): renders `children` directly (unwrapped)
// while the chunk loads, then re-renders wrapped in the real provider once
// it resolves, so content already on the page never disappears while a
// heavier satellite loads in the background.
export function lazyWrapper(family, importFn, exportName) {
  return function LazyWrapper({ children, ...props }) {
    const mod = useLazyModule(family, importFn);
    if (!mod) return React.createElement(React.Fragment, null, children);
    return React.createElement(mod.components[exportName], props, children);
  };
}
