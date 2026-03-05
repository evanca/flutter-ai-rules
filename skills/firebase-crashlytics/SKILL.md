---
name: firebase-crashlytics
description: Integrates Firebase Crashlytics into Flutter apps. Use when setting up crash reporting, handling fatal and non-fatal errors, customizing crash reports with keys/logs/user identifiers, or configuring opt-in reporting.
---

# Firebase Crashlytics Skill

This skill defines how to correctly use Firebase Crashlytics in Flutter applications.

## When to Use

Use this skill when:

* Setting up Crashlytics in a Flutter project.
* Configuring fatal and non-fatal error handling.
* Customizing crash reports with keys, logs, and user identifiers.
* Testing crash reporting or configuring opt-in data collection.

---

## 1. Setup and Configuration

```
flutter pub add firebase_crashlytics
flutter pub add firebase_analytics  # enables breadcrumb logs for better crash context
```

Run `flutterfire configure` to update your Firebase configuration and add the required Crashlytics Gradle plugin for Android.

```dart
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
```

**Obfuscated code:**
- For apps built with `--split-debug-info` and/or `--obfuscate`, upload symbol files for readable stack traces.
- **iOS:** Flutter 3.12.0+ and Crashlytics Flutter plugin 3.3.4+ handle symbol upload automatically.
- **Android:** Use Firebase CLI (v11.9.0+) to upload Flutter debug symbols before reporting crashes:

```bash
firebase crashlytics:symbols:upload --app=FIREBASE_APP_ID PATH/TO/symbols
```

---

## 2. Error Handling

**Fatal Flutter errors:**

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Pass all uncaught fatal errors from the framework to Crashlytics
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

  runApp(MyApp());
}
```

**Non-fatal Flutter errors:** use `recordFlutterError` instead of `recordFlutterFatalError`.

**Async errors not caught by the Flutter framework:**

```dart
PlatformDispatcher.instance.onError = (error, stack) {
  FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
  return true;
};
```

**Isolate errors:**

```dart
Isolate.current.addErrorListener(RawReceivePort((pair) async {
  final List<dynamic> errorAndStacktrace = pair;
  await FirebaseCrashlytics.instance.recordError(
    errorAndStacktrace.first,
    errorAndStacktrace.last,
    fatal: true,
  );
}).sendPort);
```

**Caught exceptions (non-fatal):**

```dart
await FirebaseCrashlytics.instance.recordError(
  error,
  stackTrace,
  reason: 'a non-fatal error',
  information: ['further diagnostic information about the error', 'version 2.0'],
);
```

- Crashlytics only stores the **most recent 8 non-fatal exceptions** per session — older ones are discarded.

---

## 3. Crash Report Customization

**Custom keys** (max 64 key/value pairs, up to 1 kB each):

```dart
FirebaseCrashlytics.instance.setCustomKey('str_key', 'hello');
FirebaseCrashlytics.instance.setCustomKey('bool_key', true);
FirebaseCrashlytics.instance.setCustomKey('int_key', 1);
```

**Custom log messages** (limit: 64 kB per session):

```dart
FirebaseCrashlytics.instance.log("User tapped on payment button");
```

**User identifier:**

```dart
FirebaseCrashlytics.instance.setUserIdentifier("user-123");
// Clear by setting to blank string
FirebaseCrashlytics.instance.setUserIdentifier("");
```

- Avoid putting unique values (user IDs, timestamps) directly in exception messages — use custom keys instead.

---

## 4. Performance and Optimization

- Crashlytics processes exceptions on a **dedicated background thread** to minimize performance impact.
- **Fatal** reports are sent in real-time without requiring an app restart.
- **Non-fatal** reports are written to disk and sent with the next fatal report or on app restart.
- Crashlytics rate-limits reports from a device to reduce network traffic if necessary.
- Use breadcrumb logs (requires Firebase Analytics) to understand user actions leading up to a crash.

**Disable Crashlytics in debug builds:**

```dart
if (kReleaseMode) {
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
} else {
  await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
}
```

---

## 5. Testing and Debugging

Force a test crash to verify your setup:

```dart
FirebaseCrashlytics.instance.crash();
```

- Test both fatal and non-fatal error reporting.
- Verify stack traces are properly symbolicated when using code obfuscation.
- Check that custom keys, logs, and user identifiers are associated with crash reports.
- Monitor the Crashlytics dashboard regularly and set up alerts for new issues or regressions.

---

## 6. Opt-in Reporting

By default, Crashlytics automatically collects crash reports for all users.

To give users control over data collection:
- Disable automatic reporting and enable it only via `setCrashlyticsCollectionEnabled(true)` when users opt in.
- The override value **persists** across all subsequent app launches.
- To opt a user out, pass `false` — this applies from the next app launch.
- When disabled, crash info is **stored locally**; if later enabled, locally stored crashes are sent to Crashlytics.

---

## References

- [Firebase Crashlytics Flutter documentation](https://firebase.google.com/docs/crashlytics/get-started?platform=flutter)
- [Customize crash reports](https://firebase.google.com/docs/crashlytics/customize-crash-reports?platform=flutter)
