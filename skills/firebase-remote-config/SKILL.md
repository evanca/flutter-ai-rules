---
name: firebase-remote-config
description: Integrates Firebase Remote Config into Flutter apps. Use when setting up Remote Config, managing parameter defaults, fetching and activating values, implementing real-time updates, or handling throttling and testing.
---

# Firebase Remote Config Skill

This skill defines how to correctly use Firebase Remote Config in Flutter applications.

## When to Use

Use this skill when:

* Setting up Remote Config to configure your app without deploying updates.
* Managing parameter defaults and remote values.
* Fetching, activating, and listening to config updates.
* Applying throttling, A/B testing, or conditional targeting.

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

- Enable **Google Analytics** in your Firebase project for user property and audience targeting.
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

**Set in-app defaults** (ensures your app behaves as intended before connecting to the backend):

```dart
await remoteConfig.setDefaults(const {
  "example_param_1": 42,
  "example_param_2": 3.14159,
  "example_param_3": true,
  "example_param_4": "Hello, world!",
});
```

- **Never** store confidential data in Remote Config keys or values — they can be accessed by end users.
- Use type-specific getters: `getBool()`, `getDouble()`, `getInt()`, `getString()`.
- Define parameters with the **same names** in the Firebase console as those in your app.
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
- Handle fetch failures gracefully by falling back to default values.

---

## 4. Real-time Updates

```dart
remoteConfig.onConfigUpdated.listen((event) async {
  await remoteConfig.activate();
  // Use the new config values here
});
```

- Real-time Remote Config is **not available for Web**.
- Update your UI state when new configuration values are activated.
- Ensure real-time updates don't disrupt the user experience.

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
- Test your app with both default and remote values.
- Verify graceful handling of configuration changes at runtime.
- Test **offline behavior** to ensure proper fallback to defaults.

---

## References

- [Firebase Remote Config Flutter documentation](https://firebase.google.com/docs/remote-config/get-started?platform=flutter)
