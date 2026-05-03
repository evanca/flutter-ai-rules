# Firebase Authentication Rules

### Setup and Configuration

1. Install the Firebase Authentication plugin using `flutter pub add firebase_auth`.
2. Import the plugin in your Dart code using `import 'package:firebase_auth/firebase_auth.dart';`.
3. Enable desired authentication providers in the Firebase console before using them in your app.
4. For testing, use the Firebase Local Emulator Suite by calling `useAuthEmulator()` to specify the emulator address and port.
   ```dart
   Future<void> main() async {
     WidgetsFlutterBinding.ensureInitialized();
     await Firebase.initializeApp();
     
     // Ideal time to initialize
     await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
     //...
   }
   ```
5. Initialize Firebase before using any Firebase Authentication features.

### Authentication State Management

1. Use `authStateChanges()` to listen for basic sign-in state changes (signed in or signed out).
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
2. Use `idTokenChanges()` to listen for changes in the user's ID token, including custom claims updates.
   ```dart
   FirebaseAuth.instance
     .idTokenChanges()
     .listen((User? user) {
       if (user == null) {
         print('User is currently signed out!');
       } else {
         print('User is signed in!');
       }
     });
   ```
3. Use `userChanges()` to listen for changes to the user's data, such as profile updates.
4. Always handle the initial authentication state when your app starts by listening to these streams immediately.
5. When using custom claims, be aware they will only be available after sign-in, re-authentication, token expiration, or manual token refresh.

### Email and Password Authentication

1. Create a new user account with email and password using `createUserWithEmailAndPassword()`.
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
2. Sign in existing users with email and password using `signInWithEmailAndPassword()`.
   ```dart
   try {
     final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
       email: emailAddress,
       password: password
     );
   } on FirebaseAuthException catch (e) {
     if (e.code == 'invalid-credential') {
       // Since September 2023 Firebase enables email enumeration protection by
       // default, which returns this code instead of 'user-not-found' or
       // 'wrong-password' to prevent revealing whether an email is registered.
       print('Invalid email or password.');
     } else if (e.code == 'user-not-found') {
       print('No user found for that email.');
     } else if (e.code == 'wrong-password') {
       print('Wrong password provided for that user.');
     }
   }
   ```
3. Handle the `invalid-credential` error code when signing in with email and password. Since September 2023, Firebase enables email enumeration protection by default on new projects, replacing `user-not-found` and `wrong-password` with `invalid-credential` to prevent revealing whether an email address is registered. This setting can be managed in the Firebase console under **Authentication > Settings**.
4. Verify the user's email address after account creation to enhance security.
5. Be aware that Firebase limits the number of new email/password sign-ups from the same IP address in a short period to protect against abuse.
6. On iOS and macOS, be aware that authentication state can persist between app re-installs as the Firebase SDK persists authentication state to the system keychain.

### Social Authentication

1. Enable the desired social authentication providers in the Firebase console before implementing them in your app.
2. For Google Sign-In on native platforms, use the `google_sign_in` plugin and create a credential with the authentication details.
   ```dart
   Future<UserCredential> signInWithGoogle() async {
     // Trigger the authentication flow (new API)
     final GoogleSignInAccount? googleUser = await GoogleSignIn.instance.authenticate();

     // Obtain the auth details (non-nullable after authenticate)
     final GoogleSignInAuthentication googleAuth = googleUser.authentication;

     // Create a new credential with the ID token
     final credential = GoogleAuthProvider.credential(idToken: googleAuth.idToken);

     // Once signed in, return the UserCredential
     return await FirebaseAuth.instance.signInWithCredential(credential);
   }
   ```
3. For web platforms, use the built-in Firebase SDK methods for handling authentication flow.
   ```dart
   Future<UserCredential> signInWithGoogle() async {
     // Create a new provider
     GoogleAuthProvider googleProvider = GoogleAuthProvider();
     
     googleProvider.addScope('https://www.googleapis.com/auth/contacts.readonly');
     googleProvider.setCustomParameters({
       'login_hint': 'user@example.com'
     });
     
     // Once signed in, return the UserCredential
     return await FirebaseAuth.instance.signInWithPopup(googleProvider);
   }
   ```
