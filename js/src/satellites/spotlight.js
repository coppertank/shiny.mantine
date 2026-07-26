import React from 'react';
import {
  Spotlight,
  SpotlightRoot,
  SpotlightSearch,
  SpotlightActionsList,
  SpotlightActionsGroup,
  SpotlightAction,
  SpotlightEmpty,
  SpotlightFooter,
} from '@mantine/spotlight';
import '@mantine/spotlight/styles.css';
import { setShinyValue, withReactiveProps, withShinyClickValue } from '../shared';

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

export const components = {
  Spotlight: ShinySpotlight,
  SpotlightRoot: withReactiveProps(SpotlightRoot),
  SpotlightSearch: withReactiveProps(SpotlightSearch),
  SpotlightActionsList: withReactiveProps(SpotlightActionsList),
  SpotlightActionsGroup: withReactiveProps(SpotlightActionsGroup),
  SpotlightAction: withShinyClickValue(SpotlightAction),
  SpotlightEmpty: withReactiveProps(SpotlightEmpty),
  SpotlightFooter: withReactiveProps(SpotlightFooter),
};
