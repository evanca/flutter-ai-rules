---
name: firebase-auth
description: Integrates Firebase Authentication into Flutter apps. Use when setting up auth, managing auth state, implementing email/password or social sign-in, handling auth errors, managing users, or applying security best practices.
---

# Firebase Authentication Skill

This skill defines how to correctly use Firebase Authentication in Flutter applications.

## When to Use

Use this skill when:

* Setting up Firebase Authentication in a Flutter project.
* Listening to authentication state changes.
* Implementing email/password, phone number, or social sign-in.
* Managing user profiles, account linking, or MFA.
* Handling authentication errors (including iOS `recaptcha-sdk-not-linked` for phone auth).
* Applying security best practices for auth flows.

---

## 1. Setup and Configuration

```
flutter pub add firebase_auth
```

```dart
import 'package:firebase_auth/firebase_auth.dart';
```

- Enable desired authentication providers in the **Firebase console** before using them.
- Initialize Firebase before using any Firebase Authentication features.

**Local emulator for testing:**

```dart
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
  // ...
}
```

---

## 2. Authentication State Management

Use the appropriate stream based on what you need to observe:

| Stream | Fires when |
|---|---|
| `authStateChanges()` | User signs in or out |
| `idTokenChanges()` | ID token changes (including custom claims) |
| `userChanges()` | User data changes (e.g., profile updates) |

```dart
FirebaseAuth.instance
  .authStateChanges()
  .listen((User? user) {
    if (user == null) {
      print('User is currently signed out!');
    } else {
      print('User is signed in!');
    }
  });
```

- Listen to these streams **immediately** when the app starts to handle the initial auth state.
- Custom claims are only available after sign-in, re-authentication, token expiration, or manual token refresh.

---

## 3. Email and Password Authentication

**Create a new account:**

```dart
try {
  final credential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
    email: emailAddress,
    password: password,
  );
} on FirebaseAuthException catch (e) {
  if (e.code == 'weak-password') {
    print('The password provided is too weak.');
  } else if (e.code == 'email-already-in-use') {
    print('The account already exists for that email.');
  }
} catch (e) {
  print(e);
}
```

**Sign in:**

```dart
try {
  final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
    email: emailAddress,
    password: password,
  );
} on FirebaseAuthException catch (e) {
  if (e.code == 'invalid-credential') {
    // Email enumeration protection enabled (default since Sep 2023):
    // replaces 'user-not-found' and 'wrong-password'.
    print('Invalid email or password.');
  } else if (e.code == 'user-not-found') {
    print('No user found for that email.');
  } else if (e.code == 'wrong-password') {
    print('Wrong password provided for that user.');
  }
}
```

- Verify the user's email address after account creation.
- Firebase rate-limits new email/password sign-ups from the same IP to protect against abuse.
- On iOS/macOS, authentication state persists between app re-installs via the system keychain.
- Since September 2023, Firebase enables **email enumeration protection** by default on new projects, replacing `user-not-found` and `wrong-password` with `invalid-credential`. Manage this in the Firebase console under **Authentication > Settings**.

---

## 4. Social Authentication

**Google Sign-In (native platforms):**

```dart
Future<UserCredential> signInWithGoogle() async {
  final GoogleSignInAccount? googleUser = await GoogleSignIn.instance.authenticate();
  final GoogleSignInAuthentication googleAuth = googleUser.authentication;
  final credential = GoogleAuthProvider.credential(idToken: googleAuth.idToken);
  return await FirebaseAuth.instance.signInWithCredential(credential);
}
```

**Google Sign-In (web):**

```dart
Future<UserCredential> signInWithGoogle() async {
  GoogleAuthProvider googleProvider = GoogleAuthProvider();
  googleProvider.addScope('https://www.googleapis.com/auth/contacts.readonly');
  googleProvider.setCustomParameters({'login_hint': 'user@example.com'});
  return await FirebaseAuth.instance.signInWithPopup(googleProvider);
}
```

