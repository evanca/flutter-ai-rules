---
name: flutterfire-configure
description: "Sets up Firebase for Flutter apps using FlutterFire CLI. Use when adding Firebase to a Flutter project for the first time, running flutterfire configure after adding new platforms or services, initializing Firebase in main.dart, or configuring separate Firebase projects for multiple app flavors. Trigger terms: flutterfire configure, Firebase setup, Firebase initialization, firebase_core, firebase_options.dart, app flavors, multi-environment Firebase."
---

# FlutterFire Configure Skill

This skill defines how to correctly set up and configure Firebase for Flutter applications.

## When to Use

Use this skill when:

* Adding Firebase to a Flutter project for the first time.
* Running `flutterfire configure` after adding a new Firebase service or platform.
* Initializing Firebase in `main.dart`.
* Setting up separate Firebase projects for multiple app flavors.

---

## 1. Prerequisites

Install the required tools:

```bash
npm install -g firebase-tools
firebase login
dart pub global activate flutterfire_cli
```

**Minimum platform requirements:**
- Android: API level 19 (KitKat) or higher
- Apple: iOS 11 or higher

---

## 2. Setup and Configuration

```bash
# From your Flutter project directory:
flutterfire configure

# Add the core Firebase package:
flutter pub add firebase_core
```

- Re-run `flutterfire configure` any time you **add support for a new platform** or **start using a new Firebase service**.
- For Android-specific services (Crashlytics, Performance Monitoring), the FlutterFire CLI automatically adds the required Gradle plugins.
- Rebuild with `flutter run` after adding new Firebase plugins.

---

## 3. Firebase Initialization

```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}
```

- Call `WidgetsFlutterBinding.ensureInitialized()` **before** Firebase initialization.
- Place Firebase initialization **before** any other Firebase service calls.
- **Never modify** `firebase_options.dart` manually — it is auto-generated.
- **Commit** `firebase_options.dart` to version control — it contains non-secret configuration identifiers.
- For Firebase Emulator Suite: `await Firebase.initializeApp(demoProjectId: "demo-project-id")`.

---

## 4. Verification and Best Practices

After configuration, verify the setup is working:

1. Run `flutter run` and confirm the app launches without Firebase initialization errors.
2. Check the debug console for `Firebase initialized successfully` or similar confirmation.
3. Verify `firebase_options.dart` was generated with the correct project ID.

- Enable **Firebase Analytics** for optimal experience with Crashlytics, Remote Config, and other products.
- Use a **consistent Firebase project** across all platforms for data consistency.
- For iOS/macOS apps using certain Firebase services, add the **Keychain Sharing** capability in Xcode.
- Test the Firebase configuration with **both debug and release** builds.
- Check **version compatibility** between Flutter plugins and the underlying Firebase SDK.

---

## 5. Multiple App Flavors

Create separate Firebase projects per environment (development, staging, production):

```bash
flutterfire config \
  --project=flutter-app-dev \
  --out=lib/firebase_options_dev.dart \
  --ios-bundle-id=com.example.flutterApp.dev \
  --ios-out=ios/flavors/dev/GoogleService-Info.plist \
  --android-package-name=com.example.flutter_app.dev \
  --android-out=android/app/src/dev/google-services.json
```

**Centralize Firebase initialization by flavor:**

```dart
// firebase.dart
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/firebase_options_prod.dart' as prod;
import 'package:flutter_app/firebase_options_stg.dart' as stg;
import 'package:flutter_app/firebase_options_dev.dart' as dev;

Future<void> initializeFirebaseApp() async {
  final firebaseOptions = switch (appFlavor) {
    'prod' => prod.DefaultFirebaseOptions.currentPlatform,
    'stg' => stg.DefaultFirebaseOptions.currentPlatform,
    'dev' => dev.DefaultFirebaseOptions.currentPlatform,
    _ => throw UnsupportedError('Invalid flavor: $appFlavor'),
  };
  await Firebase.initializeApp(options: firebaseOptions);
}
```

```dart
// main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeFirebaseApp();
  runApp(const MainApp());
}
```

- Use `appFlavor` or environment variables to select the configuration at runtime.
- Import each flavor's config with **namespace aliases** (e.g., `as dev`).
- Use a helper script to automate multi-flavor configuration.

---

## References

- [Add Firebase to your Flutter app](https://firebase.google.com/docs/flutter/setup)
- [FlutterFire CLI](https://firebase.flutter.dev/docs/cli)
