---
name: firebase-in-app-messaging
description: "Integrates Firebase In-App Messaging into Flutter apps. Use when implementing in-app message campaigns, triggering or suppressing messages programmatically, configuring opt-in data collection for user privacy compliance, testing campaigns on specific devices, handling message interaction callbacks, or managing A/B tests for in-app messaging."
---

# Firebase In-App Messaging Skill

This skill defines how to correctly implement Firebase In-App Messaging in Flutter applications, covering setup, programmatic triggers, privacy controls, testing workflows, and campaign management.

## When to Use

Use this skill when:

* Setting up Firebase In-App Messaging in a Flutter project.
* Triggering or suppressing in-app messages programmatically.
* Implementing opt-in data collection for GDPR or user privacy compliance.
* Testing campaigns with specific devices before rollout.
* Configuring message types, targeting rules, and A/B tests.

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

### Setup Checklist

1. Confirm `Firebase.initializeApp()` completes before accessing In-App Messaging.
2. Create a test campaign in the Firebase console to verify the integration.
3. Locate the Installation ID for device-specific testing (see Testing section).

---

## 2. Message Triggering and Display

Use Google Analytics events to trigger in-app messages without additional code. For programmatic triggering:

```dart
// Trigger a message tied to a custom event
await FirebaseInAppMessaging.instance.triggerEvent("purchase_complete");
```

### Suppress Messages During Critical Flows

```dart
class PaymentScreen extends StatefulWidget {
  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  @override
  void initState() {
    super.initState();
    // Suppress messages during payment
    FirebaseInAppMessaging.instance.setMessagesSuppressed(true);
  }

  @override
  void dispose() {
    // Re-enable messages when leaving payment flow
    FirebaseInAppMessaging.instance.setMessagesSuppressed(false);
    super.dispose();
  }
}
```

- Suppression is **automatically turned off** on app restart.
- Suppressed messages are ignored — their trigger conditions must be met again after suppression is lifted.
- Common flows to suppress: payment processing, onboarding wizards, form submission screens.

---

## 3. User Privacy and Opt-In Data Collection

By default, In-App Messaging automatically delivers messages to all targeted users.

**Disable automatic collection — iOS** (`Info.plist`):
```xml
<key>FirebaseInAppMessagingAutomaticDataCollectionEnabled</key>
<false/>
```

**Disable automatic collection — Android** (`AndroidManifest.xml`):
```xml
<meta-data
    android:name="firebase_inapp_messaging_auto_data_collection_enabled"
    android:value="false" />
```

**Enable for users who opt in at runtime:**
```dart
// Call after user consents to data collection
Future<void> enableMessaging() async {
  await FirebaseInAppMessaging.instance.setAutomaticDataCollectionEnabled(true);
}

// Call if user revokes consent
Future<void> disableMessaging() async {
  await FirebaseInAppMessaging.instance.setAutomaticDataCollectionEnabled(false);
}
```

- Manually set preferences **persist through app restarts**, overriding configuration file values.
- For GDPR compliance, disable automatic collection by default and enable only after explicit user consent.

---

## 4. Testing and Debugging

### Find the Installation ID

- **Android:** Filter logcat by `FIAM.Headless` — look for `Starting InAppMessaging runtime with Installation ID YOUR_INSTALLATION_ID`.
- **iOS:** Add `-FIRDebugEnabled` as a runtime argument in Xcode scheme settings. Look for `[Firebase/InAppMessaging][I-IAM180017]` in the console.

### Test a Campaign

1. In the Firebase console, open the campaign and select **Test on your Device**.
2. Enter the Installation ID from the step above.
3. The test message appears on the next app launch or foreground event.

- Always test on **actual devices** for proper rendering and behavior.
- Test each message type (modal, banner, card, image-only) to verify layout on different screen sizes.

---

## 5. Campaign Management

- Create campaigns in the Firebase console under **Messaging > In-App Messaging**.
- Message types: **modal**, **banner**, **card**, or **image-only**.

### Campaign Configuration Workflow

1. **Design** — Select the message type and customize appearance (title, body, image, button).
2. **Target** — Define the audience by app version, language, user segment, or Analytics-based conditions.
3. **Schedule** — Set start/end dates and frequency caps (once, once per session, etc.).
4. **Trigger** — Choose the Analytics event that displays the message (e.g., `app_open`, `purchase_complete`).
5. **Test** — Use device testing before publishing.
6. **Publish** — Launch the campaign and monitor performance.

- Use **custom metadata** (key-value pairs) to pass additional info accessible when users interact with messages.
- Use **A/B testing** to optimize message content, timing, and conversion rates.
- Monitor campaign performance (impressions, clicks, conversions) through Firebase console analytics.

---

## References

- [Firebase In-App Messaging Flutter documentation](https://firebase.google.com/docs/in-app-messaging/get-started?platform=flutter)