- Configure platform-specific settings for each provider (e.g., SHA1 key for Google Sign-In on Android).
- If a user signs in with a social provider after registering with the same email manually, Firebase's trusted provider concept will automatically change their authentication provider.
- On Android, `signInWithProvider` opens a Chrome Custom Tab. If `AndroidManifest.xml` contains `android:taskAffinity=""` (Flutter's default), the tab closes when the user switches apps (e.g., to use a password manager), causing a `web-context-already-presented` error. Remove `android:taskAffinity=""` to fix this.
- When signing in with Apple, add the `email` and `name` scopes to present the full first-time sign-in UI (including "Share/Hide email"):
  ```dart
  final appleProvider = AppleAuthProvider();
  appleProvider.addScope('email');
  appleProvider.addScope('name');
  ```
- To revoke Apple auth tokens after sign-in, use the appropriate API per platform:
  - **Apple platforms** (iOS/macOS/web): use `revokeTokenWithAuthorizationCode()` with the authorization code from `userCredential.additionalUserInfo?.authorizationCode`.
  - **Android**: use `revokeAccessToken()` with the access token from `userCredential.credential?.accessToken`.
  ```dart
  // Apple platforms (iOS/macOS/web)
  final authCode = userCredential.additionalUserInfo?.authorizationCode;
  if (authCode != null) {
    await FirebaseAuth.instance.revokeTokenWithAuthorizationCode(authCode);
  }

  // Android
  final accessToken = userCredential.credential?.accessToken;
  if (accessToken != null) {
    await FirebaseAuth.instance.revokeAccessToken(accessToken);
  }
  ```

---

## 5. Phone Number Authentication

Before using phone authentication, ensure platform-specific prerequisites are met:

- **Android**: SHA-1 hashes must be configured in the Firebase console and Google Play Integrity API enabled.
- **iOS**: APNs authentication key must be configured with FCM and background modes for remote notifications enabled.
- **Web**: Add your application's domain to the Firebase console under **OAuth redirect domains**.

Phone number sign-in is only supported on real devices and the web. Testing on device emulators is not supported.

**iOS: `recaptcha-sdk-not-linked` error**

On iOS, `verifyPhoneNumber` can throw `FirebaseAuthException` with code `recaptcha-sdk-not-linked` when Identity Platform expects reCAPTCHA Enterprise but the native SDK is not linked. This cannot be resolved from Dart — fix it at the native iOS or GCP level:

- **Recommended**: Link the reCAPTCHA Enterprise iOS SDK in Xcode following [Google's guide](https://cloud.google.com/recaptcha-enterprise/docs/instrument-ios-apps).
- **Alternative**: Disable reCAPTCHA SMS defense via the Identity Toolkit [`projects.updateConfig`](https://cloud.google.com/identity-platform/docs/reference/rest/v2/projects/updateConfig) REST API (set `recaptchaConfig.phoneEnforcementState` to `OFF` and `recaptchaConfig.useSmsTollFraudProtection` to `false`). See the [official steps](https://cloud.google.com/identity-platform/docs/recaptcha-tfp#disable_recaptcha_sms_defense). This reduces fraud protection — prefer linking the SDK.
- If the SDK uses a Safari view controller-hosted challenge, handle the return URL using `uni_links`/`app_links` or `application:openURL:` in the iOS runner.

---

## 6. Error Handling

- Always use `try-catch` with `FirebaseAuthException`.
- Check `e.code` to identify specific error types.
- Handle `account-exists-with-different-credential` by fetching sign-in methods for the email and guiding users through the correct flow.
- Handle `too-many-requests` with retry logic or user feedback.
- Handle `operation-not-allowed` by ensuring the provider is enabled in the Firebase console.
- On iOS, `recaptcha-sdk-not-linked` during `verifyPhoneNumber` is raised by the native Firebase iOS Auth SDK and requires native setup or GCP configuration changes — it cannot be fixed from Dart code alone.

---

## 7. User Management

```dart
// Update profile
await FirebaseAuth.instance.currentUser?.updateProfile(
  displayName: "Jane Q. User",
  photoURL: "https://example.com/jane-q-user/profile.jpg",
);

// Update email (sends verification to new address first)
await user?.verifyBeforeUpdateEmail("newemail@example.com");
```

- Use `verifyBeforeUpdateEmail()` — **not** `updateEmail()` — to change a user's email. The email only updates after the user verifies it.
- Store only essential info in the auth profile; use a database for additional user data.
- Use `linkWithCredential()` to connect multiple auth providers to a single account.
- Verify the user's identity before linking new credentials.
- Use `fetchSignInMethodsForEmail()` when handling account linking.

---

## 8. Security Best Practices

- Never store sensitive authentication credentials in client-side code.
- Monitor auth state changes for proper session management.
- Validate user input before submitting authentication requests to prevent injection attacks.
- Call `FirebaseAuth.instance.signOut()` when users exit the app.
- For sensitive operations, re-authenticate users with `reauthenticateWithCredential()`.
- Enforce strong password policies for email/password auth.
- In Realtime Database and Cloud Storage Security Rules, use the `auth` variable to get the signed-in user's UID for access control.
- Use multi-factor authentication for sensitive applications.

---

## 9. Multi-Factor Authentication

> **Security warning:** Avoid SMS-based MFA. SMS is insecure and easy to compromise or spoof.

> **Platform limitation:** Windows does not support MFA. MFA with multiple tenants is not supported on Flutter.

- Enable at least one MFA-compatible provider before implementing MFA.

---

## 10. Email Link Authentication

> **Important:** Firebase Dynamic Links is deprecated for email link authentication. Firebase Hosting is now used to send sign-in links.

- Set `handleCodeInApp: true` in `ActionCodeSettings` — sign-in must always be completed in the app.
- Store the user's email locally (e.g., `SharedPreferences`) when sending the sign-in link.
- **Never** pass the user's email in redirect URL parameters — this enables session injection attacks.
- Use HTTPS URLs in production to prevent link interception.
- Configure the app to detect incoming links and parse the underlying deep link for sign-in completion.

---

## References

- [Firebase Authentication Flutter documentation](https://firebase.google.com/docs/auth/flutter/start)
- [Email/password authentication](https://firebase.google.com/docs/auth/flutter/password-auth)
- [Federated identity & social sign-in](https://firebase.google.com/docs/auth/flutter/federated-auth)
- [Multi-factor authentication](https://firebase.google.com/docs/auth/flutter/multi-factor)
