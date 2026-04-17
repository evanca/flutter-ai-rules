---
name: firebase-messaging
description: A complete end-to-end guide for Firebase Cloud Messaging in Flutter. Covers client setup in Flutter, managing permissions and tokens, handling background/foreground taps, and server-side HTTP v1 dispatch using Service Accounts.
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
- Ensure the bundle ID for your APNs authentication key matches your app's bundle ID.

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

**Token Lifecycle (Auth State):**
Tokens should be tied to user sessions. Save the token to your database when a user signs in, and **delete** the token (or remove it from the user's document) when they sign out. An FCM token is device-specific, not inherently tied to user auth data — failing to clear it on sign-out means the next user on that device might receive the previous user's notifications.

---

## 5. Platform-Specific Behavior

- **iOS:** If the user swipes away the app from the app switcher, it must be **manually reopened** for background messages to work again.
- **Android:** If the user force-quits from device settings, the app must be **manually reopened**.
- **iOS foreground notifications:** Update presentation options to display notifications while the app is in the foreground:
  ```dart
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  ```
- **Android foreground notifications:** Notification messages arriving while the app is in the foreground won't display a visible notification by default. You must consume the payload via the `onMessage` stream and manually display a visual cue (using your own UI logic or a local notifications plugin).
- **Android default channel:** To set a default channel for background notifications, add this `meta-data` to your `<application>` block in `AndroidManifest.xml`:
  ```xml
  <meta-data
      android:name="com.google.firebase.messaging.default_notification_channel_id"
      android:value="high_importance_channel" />
  ```

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

## 8. Notification Interaction Handling

When a user taps a notification, the app opens (or is brought to the foreground). Handle the interaction in both cases:

**App was terminated:**

```dart
RemoteMessage? initialMessage =
    await FirebaseMessaging.instance.getInitialMessage();
if (initialMessage != null) {
  // Navigate based on message content
}
```

**App was in background:**

```dart
FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  // Navigate based on message content
});
```

Always handle **both** scenarios to ensure a smooth user experience regardless of app state when the notification was received.

---

## 9. Topic Messaging

- Subscribing to a topic allows sending messages to multiple devices that have opted in.
- Topic messages are best suited for publicly available information (e.g., weather updates), optimized for throughput rather than latency.

```dart
// Subscribe
await FirebaseMessaging.instance.subscribeToTopic("weather_alerts");

// Unsubscribe
await FirebaseMessaging.instance.unsubscribeFromTopic("weather_alerts");
```

> **Note:** `subscribeToTopic()` and `unsubscribeFromTopic()` are not supported for web clients via the Flutter plugin.

---

## 10. Sending a Test Message

The official Firebase documentation often obscures the exact steps for sending a test push notification. To fire a push (test or real) using the Firebase Console:

1. Obtain your device's **FCM registration token** (see Section 4).
2. Go to the [Firebase Console](https://console.firebase.google.com/) and select your project.
3. In the left navigation panel, find the **Engage** (or **Run**) section and click **Messaging** (or **Cloud Messaging**).
4. Click **New campaign** and select **Notifications**.
5. Enter a **Notification title** and **Notification text**.
6. Click **Send test message** (often a button on the right side of the screen).
7. In the dialog, enter your **FCM registration token** and click the `+` icon to add it.
8. Make sure the token is checked, then click **Test**.

> To send real automated push notifications to production users, you must use a server implementation (via the FCM HTTP v1 API or the Firebase Admin SDK) rather than the console.

---

## 11. Server-Side Credentials & Security

The legacy FCM server key endpoint was deprecated in June 2024 — **HTTP v1 is the only supported option** for sending pushes.

To authenticate server-to-server calls for HTTP v1, you need a Service Account:
1. Go to **Firebase Console → Project settings → Service accounts**.
2. Click **Generate new private key** (downloads a `.json` file).
3. **CRITICAL:** This file contains highly sensitive secrets and **must never be committed to git**.
4. Store the file securely (e.g., in a Secret Manager) or pass its stringified contents as an environment variable (like `FIREBASE_SERVICE_ACCOUNT`) to your backend.

---

## 12. Sending Messages (HTTP v1)

To send an FCM HTTP v1 message, your backend must:
1. Complete an OAuth2 JWT exchange (sign with RS256, scope `https://www.googleapis.com/auth/firebase.messaging`, endpoint `https://oauth2.googleapis.com/token`).
2. Construct and `POST` a JSON payload to `https://fcm.googleapis.com/v1/projects/{project_id}/messages:send`.

Here is a minimal, complete working example using Node.js and the `google-auth-library`:

```javascript
const { GoogleAuth } = require('google-auth-library');

// Read the securely-stored service account JSON from environment
const credentials = JSON.parse(process.env.FIREBASE_SERVICE_ACCOUNT);

async function getAccessToken() {
  const auth = new GoogleAuth({
    credentials,
    scopes: ['https://www.googleapis.com/auth/firebase.messaging']
  });
  const client = await auth.getClient();
  const token = await client.getAccessToken();
  return token.token;
}

async function sendPushNotification(fcmToken, title, body) {
  const accessToken = await getAccessToken();
  const projectId = credentials.project_id;
  const url = `https://fcm.googleapis.com/v1/projects/${projectId}/messages:send`;
  
  const payload = {
    message: {
      token: fcmToken,
      notification: {
        title: title,
        body: body,
      },
      // Target specific platform features (e.g., channel on Android, sound on iOS)
      android: {
        notification: {
          channel_id: 'high_importance_channel',
        }
      },
      apns: {
        payload: {
          aps: {
            sound: 'default',
          }
        }
      }
    }
  };

  const response = await fetch(url, {
    method: 'POST',
    headers: {
      'Authorization': `Bearer ${accessToken}`,
      'Content-Type': 'application/json'
    },
    body: JSON.stringify(payload)
  });

  return response.json();
}
```

---

## References

- [Firebase Cloud Messaging Flutter documentation](https://firebase.google.com/docs/cloud-messaging/flutter/client)
- [Send a test message to a backgrounded app](https://firebase.google.com/docs/cloud-messaging/flutter/first-message)
- [Receive messages in Flutter](https://firebase.google.com/docs/cloud-messaging/flutter/receive)
- [Topic messaging on Flutter](https://firebase.google.com/docs/cloud-messaging/flutter/topic-messaging)
- [Migrate from legacy FCM APIs to HTTP v1](https://firebase.google.com/docs/cloud-messaging/migrate-v1)
- [Server environment authorization (for OAuth2 / Service Accounts)](https://firebase.google.com/docs/cloud-messaging/auth-server)
- [FCM HTTP v1 API Reference](https://firebase.google.com/docs/reference/fcm/rest/v1/projects.messages)
- [Android Receive Docs (for default channel ID)](https://firebase.google.com/docs/cloud-messaging/android/receive)
- [FirebaseMessaging setForegroundNotificationPresentationOptions (API Reference)](https://pub.dev/documentation/firebase_messaging/latest/firebase_messaging/FirebaseMessaging/setForegroundNotificationPresentationOptions.html)
