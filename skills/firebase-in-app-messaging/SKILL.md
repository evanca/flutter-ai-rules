---
name: firebase-in-app-messaging
description: "Use when running in-app message campaigns, triggering/suppressing messages, configuring opt-in data collection, testing on specific devices, rendering campaigns with custom Flutter widgets, or handling message callbacks."
license: MIT
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
* Rendering campaigns with custom Flutter widgets instead of native templates.

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

- Use **custom metadata** (key-value pairs) to pass additional info accessible when users interact with messages. With custom Flutter display enabled, read it from `InAppMessage.data`.
- Use **A/B testing** to optimize message content, timing, and conversion rates.
- Monitor campaign performance (impressions, clicks, conversions) through Firebase console analytics.

---

## 6. Custom Flutter Display

By default, In-App Messaging draws native templates. To render campaigns with your own Flutter widgets, listen to `onMessageDisplay`, report the lifecycle back to the SDK, and opt in with `setCustomDisplayEnabled(true)`:

```dart
FirebaseInAppMessaging.instance.onMessageDisplay.listen((message) async {
  await message.impress();

  // Both are null for campaigns published without an action (image-only
  // layouts, action-less banners), so resolve the action before using it.
  final action = message.primaryAction ?? message.action;

  // showCampaign() is your own widget; draw it from message.title, body,
  // imageUrl, actions and data, and complete when the user closes it.
  await showCampaign(
    message,
    onActionTap: action == null
        ? null
        : () async {
            await message.click(action);
            // The plugin does not open action URLs — your app should.
          },
  );

  await message.dismiss();
});

await FirebaseInAppMessaging.instance.setCustomDisplayEnabled(true);
```

- Listening to `onMessageDisplay` alone does not replace native UI — native templates keep showing until `setCustomDisplayEnabled(true)` is called.
- Report `impress()` when your UI appears, `click()` **only from the user's tap handler**, and `dismiss()` when it closes; `onMessageImpression` / `onMessageClicked` still fire.
- `action`, `primaryAction` and `secondaryAction` are all `InAppMessageAction?`, while `click(InAppMessageAction action)` takes a non-nullable action — a campaign published without one has nothing to report and must skip `click()`. `action` is the single action for banner, modal and image-only layouts, `primaryAction` is card-only, and `imageOnly` carries an *optional* tap action, so both are null for an image-only campaign with no action.
- `click()`, `dismiss()` and `reportError()` share one terminal latch — the first call wins and the others return as no-ops. Reporting a click on display therefore also discards the dismiss.
- The Firebase doc example calls `click()` in the listener body and force-unwraps with `message.action!`. Verified against the plugin source: for an action-less campaign it throws `Null check operator used on a null value`, and because the throw sits inside an `async` stream listener it goes unhandled — only `impress()` reaches the SDK and no terminal event is ever reported. For a campaign that does carry an action it reports a click the user never made, then silently drops the dismiss.
- Open action URLs yourself; the plugin does not.

---

## References

- [Firebase In-App Messaging Flutter documentation](https://firebase.google.com/docs/in-app-messaging/get-started?platform=flutter)
- [Modify message behavior](https://firebase.google.com/docs/in-app-messaging/modify-message-behavior?platform=flutter)
- [`FirebaseInAppMessaging` API reference](https://pub.dev/documentation/firebase_in_app_messaging/latest/firebase_in_app_messaging/FirebaseInAppMessaging-class.html) — `onMessageDisplay`, `setCustomDisplayEnabled`
- [`InAppMessage` API reference](https://pub.dev/documentation/firebase_in_app_messaging/latest/firebase_in_app_messaging/InAppMessage-class.html) — action nullability, `impress`/`click`/`dismiss`
