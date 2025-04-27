# Firebase Cloud Messaging Rules

### Setup and Configuration

1. Enable push notifications and background modes in your Xcode project for iOS targets.
2. Upload your APNs authentication key to Firebase before using FCM on iOS.
3. Do not disable method swizzling on Apple devices, as it's required for FCM token handling.
4. Request user permission before FCM payloads can be received on iOS, macOS, web, and Android 13 or newer.
5. For iOS, ensure the bundle ID for your APNs certificate matches the bundle ID of your app.
6. Install the FCM plugin using `flutter pub add firebase_messaging`.
7. Ensure your Android devices are running Android 4.4 or higher with Google Play services installed.
8. Check for Google Play services compatibility in both `onCreate()` and `onResume()` methods for Android.

### Message Handling

1. Use `FirebaseMessaging.onMessage.listen` to handle messages while your application is in the foreground.
   ```dart
   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
     print('Got a message whilst in the foreground!');
     print('Message data: ${message.data}');

     if (message.notification != null) {
       print('Message also contained a notification: ${message.notification}');
     }
   });
   ```

2. Use `FirebaseMessaging.onBackgroundMessage` to register a handler for background messages.
   ```dart
   @pragma('vm:entry-point')
   Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
     // If you're going to use other Firebase services in the background, such as Firestore,
     // make sure you call `initializeApp` before using other Firebase services.
     await Firebase.initializeApp();

     print("Handling a background message: ${message.messageId}");
   }

   void main() {
     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
     runApp(MyApp());
   }
   ```

3. Background message handlers must not be anonymous functions.
4. Background message handlers must be top-level functions, not class methods which require initialization.
5. When using Flutter version 3.3.0 or higher, annotate background message handlers with `@pragma('vm:entry-point')` right above the function declaration to prevent removal during tree shaking for release mode.
6. Initialize Firebase before using other Firebase services in background message handlers.
7. Background message handlers cannot update application state or execute UI-impacting logic as they run in a separate isolate.

### Permissions

1. Use `requestPermission()` method to request user permission for receiving notifications.
   ```dart
   FirebaseMessaging messaging = FirebaseMessaging.instance;

   NotificationSettings settings = await messaging.requestPermission(
     alert: true,
     announcement: false,
     badge: true,
     carPlay: false,
     criticalAlert: false,
     provisional: false,
     sound: true,
   );

   print('User granted permission: ${settings.authorizationStatus}');
   ```

2. Check the `authorizationStatus` property of the returned `NotificationSettings` to determine the user's decision.
3. For Android versions prior to 13, be aware that `authorizationStatus` returns `authorized` if the user has not disabled notifications in the OS settings.
4. For Android 13 and above, track permission requests in your app as there's no way to determine if the user has chosen to grant/deny permission.
5. Consider using provisional permissions on iOS by setting `provisional: true` to allow users to choose notification types after receiving their first notification.
   ```dart
   final notificationSettings = await FirebaseMessaging.instance.requestPermission(provisional: true);
   ```

### Platform-Specific Considerations

1. On iOS, if the user swipes away the application from the app switcher, it must be manually reopened for background messages to work again.
2. On Android, if the user force-quits the app from device settings, it must be manually reopened for messages to work.
3. On web, you must have requested a token using `getToken()` with your web push certificate.
4. For notification messages to display while the app is in the foreground on Android, create a "High Priority" notification channel.
5. For notification messages to display while the app is in the foreground on iOS, update the presentation options for the application.
6. For web platforms, create and register a service worker file named `firebase-messaging-sw.js` in your web directory:
   ```js
   // Please see this file for the latest firebase-js-sdk version:
   // https://github.com/firebase/flutterfire/blob/main/packages/firebase_core/firebase_core_web/lib/src/firebase_sdk_version.dart
   importScripts("https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js");
   importScripts("https://www.gstatic.com/firebasejs/10.7.0/firebase-messaging-compat.js");

   firebase.initializeApp({
     apiKey: "...",
     authDomain: "...",
     databaseURL: "...",
     projectId: "...",
     storageBucket: "...",
     messagingSenderId: "...",
     appId: "...",
   });

   const messaging = firebase.messaging();

   // Optional:
   messaging.onBackgroundMessage((message) => {
     console.log("onBackgroundMessage", message);
   });
   ```

### Token Management

1. Retrieve the FCM registration token using `getToken()` to send messages to specific devices.
   ```dart
   final fcmToken = await FirebaseMessaging.instance.getToken();
   print("FCM Token: $fcmToken");
   ```
2. For web platforms, provide your VAPID public key when requesting a token.
   ```dart
   final fcmToken = await FirebaseMessaging.instance.getToken(
     vapidKey: "BKagOny0KF_2pCJQ3m....moL0ewzQ8rZu"
   );
   ```
3. Subscribe to the `onTokenRefresh` stream to be notified when the token is updated.
   ```dart
   FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
     // Send token to your application server
   }).onError((err) {
     // Handle error
   });
   ```
4. For Apple platforms, ensure the APNS token is available before making FCM plugin API calls.
   ```dart
   final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
   if (apnsToken != null) {
     // APNS token is available, make FCM plugin API requests
   }
   ```

### Auto-Initialization Control

1. Disable FCM auto-initialization on iOS by adding metadata to Info.plist.
   ```
   FirebaseMessagingAutoInitEnabled = NO
   ```
2. Disable FCM auto-initialization on Android by adding metadata to AndroidManifest.xml.
   ```xml
   <meta-data
       android:name="firebase_messaging_auto_init_enabled"
       android:value="false" />
   <meta-data
       android:name="firebase_analytics_collection_enabled"
       android:value="false" />
   ```
3. Re-enable auto-initialization at runtime if needed.
   ```dart
   await FirebaseMessaging.instance.setAutoInitEnabled(true);
   ```
4. Be aware that the auto-initialization setting persists across app restarts once set.
