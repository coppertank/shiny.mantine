import { ModalsProvider, modals } from '@mantine/modals';

export const components = { ModalsProvider };

// The imperative confirm/prompt API, used directly by index.js's
// shinyMantineOpen(Confirm)Modal/shinyMantineClose(All)Modals message
// handlers (dynamic-imported the same way as the component above, sharing
// the same cached chunk request - see js/src/lazy.js).
export { modals };
