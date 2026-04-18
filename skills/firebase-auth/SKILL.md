---
name: firebase-auth
description: "Integrates Firebase Authentication into Flutter apps. Use when implementing email/password sign-in, configuring Google or social sign-in providers, listening to auth state changes, managing user profiles and account linking, implementing multi-factor authentication, handling FirebaseAuthException errors, or securing auth flows. Trigger terms: Firebase auth, sign-in, sign-up, authentication, login, logout, social login, MFA, auth state, FirebaseAuthException."
---

# Firebase Authentication Skill

This skill defines how to correctly use Firebase Authentication in Flutter applications.

## When to Use

Use this skill when:

* Setting up Firebase Authentication in a Flutter project.
* Listening to authentication state changes.
* Implementing email/password or social sign-in.
* Managing user profiles, account linking, or MFA.
* Handling authentication errors.
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

---

## 5. Error Handling

Common `FirebaseAuthException` codes and their recommended handling:

| Error code | Meaning | Action |
|---|---|---|
| `weak-password` | Password does not meet strength requirements | Show password requirements to user |
| `email-already-in-use` | Account exists for this email | Prompt sign-in or password reset |
| `user-not-found` | No account for this email | Prompt account creation |
| `wrong-password` | Incorrect password | Show error, offer password reset |
| `too-many-requests` | Rate limited | Show cooldown message, retry later |
| `account-exists-with-different-credential` | Email linked to another provider | Fetch sign-in methods, guide user to correct provider |
| `operation-not-allowed` | Provider not enabled | Enable the provider in the Firebase console |

- Always use `try-catch` with `FirebaseAuthException`.
- Check `e.code` to identify specific error types and provide actionable user feedback.

---

## 6. User Management

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

## 7. Security Best Practices

- Never store sensitive authentication credentials in client-side code.
- Monitor auth state changes for proper session management.
- Validate user input before submitting authentication requests to prevent injection attacks.
- Call `FirebaseAuth.instance.signOut()` when users exit the app.
- For sensitive operations, re-authenticate users with `reauthenticateWithCredential()`.
- Enforce strong password policies for email/password auth.
- In Realtime Database and Cloud Storage Security Rules, use the `auth` variable to get the signed-in user's UID for access control.
- Use multi-factor authentication for sensitive applications.

---

## 8. Multi-Factor Authentication

> **Security warning:** Avoid SMS-based MFA. SMS is insecure and easy to compromise or spoof.

> **Platform limitation:** Windows does not support MFA. MFA with multiple tenants is not supported on Flutter.

- Enable at least one MFA-compatible provider before implementing MFA.

---

## 9. Email Link Authentication

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
