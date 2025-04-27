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
     if (e.code == 'user-not-found') {
       print('No user found for that email.');
     } else if (e.code == 'wrong-password') {
       print('Wrong password provided for that user.');
     }
   }
   ```
3. Verify the user's email address after account creation to enhance security.
4. Be aware that Firebase limits the number of new email/password sign-ups from the same IP address in a short period to protect against abuse.
5. On iOS and macOS, be aware that authentication state can persist between app re-installs as the Firebase SDK persists authentication state to the system keychain.

### Social Authentication

1. Enable the desired social authentication providers in the Firebase console before implementing them in your app.
2. For Google Sign-In on native platforms, use the `google_sign_in` plugin and create a credential with the authentication details.
   ```dart
   Future<UserCredential> signInWithGoogle() async {
     // Trigger the authentication flow
     final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
     
     // Obtain the auth details from the request
     final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;
     
     // Create a new credential
     final credential = GoogleAuthProvider.credential(
       accessToken: googleAuth?.accessToken,
       idToken: googleAuth?.idToken,
     );
     
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

### Error Handling

1. Use try-catch blocks with `FirebaseAuthException` to handle authentication errors.
2. Check the `code` property of `FirebaseAuthException` to identify specific error types.
3. Handle `account-exists-with-different-credential` errors by fetching sign-in methods for the email and guiding users through the appropriate sign-in flow.
4. Be prepared to handle `too-many-requests` errors by implementing appropriate retry logic or user feedback.
5. Handle `operation-not-allowed` errors by ensuring the authentication provider is enabled in the Firebase console.
6. Implement proper error messages for common authentication failures to improve user experience.

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

### Security Best Practices

1. Never store sensitive authentication credentials in client-side code.
2. Implement proper session management by monitoring authentication state changes.
3. Use multi-factor authentication for sensitive applications to enhance security.
4. Validate user input before submitting authentication requests to prevent injection attacks.
5. Implement proper logout functionality by calling `FirebaseAuth.instance.signOut()` when users exit the app.
6. For sensitive operations, consider re-authenticating users with `reauthenticateWithCredential()`.
7. When using email/password authentication, enforce strong password policies.
8. In Firebase Realtime Database and Cloud Storage Security Rules, use the `auth` variable to get the signed-in user's unique ID for access control.
