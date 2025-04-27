# Firebase In-App Messaging Rules

### Setup and Configuration

1. Install the Firebase In-App Messaging plugin using `flutter pub add firebase_in_app_messaging`.
2. Import the plugin in your Dart code using `import 'package:firebase_in_app_messaging/firebase_in_app_messaging.dart';`.
3. Ensure Firebase is properly initialized before using any Firebase In-App Messaging features.
4. Be aware that Firebase In-App Messaging only retrieves messages from the server once per day by default to conserve power.
5. For testing on Android, look for the Installation ID in console logs with the format `I/FIAM.Headless: Starting InAppMessaging runtime with Installation ID YOUR_INSTALLATION_ID`.
6. For testing on iOS, enable debug mode by adding the `-FIRDebugEnabled` runtime argument in Xcode's scheme settings.

### Message Triggering and Display

1. Use Google Analytics for Firebase events to trigger in-app messages without additional integration.
2. Trigger in-app messages programmatically using the `triggerEvent` method when needed.
   ```dart
   FirebaseInAppMessaging.instance.triggerEvent("eventName");
   ```
3. Temporarily suppress message displays during critical app flows (like payment processing) using `setMessagesSuppressed`.
   ```dart
   FirebaseInAppMessaging.instance.setMessagesSuppressed(true);
   ```
4. Re-enable message display by calling `setMessagesSuppressed(false)` when appropriate.
5. Be aware that message suppression is automatically turned off on app restart.
6. Understand that suppressed messages are ignored and their trigger conditions must be met again after suppression is turned off.
7. For platform-specific message interaction handling, use the native iOS and Android APIs as Flutter doesn't provide direct access to these callbacks.

### User Privacy and Data Collection

1. By default, Firebase In-App Messaging automatically delivers messages to all targeted app users.
2. To implement opt-in data collection for privacy-conscious users, disable automatic initialization first.
3. For iOS, disable automatic data collection by adding `FirebaseInAppMessagingAutomaticDataCollectionEnabled` with value `NO` to your `Info.plist` file.
4. For Android, disable automatic data collection by adding the following to your `AndroidManifest.xml`:
   ```xml
   <meta-data
       android:name="firebase_inapp_messaging_auto_data_collection_enabled"
       android:value="false" />
   ```
5. Manually enable data collection for users who opt in:
   ```dart
   FirebaseInAppMessaging.instance.setAutomaticDataCollectionEnabled(true);
   ```
6. Be aware that manually set data collection preferences persist through app restarts, overriding the values in configuration files.

### Testing and Debugging

1. Use the Firebase console's test device feature to send test messages on demand to specific devices.
2. Always test in-app messages on actual devices to ensure proper rendering and behavior.
3. When testing, use the Firebase Installation ID (FID) to target specific test devices.
4. Create test campaigns in the Firebase console by selecting "Test on your Device" and entering your app's Firebase Installation ID.
5. For iOS testing, check the Xcode console logs for the line containing `[Firebase/InAppMessaging][I-IAM180017]` to find your Installation ID.
6. For Android testing, filter logcat output for "FIAM.Headless" to locate your Installation ID.

### Campaign Management

1. Create in-app messaging campaigns through the Firebase console under the Messaging section.
2. Design campaigns with appropriate message types (modal, banner, card, or image-only) based on the content and user experience requirements.
3. Use campaign custom metadata (key-value pairs) to include additional information that can be accessed when users interact with messages.
4. Target messages based on user segments, app version, language, and other Analytics-based conditions.
5. Schedule campaigns based on specific events, user properties, or conversion events.
6. Monitor campaign performance through the Firebase console analytics to measure effectiveness and user engagement.
7. Use A/B testing features to optimize message content and delivery for better user engagement.
