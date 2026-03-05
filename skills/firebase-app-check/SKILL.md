---
name: firebase-app-check
description: Integrates Firebase App Check into Flutter apps. Use when setting up App Check, selecting providers per platform, using debug providers during development, enabling enforcement, or applying App Check security best practices.
---

# Firebase App Check Skill

This skill defines how to correctly use Firebase App Check in Flutter applications.

## When to Use

Use this skill when:

* Setting up and activating Firebase App Check in a Flutter project.
* Selecting the right provider for each platform.
* Configuring debug providers for development and testing.
* Enabling enforcement and monitoring App Check metrics.
* Applying App Check security best practices.

---

## 1. Setup and Configuration

```
flutter pub add firebase_app_check
```

```dart
import 'package:firebase_app_check/firebase_app_check.dart';
```

Initialize App Check **after** `Firebase.initializeApp()` and **before** using any Firebase services:

```dart
await Firebase.initializeApp();
await FirebaseAppCheck.instance.activate(
  webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
  providerAndroid: AndroidPlayIntegrityProvider(),
  providerApple: AppleDeviceCheckProvider(),
);
```

- Register your apps in the Firebase console under **Project Settings > App Check** before using the service.
- For web, obtain a reCAPTCHA v3 site key from the Firebase console.
- Consider setting a custom **TTL** for App Check tokens based on your security and performance needs — shorter TTLs are more secure but consume quota faster.

---

## 2. Provider Selection

**Android:**
| Provider | Use case |
|---|---|
| `AndroidPlayIntegrityProvider` | Production (default) |
| `AndroidDebugProvider` | Development / CI only |

**Apple (iOS / macOS):**
| Provider | Use case |
|---|---|
| `AppleDeviceCheckProvider` | Production default (iOS 11+, macOS 10.15+) |
| `AppleAppAttestProvider` | Enhanced security (iOS 14+, macOS 14+) |
| `AppleAppAttestProviderWithDeviceCheckFallback` | App Attest with Device Check fallback |
| `AppleDebugProvider` | Development / CI only |

**Web:**
| Provider | Use case |
|---|---|
| `ReCaptchaV3Provider` | Standard reCAPTCHA v3 |
| `ReCaptchaEnterpriseProvider` | Enhanced with additional features |

> **Android note:** For certain Android devices, enable "Meets basic device integrity" in the Google Play console to ensure proper App Check functionality.

---

## 3. Development and Testing

Use debug providers during development to run in emulators or CI environments:

```dart
await FirebaseAppCheck.instance.activate(
  providerAndroid: AndroidDebugProvider('YOUR_DEBUG_TOKEN'),
  providerApple: AppleDebugProvider('YOUR_DEBUG_TOKEN'),
);
```

- **iOS:** Enable debug logging by adding `-FIRDebugEnabled` to Arguments Passed on Launch in Xcode.
- **Web:** Set `self.FIREBASE_APPCHECK_DEBUG_TOKEN = true;` in `web/index.html`.
- Register debug tokens shown in the console in the Firebase console's App Check section.
- **Never** use debug providers or share debug tokens in production builds.
- Keep debug tokens private — do not commit them to public repositories.
- Revoke compromised debug tokens immediately from the Firebase console.

---

## 4. Enforcement and Monitoring

- **Monitor** App Check metrics before enabling enforcement to avoid disrupting legitimate users.
- Enable enforcement **gradually**, starting with non-critical Firebase services.
- Monitor request metrics for Realtime Database, Cloud Firestore, Cloud Storage, and Authentication.
- Once enforcement is enabled, only registered apps with valid App Check tokens can access Firebase resources.
- Use App Check **in combination with** Firebase Security Rules for comprehensive security.
- Implement proper error handling for App Check verification failures.

---

## 5. Security Best Practices

- Never disable App Check in production builds once enabled.
- Implement a fallback mechanism for App Check verification failures.
- Regularly review App Check metrics to identify potential abuse patterns.
- App Check tokens are **automatically refreshed** at approximately half the TTL duration.
- For high-security applications, use the shortest practical TTL.
- Implement server-side verification for critical operations using the Firebase Admin SDK.

---

## References

- [Firebase App Check Flutter documentation](https://firebase.google.com/docs/app-check/flutter/default-providers)
- [Firebase App Check debug provider](https://firebase.google.com/docs/app-check/flutter/debug-provider)
