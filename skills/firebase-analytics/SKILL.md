---
name: firebase-analytics
description: "Integrates Firebase Analytics into Flutter apps. Use when implementing event tracking, logging custom or predefined analytics events, setting user properties, configuring default event parameters, creating conversion funnels, or adding screen view tracking. Covers setup, event logging, parameter constraints, and privacy best practices."
---

# Firebase Analytics Skill

This skill defines how to correctly implement Firebase Analytics in Flutter applications, covering setup, event logging, user properties, and data collection best practices.

## When to Use

Use this skill when:

* Setting up and configuring Firebase Analytics in a Flutter project.
* Logging predefined or custom analytics events.
* Setting user properties or default event parameters.
* Implementing screen view tracking with GoRouter or Navigator observers.
* Building conversion funnels or tracking user flows.

---

## 1. Setup and Configuration

```
flutter pub add firebase_analytics
flutter run
```

```dart
import 'package:firebase_analytics/firebase_analytics.dart';

// After Firebase.initializeApp():
FirebaseAnalytics analytics = FirebaseAnalytics.instance;
```

- Initialize Firebase before using any Firebase Analytics features.
- Analytics **automatically logs** some events and user properties — no additional code needed for those.
- On iOS, if your app does not use the IDFA (Advertising Identifier), use `FirebaseAnalyticsWithoutAdIdSupport` instead of the default iOS dependency to avoid App Store review questions about advertising identifiers:
  - **Swift Package Manager:** set `FIREBASE_ANALYTICS_WITHOUT_ADID=true` when building (`FIREBASE_ANALYTICS_WITHOUT_ADID=true flutter build ios`).
  - **CocoaPods:** add both `pod 'FirebaseAnalytics', :modular_headers => true` and `pod 'FirebaseAnalyticsWithoutAdIdSupport', :modular_headers => true` to your `Podfile`.

### Add Navigator Observer for Automatic Screen Tracking

```dart
MaterialApp(
  navigatorObservers: [
    FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
  ],
);
```

For GoRouter, log screen views manually on route changes:

```dart
GoRouter(
  observers: [FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance)],
);
```

### Verification Checklist

1. Confirm `Firebase.initializeApp()` completes before accessing `FirebaseAnalytics.instance`.
2. Run the app and check the Firebase DebugView console for incoming events.
3. Confirm automatic events (`first_open`, `session_start`) appear without extra code.

---

## 2. Event Logging

Use **predefined event methods** when possible for maximum detail in reports and access to future Google Analytics features:

```dart
await FirebaseAnalytics.instance.logSelectContent(
  contentType: "image",
  itemId: itemId,
);
```

Use the general `logEvent()` method for both predefined and custom events:

```dart
await FirebaseAnalytics.instance.logEvent(
  name: "select_content",
  parameters: {
    "content_type": "image",
    "item_id": itemId,
  },
);
```

### Custom Event Example — E-commerce Add-to-Cart

```dart
Future<void> logAddToCart(String productId, String productName, double price) async {
  await FirebaseAnalytics.instance.logEvent(
    name: 'add_to_cart',
    parameters: {
      'product_id': productId,
      'product_name': productName,
      'price': price,
      'currency': 'USD',
    },
  );
}
```

- Event names are **case-sensitive** — names differing only in case create two distinct events.
- Up to **500 different event types** with no limit on total event volume.
- Event names must start with an alphabetic character, contain only alphanumeric characters and underscores, and be no longer than **40 characters**.

---

## 3. Parameters and Properties

- Parameter names: up to **40 characters**, must start with an alphabetic character, contain only alphanumeric characters and underscores.
- String parameter values: up to **100 characters**.
- The prefixes `firebase_`, `google_`, and `ga_` are **reserved** — do not use them for parameter names.
- Up to **25 custom parameters** per event.
- Register custom parameters in the Analytics console to use them as dimensions or metrics in reports.

Set default parameters for all future events (not supported on web):

```dart
await FirebaseAnalytics.instance.setDefaultEventParameters({
  'app_version': '1.2.3',
  'environment': 'production',
});
```

Clear a default parameter by setting it to `null`.

---

## 4. User Properties

```dart
await FirebaseAnalytics.instance.setUserProperty(
  name: 'favorite_food',
  value: favoriteFood,
);
```

Set the user ID to correlate events across devices:

```dart
await FirebaseAnalytics.instance.setUserId(id: 'user_12345');
```

- Create custom definitions for user properties in the Analytics console before using them.
- Up to **25 custom user properties** per project.
- Use user properties for audience segmentation, report filtering, or A/B test targeting.

---

## 5. Best Practices

- **Request necessary permissions** before collecting user data, especially on platforms with strict privacy controls.
- **Never log** sensitive or personally identifiable information in events or user properties.
- Use **consistent naming conventions** (snake_case) for custom events and parameters.
- Group related events to track user flows and conversion funnels.
- Use **DebugView** in the Firebase console during development — enable it on a physical device with:
  - **Android:** `adb shell setprop debug.firebase.analytics.app <package_name>`
  - **iOS:** Add `-FIRDebugEnabled` to scheme arguments in Xcode.
- **Test** analytics implementation before deploying to production by confirming events appear in DebugView.

---

## References

- [FlutterFire GitHub Repository](https://github.com/firebase/flutterfire)
