---
name: firebase-messaging
description: Integrates Firebase Cloud Messaging (FCM) into Flutter apps. Use when setting up push notifications, handling foreground/background messages, managing permissions, working with FCM tokens, or configuring platform-specific notification behavior.
---

# Firebase Cloud Messaging Skill

This skill defines how to correctly use Firebase Cloud Messaging (FCM) in Flutter applications.

## When to Use

Use this skill when:

* Setting up push notifications with FCM in a Flutter project.
* Handling messages in foreground, background, and terminated states.
* Managing notification permissions and FCM tokens.
* Configuring platform-specific notification display behavior.

---

## 1. Setup and Configuration

```
flutter pub add firebase_messaging
```

**iOS:**
- Enable **Push Notifications** and **Background Modes** in Xcode.
- Upload your **APNs authentication key** to Firebase before using FCM.
- Do **not** disable method swizzling — it is required for FCM token handling.
- Ensure the bundle ID for your APNs certificate matches your app's bundle ID.

**Android:**
- Devices must run **Android 4.4+** with Google Play services installed.
- Check for Google Play services compatibility in both `onCreate()` and `onResume()`.

**Web:**
- Create and register a service worker file named `firebase-messaging-sw.js` in your `web/` directory:

```js
importScripts("https://www.gstatic.com/firebasejs/10.7.0/firebase-app-compat.js");
importScripts("https://www.gstatic.com/firebasejs/10.7.0/firebase-messaging-compat.js");

firebase.initializeApp({ /* your config */ });

const messaging = firebase.messaging();

messaging.onBackgroundMessage((message) => {
  console.log("onBackgroundMessage", message);
});
```

---

## 2. Message Handling

**Foreground messages:**

```dart
FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  print('Foreground message data: ${message.data}');
  if (message.notification != null) {
    print('Notification: ${message.notification}');
  }
});
```

**Background messages:**

```dart
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Initialize Firebase before using other Firebase services in background
  await Firebase.initializeApp();
  print("Background message: ${message.messageId}");
}

void main() {
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  runApp(MyApp());
}
```

Background handler rules:
- Must be a **top-level function** (not anonymous, not a class method).
- Annotate with `@pragma('vm:entry-point')` (Flutter 3.3.0+) to prevent removal during tree shaking in release mode.
- Cannot update app state or execute UI-impacting logic — runs in a separate isolate.
- Call `Firebase.initializeApp()` before using any other Firebase services.

---

## 3. Permissions

```dart
NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
  alert: true,
  badge: true,
  sound: true,
  announcement: false,
  carPlay: false,
  criticalAlert: false,
  provisional: false,
);

print('Authorization status: ${settings.authorizationStatus}');
```

- **iOS / macOS / Web / Android 13+:** Must request permission before receiving FCM payloads.
- **Android < 13:** `authorizationStatus` returns `authorized` if the user has not disabled notifications in OS settings.
- **Android 13+:** Track permission requests in your app — there's no way to determine if the user chose to grant/deny.
- Use **provisional permissions** on iOS (`provisional: true`) to let users choose notification types after receiving their first notification.

---

## 4. Token Management

**Get FCM registration token (use to send messages to a specific device):**

```dart
final fcmToken = await FirebaseMessaging.instance.getToken();
```

**Web — provide VAPID key:**

```dart
final fcmToken = await FirebaseMessaging.instance.getToken(
  vapidKey: "BKagOny0KF_2pCJQ3m....moL0ewzQ8rZu"
);
```

**Listen for token refresh:**

```dart
FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
  // Send updated token to your application server
}).onError((err) {
  // Handle error
});
```

**Apple platforms — ensure APNS token is available before FCM calls:**

```dart
final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
if (apnsToken != null) {
  // Safe to make FCM plugin API requests
}
```

---

## 5. Platform-Specific Behavior

- **iOS:** If the user swipes away the app from the app switcher, it must be **manually reopened** for background messages to work again.
- **Android:** If the user force-quits from device settings, the app must be **manually reopened**.
- **Android foreground notifications:** Create a **"High Priority"** notification channel to display notifications while the app is in the foreground.
- **iOS foreground notifications:** Update presentation options to display notifications while the app is in the foreground.

---

## 6. Auto-Initialization Control

**Disable auto-init — iOS** (`Info.plist`):
```
FirebaseMessagingAutoInitEnabled = NO
```

**Disable auto-init — Android** (`AndroidManifest.xml`):
```xml
<meta-data android:name="firebase_messaging_auto_init_enabled" android:value="false" />
<meta-data android:name="firebase_analytics_collection_enabled" android:value="false" />
```

**Re-enable at runtime:**
```dart
await FirebaseMessaging.instance.setAutoInitEnabled(true);
```

- The auto-init setting **persists across app restarts** once set.

---

## 7. iOS Image Notifications

> **Important:** The iOS simulator does **not** display images in push notifications. Test on a physical device.

- Add a **Notification Service Extension** in Xcode.
- Use `Messaging.serviceExtension().populateNotificationContent()` in the extension for image handling.
- Swift: add the `FirebaseMessaging` Swift package to your extension target.
- Objective-C: add the `Firebase/Messaging` pod to your Podfile.

---

## References

- [Firebase Cloud Messaging Flutter documentation](https://firebase.google.com/docs/cloud-messaging/flutter/client)
- [Receive messages in Flutter](https://firebase.google.com/docs/cloud-messaging/flutter/receive)
