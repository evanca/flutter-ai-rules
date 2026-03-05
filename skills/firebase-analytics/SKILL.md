---
name: firebase-analytics
description: Integrates Firebase Analytics into Flutter apps. Use when setting up analytics, logging events, setting user properties, or configuring event parameters.
---

# Firebase Analytics Skill

This skill defines how to correctly use Firebase Analytics in Flutter applications.

## When to Use

Use this skill when:

* Setting up and configuring Firebase Analytics in a Flutter project.
* Logging predefined or custom events.
* Setting user properties or default event parameters.
* Applying best practices for analytics data collection.

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

Custom events:

```dart
await FirebaseAnalytics.instance.logEvent(
  name: "share_image",
  parameters: {
    "image_name": name,
    "full_text": text,
  },
);
```

- Event names are **case-sensitive** — names differing only in case create two distinct events.
- You can log up to **500 different event types** with no limit on total event volume.

---

## 3. Parameters and Properties

- Parameter names: up to **40 characters**, must start with an alphabetic character, contain only alphanumeric characters and underscores.
- String parameter values: up to **100 characters**.
- The prefixes `firebase_`, `google_`, and `ga_` are **reserved** — do not use them for parameter names.
- Use custom parameters for non-numerical data (dimensions) or numerical data (metrics); register them in the Analytics console first.

Set default parameters for all future events (not supported on web):

```dart
await FirebaseAnalytics.instance.setDefaultEventParameters({
  'version': '1.2.3',
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

- Create custom definitions for user properties in the Analytics console before using them.
- Use user properties for custom definitions, report comparisons, or audience criteria.

---

## 5. Best Practices

- **Request necessary permissions** before collecting user data, especially on platforms with strict privacy controls.
- **Never log** sensitive or personally identifiable information in events or user properties.
- Use **consistent naming conventions** for custom events and parameters.
- Group related events to track user flows and conversion funnels.
- **Test** your analytics implementation before deploying to production.

---

## References

- [Firebase Analytics Flutter documentation](https://firebase.google.com/docs/analytics/get-started?platform=flutter)
- [Recommended events](https://support.google.com/analytics/answer/9267735)
- [Automatically collected events](https://support.google.com/analytics/answer/9234069)
