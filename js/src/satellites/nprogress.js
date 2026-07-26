import { NavigationProgress, nprogress } from '@mantine/nprogress';
import '@mantine/nprogress/styles.css';

export const components = { NavigationProgress };

// Imperative API, used directly by index.js's shinyMantineProgress message
// handler (dynamic-imported the same way as the component above, sharing
// the same cached chunk request - see js/src/lazy.js).
export { nprogress };
