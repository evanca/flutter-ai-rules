---
name: firebase-app-check
description: "Integrates Firebase App Check into Flutter apps. Use when implementing app attestation, configuring App Check providers per platform, setting up debug tokens for development and CI, enabling enforcement for backend resources, managing token refresh and TTL, or hardening app security against abuse."
---

# Firebase App Check Skill

This skill defines how to correctly implement Firebase App Check in Flutter applications, covering provider selection, debug configuration, enforcement rollout, and security hardening.

## When to Use

Use this skill when:

* Setting up and activating Firebase App Check in a Flutter project.
* Selecting the right attestation provider for each platform.
* Configuring debug providers for development, testing, and CI.
* Enabling enforcement and monitoring App Check metrics.
* Implementing token refresh handling and custom TTL configuration.

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
  androidProvider: AndroidProvider.playIntegrity,
  appleProvider: AppleProvider.deviceCheck,
);
```

### Setup Checklist

1. Register apps in the Firebase console under **Project Settings > App Check**.
2. For web, obtain a reCAPTCHA v3 site key from the Firebase console.
3. Confirm activation completes before any Firestore, Storage, or RTDB calls.
4. Consider setting a custom **TTL** — shorter TTLs are more secure but consume quota faster.

---

## 2. Provider Selection

**Android:**
| Provider | Use case |
|---|---|
| `AndroidProvider.playIntegrity` | Production (default) |
| `AndroidProvider.debug` | Development / CI only |

**Apple (iOS / macOS):**
| Provider | Use case |
|---|---|
| `AppleProvider.deviceCheck` | Production default (iOS 11+, macOS 10.15+) |
| `AppleProvider.appAttest` | Enhanced security (iOS 14+, macOS 14+) |
| `AppleProvider.appAttestWithDeviceCheckFallback` | App Attest with Device Check fallback |
| `AppleProvider.debug` | Development / CI only |

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
await Firebase.initializeApp();
await FirebaseAppCheck.instance.activate(
  androidProvider: AndroidProvider.debug,
  appleProvider: AppleProvider.debug,
);
```

### Platform-Specific Debug Setup

**iOS:** Enable debug logging by adding `-FIRDebugEnabled` to Arguments Passed on Launch in Xcode. The debug token appears in the console output.

**Android:** The debug token prints to logcat on first run. Filter by `DebugAppCheckProvider`.

**Web:** Set `self.FIREBASE_APPCHECK_DEBUG_TOKEN = true;` in `web/index.html` before Firebase scripts load.

### Register Debug Tokens

1. Copy the debug token from the device/emulator console output.
2. In the Firebase console, navigate to **App Check > Apps > Manage debug tokens**.
3. Add the token. It is immediately active for that app.

### Token Listener for Custom Backends

```dart
FirebaseAppCheck.instance.onTokenChange.listen((token) {
  // Attach token to custom backend requests
  // e.g., set as Authorization header
});
```

- **Never** use debug providers or share debug tokens in production builds.
- Keep debug tokens private — do not commit them to public repositories.
- Revoke compromised debug tokens immediately from the Firebase console.

---

## 4. Enforcement Rollout

Follow this sequence to avoid disrupting legitimate users:

1. **Deploy** App Check activation code to all app versions.
2. **Monitor** App Check metrics in the Firebase console — wait until most traffic shows valid tokens.
3. **Enable enforcement** gradually, starting with non-critical Firebase services (e.g., Cloud Storage before Firestore).
4. **Verify** that unverified request percentage drops to near zero before enforcing on critical services.

- Once enforcement is enabled, only apps with valid App Check tokens can access protected Firebase resources.
- Use App Check **in combination with** Firebase Security Rules for defense in depth.
- Implement proper error handling for App Check verification failures — surface a user-friendly message rather than a raw error.

---

## 5. Security Best Practices

- Never disable App Check in production builds once enabled.
- Implement a fallback mechanism for App Check verification failures (e.g., retry with exponential backoff).
- Regularly review App Check metrics to identify potential abuse patterns.
- App Check tokens are **automatically refreshed** at approximately half the TTL duration.
- For high-security applications, use the shortest practical TTL.
- Implement server-side verification for critical operations using the Firebase Admin SDK:

```
// Node.js Admin SDK example for verifying App Check tokens
const appCheckToken = req.header('X-Firebase-AppCheck');
const appCheckClaims = await getAppCheck().verifyToken(appCheckToken);
```

---

## References

- [Firebase App Check Flutter documentation](https://firebase.google.com/docs/app-check/flutter/default-providers)
- [Firebase App Check debug provider](https://firebase.google.com/docs/app-check/flutter/debug-provider)
