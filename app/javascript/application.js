// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

import "@fortawesome/fontawesome-free/js/all";

import * as Sentry from "@sentry/browser";

Sentry.init({
  dsn: "https://20df4b8103f614ddea1b07b9792c2cf0@o4508080849158144.ingest.de.sentry.io/4508080856891472",

  integrations: [
    Sentry.browserTracingIntegration(),
    Sentry.replayIntegration(),
  ],

  // Set tracesSampleRate to 1.0 to capture 100% of transactions for tracing.
  // We recommend adjusting this value in production
  // Learn more at
  // https://docs.sentry.io/platforms/javascript/configuration/options/#traces-sample-rate
  tracesSampleRate: 1.0,

  // Set `tracePropagationTargets` to control for which URLs trace propagation should be enabled
  tracePropagationTargets: ["localhost", /^https:\/\/scrooge\.onrender\.com/],

  // Capture Replay for 10% of all sessions, plus for 100% of sessions with an error
  // Learn more at
  // https://docs.sentry.io/platforms/javascript/session-replay/configuration/#general-integration-configuration
  replaysSessionSampleRate: 0.1,
  replaysOnErrorSampleRate: 1.0
});
