# Setup: console, billing, App Check

## Console path

Firebase console, create project, **Firebase AI Logic** in the sidebar, choose
a provider, then follow the API-enablement checklist. The wizard hands off to
the CLI, which needs the Flutter project to already exist:

```bash
dart pub global activate flutterfire_cli
```

```bash
flutterfire configure --project=YOUR_PROJECT_ID
```

That registers the per-platform apps and writes `lib/firebase_options.dart`.

## Two toggles the wizard turns on for you

Both default to on and are easy to accept without noticing. Neither is required
by Firebase AI Logic, and neither is yours to decide. Surface them to whoever
owns the project rather than picking silently.

**Gemini in Firebase** is the console-side AI assistant. It is separate from
Firebase AI Logic, so turning it off does not affect your image calls.
Accepting it also accepts the GCP ToS and the Generative AI Service Specific
Terms, which some organisations need to review first. Leave it on if the team
wants the assistant.

**Google Analytics** creates a linked Analytics property. Weigh it as a
data-collection decision. It brings a privacy policy and consent obligations in
some jurisdictions, and it feeds Crashlytics audiences and Remote Config
targeting if the project uses them. Enabling it later means creating the
property and re-running `flutterfire configure`.

If the project has an existing convention for either, follow it. If not, ask
before creating the project, because both are more annoying to change
afterwards than to set correctly now.

## Provider choice

| | Gemini Developer API (`FirebaseAI.googleAI()`) | Vertex AI (`FirebaseAI.vertexAI()`) |
| --- | --- | --- |
| Plan | Spark works for text | Blaze required, always |
| Setup | Minimal | GCP project surface |
| Image generation | Blaze required | Blaze required |
| Pick it when | Default | Already on Vertex, or you need GCP-side controls |

Neither provider gives you free image generation. The difference is only where
text-model work is free.

## Billing

Image generation has no free tier. On Spark the image models report `limit: 0`
for `generate_content_free_tier_requests`, so the very first request fails on
quota having made zero requests. That looks like a broken key or a wrong model
ID, and it sends people editing code that is already correct.

Upgrade to Blaze under console, settings, Usage and billing, Modify plan. Blaze
is pay-as-you-go and the existing free tiers still apply where they exist, so
services other than image generation cost what they cost today. Set a budget
alert at the same time, since image generation is the one line item here with
no free allowance and a runaway retry loop bills immediately.

Check current limits directly rather than trusting any written note, because
quota policy moves:

```bash
gcloud services quota list --service=generativelanguage.googleapis.com --consumer=projects/YOUR_PROJECT_ID
```

## App Check

Firebase AI Logic enforces App Check when the project has it enabled. Without
it, anyone who pulls your Firebase config out of the shipped client can bill
generations to your project. The config is public by design, so this is a real
exposure the moment the app leaves your machine.

Register each app under console, App Check, then activate in `main()` before
the first AI call:

```dart
await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
await FirebaseAppCheck.instance.activate(
  providerWeb: kReleaseMode
      ? ReCaptchaV3Provider(_siteKey)
      : WebDebugProvider(debugToken: _debugToken.isEmpty ? null : _debugToken),
);
```

### The web debug-token trap

`WebDebugProvider()` with no token makes the SDK mint a fresh UUID per browser,
and each one needs its own registration in the console. You register one, it
works, then you open a different browser or a fresh profile and it fails again.
That reads as flaky App Check rather than as a new token each time.

Register one fixed debug token in the console and pass it to the constructor.
Do not set `self.FIREBASE_APPCHECK_DEBUG_TOKEN` yourself beforehand: the plugin
sets that global while resolving the provider, and overwrites whatever is there
with `true` when no token was supplied, silently undoing the value you just
pinned.

### Which keys may live in source

The reCAPTCHA v3 **site** key is public by design. It ships in the client and
is visible to anyone who loads the page, so keeping it in source is fine. The
matching **secret** key lives only in the console and must never appear in the
repo.

The App Check debug token is a bypass credential. Keep it out of source and
supply it per environment:

```bash
flutter run --dart-define=APPCHECK_DEBUG_TOKEN=your-token
```

Read both with `String.fromEnvironment`, giving the site key a default and the
debug token none.

### Before shipping

`ReCaptchaV3Provider` never executes in debug, which makes the release path the
most likely thing to break in production and the least reachable by any test.
Add `localhost` to the reCAPTCHA key's domain list and run a release build
locally once. That exercises the real provider end to end before you deploy.