4. Configure platform-specific settings for each social provider (e.g., SHA1 key for Google Sign-In on Android).
5. Be aware that if a user signs in with a social provider after having manually registered an account with the same email, their authentication provider will automatically change due to Firebase's concept of trusted providers.
6. On Android, `signInWithProvider` opens a Chrome Custom Tab for the OAuth flow. If your `AndroidManifest.xml` contains `android:taskAffinity=""` (Flutter's default template), the Custom Tab will close when the user switches apps (e.g., to open a password manager), causing a `web-context-already-presented` error on return. To fix this, remove `android:taskAffinity=""` from your `AndroidManifest.xml`.
7. When signing in with Apple, request the `email` and `name` scopes to present the full first-time sign-in UI (including the "Share/Hide email" option).
   ```dart
   Future<UserCredential> signInWithApple() async {
     final appleProvider = AppleAuthProvider();
     appleProvider.addScope('email');
     appleProvider.addScope('name');
     if (kIsWeb) {
       await FirebaseAuth.instance.signInWithPopup(appleProvider);
     } else {
       await FirebaseAuth.instance.signInWithProvider(appleProvider);
     }
   }
   ```
8. To revoke Apple auth tokens after sign-in, use the appropriate API per platform:
   - On **Apple platforms** (iOS/macOS/web), use `revokeTokenWithAuthorizationCode()` with the authorization code from `userCredential.additionalUserInfo?.authorizationCode`.
   - On **Android**, use `revokeAccessToken()` with the access token from `userCredential.credential?.accessToken`.
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

### Phone Number Authentication

1. Before using phone authentication, ensure platform-specific prerequisites are met:
   - **Android**: Ensure SHA-1 hashes are configured in the Firebase console and Google Play Integrity API is enabled.
   - **iOS**: Ensure APNs authentication key is configured with FCM and background modes for remote notifications are enabled.
   - **iOS**: If `verifyPhoneNumber` fails with `recaptcha-sdk-not-linked`, see the iOS reCAPTCHA SDK guidance in rule 2 below.
   - **Web**: Add your application's domain to the Firebase console under **OAuth redirect domains**.
2. On **iOS**, phone sign-in can fail with `FirebaseAuthException` code `recaptcha-sdk-not-linked` when your Firebase/Identity Platform configuration expects **reCAPTCHA Enterprise** but the native SDK is not linked. Fix this at the native iOS level—it cannot be resolved from Dart alone:
   - **Recommended**: Link the reCAPTCHA Enterprise iOS SDK in your Xcode project following [Google's guide](https://cloud.google.com/recaptcha-enterprise/docs/instrument-ios-apps).
   - **Alternative**: If you cannot link the Enterprise SDK, disable reCAPTCHA SMS defense via the Identity Toolkit [`projects.updateConfig`](https://cloud.google.com/identity-platform/docs/reference/rest/v2/projects/updateConfig) REST API (set `recaptchaConfig.phoneEnforcementState` to `OFF` and `recaptchaConfig.useSmsTollFraudProtection` to `false`). This reduces fraud protection—prefer linking the SDK when possible. Follow the [official steps to disable reCAPTCHA SMS defense](https://cloud.google.com/identity-platform/docs/recaptcha-tfp#disable_recaptcha_sms_defense).
   - If the SDK uses a Safari view controller-hosted challenge, handle the return URL using `uni_links`/`app_links` or the iOS runner's `application:openURL:` method.
3. Phone number sign-in is only supported on real devices and the web. Testing phone auth on device emulators is not supported; use physical devices or the web platform for phone auth testing.

### Error Handling

1. Use try-catch blocks with `FirebaseAuthException` to handle authentication errors.
2. Check the `code` property of `FirebaseAuthException` to identify specific error types.
3. Handle `account-exists-with-different-credential` errors by fetching sign-in methods for the email and guiding users through the appropriate sign-in flow.
4. Be prepared to handle `too-many-requests` errors by implementing appropriate retry logic or user feedback.
5. Handle `operation-not-allowed` errors by ensuring the authentication provider is enabled in the Firebase console.
6. Implement proper error messages for common authentication failures to improve user experience.
7. On iOS, handle `recaptcha-sdk-not-linked` errors during `verifyPhoneNumber` by configuring reCAPTCHA Enterprise or disabling reCAPTCHA SMS defense in your Identity Platform project. This error is raised by the native Firebase iOS Auth SDK and cannot be fixed from Dart code alone.

### User Management

1. Store only essential user information in the authentication profile and use a database for additional user data.
2. When linking authentication providers, always verify the user's identity before linking new credentials.
3. When handling account linking, use `fetchSignInMethodsForEmail()` to determine the appropriate sign-in method.
4. Use `linkWithCredential()` to connect multiple authentication providers to a single user account.
5. Implement proper error handling when linking accounts to handle cases where the account may already exist.
6. Access the user's basic profile information from the `User` object after authentication.
7. Use the `updateProfile()` method to update the user's display name and photo URL.
   ```dart
   await FirebaseAuth.instance.currentUser?.updateProfile(
     displayName: "Jane Q. User",
     photoURL: "https://example.com/jane-q-user/profile.jpg",
   );
   ```
8. Use `verifyBeforeUpdateEmail()` (not `updateEmail()`) to change a user's email address. This sends a verification email to the new address; the email is only updated after the user verifies it.
   ```dart
   await user?.verifyBeforeUpdateEmail("newemail@example.com");
   ```

### Security Best Practices

1. Never store sensitive authentication credentials in client-side code.
2. Implement proper session management by monitoring authentication state changes.
3. Use multi-factor authentication for sensitive applications to enhance security.
4. Validate user input before submitting authentication requests to prevent injection attacks.
5. Implement proper logout functionality by calling `FirebaseAuth.instance.signOut()` when users exit the app.
6. For sensitive operations, consider re-authenticating users with `reauthenticateWithCredential()`.
7. When using email/password authentication, enforce strong password policies.
8. In Firebase Realtime Database and Cloud Storage Security Rules, use the `auth` variable to get the signed-in user's unique ID for access control.

### Multi-Factor Authentication

**Important Security Warning**: Avoid the use of SMS-based MFA. SMS is an insecure technology that is easy to compromise or spoof with no authentication mechanism or eavesdropping protection.

**Platform Limitations**: Windows platform does not support multi-factor authentication. Using multi-factor authentication with multiple tenants on any platform is not supported on Flutter.

1. Enable at least one provider that supports multi-factor authentication before implementing MFA.

### Email Link Authentication

**Important Update**: Firebase Dynamic Links is deprecated for email link authentication. Firebase Hosting is now used to send sign-in links. 

**Platform-Specific Configuration**: Follow the platform-specific guides for proper configuration:
- [Android Email Link Auth](https://firebase.google.com/docs/auth/android/email-link-auth#complete-android-signin)
- [iOS Email Link Auth](https://firebase.google.com/docs/auth/ios/email-link-auth#complete-apple-signin)
- [Web Email Link Auth](https://firebase.google.com/docs/auth/web/email-link-auth#completing_sign-in_in_a_web_page)

1. For sign-in completion via mobile application, configure the app to detect incoming application links and parse the underlying deep link.
2. Use `handleCodeInApp: true` in ActionCodeSettings as the sign-in operation must always be completed in the app.
3. Store the user's email address locally (e.g., using SharedPreferences) when sending the sign-in email to streamline the flow.
4. **Security**: Do not pass the user's email in redirect URL parameters and reuse it as this may enable session injections.
5. Use HTTPS URLs in production to prevent link interception by intermediary servers.
