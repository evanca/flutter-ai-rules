---
name: firebase-in-app-messaging
description: Integrates Firebase In-App Messaging into Flutter apps. Use when setting up in-app messaging, triggering or suppressing messages, managing user privacy and opt-in data collection, or testing campaigns.
---

# Firebase In-App Messaging Skill

This skill defines how to correctly use Firebase In-App Messaging in Flutter applications.

## When to Use

Use this skill when:

* Setting up Firebase In-App Messaging in a Flutter project.
* Triggering or suppressing in-app messages programmatically.
* Implementing opt-in data collection for user privacy.
* Testing campaigns with specific devices.

---

## 1. Setup and Configuration

```
flutter pub add firebase_in_app_messaging
```

```dart
import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';
```

- Initialize Firebase before using any In-App Messaging features.
- In-App Messaging **retrieves messages from the server once per day** by default to conserve power.

**Finding your Installation ID for testing:**
- **Android:** Look for `I/FIAM.Headless: Starting InAppMessaging runtime with Installation ID YOUR_INSTALLATION_ID` in logcat (filter by "FIAM.Headless").
- **iOS:** Enable debug mode by adding `-FIRDebugEnabled` as a runtime argument in Xcode's scheme settings; find `[Firebase/InAppMessaging][I-IAM180017]` in Xcode console logs.

---

## 2. Message Triggering and Display

Use Google Analytics events to trigger in-app messages without additional code. For programmatic triggering:

```dart
FirebaseInAppMessaging.instance.triggerEvent("eventName");
```

**Suppress messages during critical flows** (e.g., payment processing):

```dart
FirebaseInAppMessaging.instance.setMessagesSuppressed(true);
// Re-enable when appropriate:
FirebaseInAppMessaging.instance.setMessagesSuppressed(false);
```

- Suppression is **automatically turned off** on app restart.
- Suppressed messages are ignored — their trigger conditions must be met again after suppression is lifted.
- Platform-specific message interaction callbacks (iOS/Android) are not directly accessible from Flutter; use native APIs for those.

---

## 3. User Privacy and Opt-In Data Collection

By default, In-App Messaging automatically delivers messages to all targeted users.

**Disable automatic collection — iOS** (`Info.plist`):
```
FirebaseInAppMessagingAutomaticDataCollectionEnabled = NO
```

**Disable automatic collection — Android** (`AndroidManifest.xml`):
```xml
<meta-data
    android:name="firebase_inapp_messaging_auto_data_collection_enabled"
    android:value="false" />
```

**Enable for users who opt in:**
```dart
FirebaseInAppMessaging.instance.setAutomaticDataCollectionEnabled(true);
```

- Manually set preferences **persist through app restarts**, overriding configuration file values.

---

## 4. Testing and Debugging

- Use the Firebase console's **"Test on your Device"** feature, entering the app's Firebase Installation ID to send test messages on demand.
- Always test on **actual devices** for proper rendering and behavior.

---

## 5. Campaign Management

- Create campaigns in the Firebase console under **Messaging**.
- Message types: **modal**, **banner**, **card**, or **image-only**.
- Use **custom metadata** (key-value pairs) to pass additional info accessible when users interact with messages.
- Target based on user segments, app version, language, and Analytics-based conditions.
- Use **A/B testing** to optimize message content and delivery.
- Monitor campaign performance through Firebase console analytics.

---

## References

- [Firebase In-App Messaging Flutter documentation](https://firebase.google.com/docs/in-app-messaging/get-started?platform=flutter)
