# Firebase Cloud Messaging Rules

### Setup and Configuration

1. Enable push notifications and background modes in your Xcode project for iOS targets.
2. Upload your APNs authentication key to Firebase before using FCM on iOS.
3. Do not disable method swizzling on Apple devices, as it's required for FCM token handling.
4. Request user permission before FCM payloads can be received on iOS, macOS, web, and Android 13 or newer.
5. For iOS, ensure the bundle ID for your APNs authentication key matches the bundle ID of your app.
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
4. **Android target setup**: Configure a default channel for background notifications by setting the `com.google.firebase.messaging.default_notification_channel_id` metadata in `AndroidManifest.xml`. By default, FCM notifications won't display visibly when the Android app is foregrounded; you must consume the payload via `onMessage` and handle visualizations manually or with a local notifications package.
5. **iOS foreground handling**: Call `FirebaseMessaging.instance.setForegroundNotificationPresentationOptions()` with the desired visual presentation options (e.g., alert, badge, sound) to enable visible foreground notifications.
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
   **Rule:** Always securely save FCM tokens keyed to user auth sessions. Revoke or delete this token mapping from the backend on sign-out to prevent the next user on a shared device from receiving the previous user's push notifications.
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

### Notification Interaction Handling

1. Handle notification taps when the app is launched from a **terminated state** using `getInitialMessage()`, which returns a `Future<RemoteMessage?>`. Once consumed, the `RemoteMessage` is removed.
   ```dart
   RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
   if (initialMessage != null) {
     // App opened from terminated state via notification
   }
   ```
2. Handle notification taps when the app is in a **background state** using the `onMessageOpenedApp` stream.
   ```dart
   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
     // App brought to foreground via notification tap
   });
   ```
3. Always handle both `getInitialMessage()` and `onMessageOpenedApp` to ensure a smooth experience regardless of whether the app was terminated or backgrounded when the notification was tapped.

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

### iOS Image Notifications

**Important**: The iOS simulator does not display images in push notifications. You must test on a physical device.

1. Add a notification service extension in Xcode for iOS image support.
2. Select either Swift or Objective-C when creating the notification service extension.
3. For Swift implementations, use the `FirebaseMessaging` Swift package by adding it to your target.
4. For Objective-C implementations, add the Firebase/Messaging pod to your Podfile.
5. Configure the notification service extension to use `Messaging.serviceExtension().populateNotificationContent()` for image handling.

### Server Dispatch and Security

1. Ensure backend systems invoke pushes via the **FCM HTTP v1 API**. The legacy server key endpoints are strictly deprecated.
2. Authenticate server-to-server calls via an OAuth2 JWT exchange relying on a downloaded `.json` Service Account key.
3. Manage the Service Account securely. It must **never** be committed to Git. Instead, provision it inside secret managers or inject it as a stringified variable via CI/CD (e.g., `FIREBASE_SERVICE_ACCOUNT`).
4. Construct the HTTP v1 payload strictly according to the format required by `POST https://fcm.googleapis.com/v1/projects/{project_id}/messages:send`, using nested platform attributes (e.g., `android.notification.channel_id` or `apns.payload.aps`) to trigger specific OS-level notification settings.
