import { Notifications, notifications } from '@mantine/notifications';
import '@mantine/notifications/styles.css';

export const components = { Notifications };

// The imperative show()/hide() API, used directly by index.js's
// shinyMantineNotification/shinyMantineHideNotification message handlers
// (dynamic-imported the same way as the component above, sharing the same
// cached chunk request - see js/src/lazy.js).
export { notifications };
