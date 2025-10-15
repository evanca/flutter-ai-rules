# Firebase App Check Rules

### Setup and Configuration

1. Install the Firebase App Check plugin using `flutter pub add firebase_app_check`.
2. Import the plugin in your Dart code using `import 'package:firebase_app_check/firebase_app_check.dart';`.
3. Register your apps in the Firebase console under Project Settings > App Check before using the service.
4. Consider setting a custom time-to-live (TTL) for App Check tokens based on your security and performance needs.
5. Be aware that shorter TTLs provide stronger security but may impact performance and consume quota faster.
6. Initialize App Check after Firebase initialization but before using any Firebase services.
   ```dart
   await Firebase.initializeApp();
    await FirebaseAppCheck.instance.activate(
       webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
       // Use provider classes to select platform providers.
       // For production: providerAndroid: AndroidPlayIntegrityProvider(), providerApple: AppleAppAttestProvider()
       providerAndroid: AndroidPlayIntegrityProvider(),
       providerApple: AppleDeviceCheckProvider(),
    );
   ```
7. For web applications, obtain a reCAPTCHA v3 site key from the Firebase console and use it with the `ReCaptchaV3Provider`.

### Provider Selection

1. For Android, choose the appropriate provider based on your requirements:
   - `AndroidPlayIntegrityProvider` (default): Uses Play Integrity API for app verification
   - `AndroidSafetyNetProvider`: Uses the legacy SafetyNet API (not recommended for new apps)
   - `AndroidDebugProvider`: For development and testing environments only
2. For Apple platforms (iOS/macOS), choose the appropriate provider:
   - `AppleDeviceCheckProvider` (default): Works on iOS 11+ and macOS 10.15+
   - `AppleAppAttestProvider`: Enhanced security on iOS 14+ and macOS 14+
   - `AppleAppAttestProviderWithDeviceCheckFallback`: Uses App Attest with fallback to Device Check
   - `AppleDebugProvider`: For development and testing environments only
3. For web platforms, use one of the following providers:
   - `ReCaptchaV3Provider`: Standard reCAPTCHA v3 verification
   - `ReCaptchaEnterpriseProvider`: Enhanced version with additional features

### Development and Testing

1. Use the debug provider during development to run your app in emulators or CI environments.
    ```dart
    await FirebaseAppCheck.instance.activate(
       // For development/testing use the debug providers (optionally with a debug token):
       providerAndroid: AndroidDebugProvider('YOUR_DEBUG_TOKEN'),
       providerApple: AppleDebugProvider('YOUR_DEBUG_TOKEN'),
    );
    ```
2. For iOS debug builds, enable debug logging by adding `-FIRDebugEnabled` to the Arguments Passed on Launch in Xcode.
3. For web debug builds, enable debug mode by setting `self.FIREBASE_APPCHECK_DEBUG_TOKEN = true;` in your `web/index.html` file.
4. Register the debug tokens displayed in the console in the Firebase console's App Check section.
5. Never use debug providers or share debug tokens in production builds.
6. Keep debug tokens private and don't commit them to public repositories.
7. Revoke compromised debug tokens immediately from the Firebase console.

### Enforcement and Monitoring

1. Monitor App Check metrics before enabling enforcement to ensure it won't disrupt legitimate users.
2. Enable enforcement gradually, starting with non-critical Firebase services.
3. Monitor request metrics for Realtime Database, Cloud Firestore, Cloud Storage, and Authentication to understand usage patterns.
4. Be aware that once enforcement is enabled, only registered apps with valid App Check tokens can access your Firebase resources.
5. Consider enabling enforcement sooner if you observe suspicious usage of your app resources.
6. Use App Check in combination with Firebase Security Rules for comprehensive security.
7. Implement proper error handling for App Check verification failures in your app.

### Security Best Practices

1. Never disable App Check in production builds once you've enabled it.
2. Implement a fallback mechanism for handling App Check verification failures.
3. Regularly review App Check metrics to identify potential abuse patterns.
4. Use App Check in conjunction with other security measures like authentication and security rules.
5. Be aware that App Check tokens are automatically refreshed at approximately half the TTL duration.
6. For high-security applications, use the shortest practical TTL for App Check tokens.
7. Implement server-side verification for critical operations using Firebase Admin SDK.

### Android Device Integrity

**Important Note**: For certain Android devices, you need to enable "Meets basic device integrity" in the Google Play console to ensure proper App Check functionality.
