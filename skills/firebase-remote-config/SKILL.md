---
name: firebase-remote-config
description: "Integrates Firebase Remote Config into Flutter apps. Use when implementing feature flags, creating A/B tests, managing remote parameter defaults, fetching and activating config values, implementing real-time config updates, or configuring throttling intervals. Trigger terms: remote config, feature flags, A/B testing, fetchAndActivate, dynamic configuration, conditional targeting, kill switch."
---

# Firebase Remote Config Skill

This skill defines how to correctly use Firebase Remote Config in Flutter applications.

## When to Use

Use this skill when:

* Implementing feature flags or remote configuration without deploying app updates.
* Managing parameter defaults and fetching remote values.
* Implementing real-time config updates for instant changes.
* Setting up A/B testing or conditional targeting for user segments.

---

## 1. Setup and Configuration

```
flutter pub add firebase_remote_config
flutter pub add firebase_analytics  # required for conditional targeting of app instances
```

```dart
import 'package:firebase_remote_config/firebase_remote_config.dart';

final remoteConfig = FirebaseRemoteConfig.instance;
```

- Enable **Google Analytics** in the Firebase project for user property and audience targeting.
- Ensure the **Remote Config REST API** is not disabled — the SDK depends on it.
- For **macOS**, enable Keychain Sharing in Xcode.

**Configure settings:**

```dart
await remoteConfig.setConfigSettings(RemoteConfigSettings(
  fetchTimeout: const Duration(minutes: 1),
  minimumFetchInterval: const Duration(hours: 1),
));
```

---

## 2. Parameter Management

**Set in-app defaults** (ensures the app behaves as intended before connecting to the backend):

```dart
await remoteConfig.setDefaults(const {
  "feature_new_onboarding": false,
  "max_retry_attempts": 3,
  "welcome_message": "Hello, world!",
  "promo_discount_pct": 0.0,
});
```

**Read values with type-specific getters:**

```dart
final showNewOnboarding = remoteConfig.getBool("feature_new_onboarding");
final maxRetries = remoteConfig.getInt("max_retry_attempts");
final welcomeMsg = remoteConfig.getString("welcome_message");
final discount = remoteConfig.getDouble("promo_discount_pct");
```

- **Never** store confidential data in Remote Config keys or values — they can be accessed by end users.
- Define parameters with the **same names** in the Firebase console as those in the app.
- Group related parameters with common prefixes (e.g., `login_timeout`, `login_attempts_max`).

---

## 3. Fetching and Activating

```dart
await remoteConfig.fetchAndActivate();
```

- Use `fetchAndActivate()` to fetch and apply values in a single call.
- Alternatively, call `fetch()` then `activate()` separately to control when values take effect.
- Activate fetched values at appropriate times (e.g., app start) for a smooth user experience.
- Check `remoteConfig.lastFetchStatus` to determine if the fetch was successful, failed, or throttled.
- Handle fetch failures gracefully — default values are used automatically when fetch fails.

---

## 4. Real-time Updates

```dart
remoteConfig.onConfigUpdated.listen((event) async {
  await remoteConfig.activate();
  // event.updatedKeys contains the changed parameter names
  if (event.updatedKeys.contains("feature_new_onboarding")) {
    // Refresh UI based on the new value
  }
});
```

- Real-time Remote Config is **not available for Web**.
- Update UI state when new configuration values are activated.
- Ensure real-time updates do not disrupt the user experience mid-flow.

---

## 5. Throttling and Performance

- Fetch calls are **throttled** if an app fetches too frequently.
- Default minimum fetch interval in production: **12 hours**.
- For development, use a shorter interval — but only in debug builds:

```dart
await remoteConfig.setConfigSettings(RemoteConfigSettings(
  fetchTimeout: const Duration(minutes: 1),
  minimumFetchInterval: const Duration(minutes: 5),
));
```

- Be mindful of **service-side quota limits** with a large user base.

---

## 6. Testing and Debugging

- Use **conditional values** in the Firebase console to test configurations without new app deployments.
- Implement **A/B testing** with different parameter values for different user segments.
- Test the app with both default and remote values.
- Verify graceful handling of configuration changes at runtime.
- Test **offline behavior** to ensure proper fallback to defaults.

---

## References

- [Firebase Remote Config Flutter documentation](https://firebase.google.com/docs/remote-config/get-started?platform=flutter)
