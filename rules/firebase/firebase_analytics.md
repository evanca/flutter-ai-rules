# Firebase Analytics Rules

### Setup and Configuration

1. Install Firebase Analytics using `flutter pub add firebase_analytics` in your Flutter project.
2. Rebuild your Flutter application using `flutter run` after installation.
3. Import the package in your Dart code using `import 'package:firebase_analytics/firebase_analytics.dart';`.
4. Create a new Firebase Analytics instance by accessing the `instance` property on `FirebaseAnalytics`.
   ```dart
   FirebaseAnalytics analytics = FirebaseAnalytics.instance;
   ```
5. Initialize Firebase before using any Firebase Analytics features.

### Event Logging

1. Use predefined event types when possible to get maximum detail in reports and benefit from the latest Google Analytics features.
2. Log events using the library's dedicated methods for recommended event types.
   ```dart
   await FirebaseAnalytics.instance.logSelectContent(
     contentType: "image",
     itemId: itemId,
   );
   ```
3. Alternatively, use the general `logEvent()` method for both predefined and custom events.
   ```dart
   await FirebaseAnalytics.instance.logEvent(
     name: "select_content",
     parameters: {
       "content_type": "image",
       "item_id": itemId,
     },
   );
   ```
4. For custom events, use the `logEvent()` method with a descriptive name and relevant parameters.
   ```dart
   await FirebaseAnalytics.instance.logEvent(
     name: "share_image",
     parameters: {
       "image_name": name,
       "full_text": text,
     },
   );
   ```
5. Event names are case-sensitive; logging two events whose names differ only in case will result in two distinct events.
6. You can log up to 500 different Analytics Event types in your app with no limit on the total volume of events.

### Parameters and Properties

1. Parameter names can be up to 40 characters long and must start with an alphabetic character.
2. Parameter names must contain only alphanumeric characters and underscores.
3. String parameter values can be up to 100 characters long.
4. The "firebase_", "google_" and "ga_" prefixes are reserved and shouldn't be used for parameter names.
5. Use custom parameters for non-numerical event parameter data (dimensions) or numerical data (metrics).
6. Register custom dimensions or metrics in the Analytics console to ensure they appear in reports.
7. Set default event parameters using `setDefaultEventParameters()` to associate parameters with all future events.
   ```dart
   // Not supported on web
   await FirebaseAnalytics.instance
     .setDefaultEventParameters({
       version: '1.2.3'
     });
   ```
8. To clear a default parameter, call `setDefaultEventParameters()` with the parameter set to `null`.

### User Properties

1. Set user properties to describe segments of your user base using the `setUserProperty()` method.
   ```dart
   await FirebaseAnalytics.instance
     .setUserProperty(
       name: 'favorite_food',
       value: favoriteFood,
     );
   ```
2. Create custom definitions for user properties in the Analytics console before using them in your app.
3. Use user properties for creating custom definitions, applying comparisons in reports, or as audience evaluation criteria.
4. Keep user property names and values concise and relevant to your analytics needs.

### Best Practices

1. Analytics automatically logs some events and user properties; you don't need to add code to enable them.
2. Request necessary permissions before collecting user data, especially on platforms with strict privacy controls.
3. Avoid logging sensitive or personally identifiable information in events or user properties.
4. Use consistent naming conventions for custom events and parameters to make analysis easier.
5. Group related events to track user flows and conversion funnels effectively.
6. Consider the analytics data you'll need for decision-making before implementing tracking to ensure you collect the right information.
7. Test your analytics implementation to verify events are being logged correctly before deploying to production.
