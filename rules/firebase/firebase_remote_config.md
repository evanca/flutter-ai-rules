# Firebase Remote Config Rules

### Setup and Configuration

1. Install the Firebase Remote Config plugin using `flutter pub add firebase_remote_config`.
2. Install Firebase Analytics using `flutter pub add firebase_analytics` as it's required for conditional targeting of app instances.
3. Import the plugin in your Dart code using `import 'package:firebase_remote_config/firebase_remote_config.dart';`.
4. Enable Google Analytics in your Firebase project for user property and audience targeting.
5. Ensure the Remote Config REST API is not disabled, as the SDK depends on it.
6. For macOS, enable Keychain Sharing in Xcode.
7. Get a Remote Config instance using `final remoteConfig = FirebaseRemoteConfig.instance;`.
8. Configure Remote Config settings, including fetch timeout and minimum fetch interval.
   ```dart
   await remoteConfig.setConfigSettings(RemoteConfigSettings(
     fetchTimeout: const Duration(minutes: 1),
     minimumFetchInterval: const Duration(hours: 1),
   ));
   ```

### Parameter Management

1. Set in-app default parameter values to ensure your app behaves as intended before connecting to the Remote Config backend.
   ```dart
   await remoteConfig.setDefaults(const {
     "example_param_1": 42,
     "example_param_2": 3.14159,
     "example_param_3": true,
     "example_param_4": "Hello, world!",
   });
   ```
2. Never store confidential data in Remote Config parameter keys or values, as they can be accessed by end users.
3. Use type-specific getter methods to retrieve parameter values: `getBool()`, `getDouble()`, `getInt()`, and `getString()`.
4. Define parameters with the same names in the Firebase console as those defined in your app.
5. Set both default values and conditional values in the Firebase console based on your targeting needs.
6. Use descriptive parameter names that reflect their purpose in the application.
7. Group related parameters with common prefixes for better organization (e.g., `login_timeout`, `login_attempts_max`).

### Fetching and Activating

1. Call `fetch()` to retrieve parameter values from the Remote Config backend.
2. Call `activate()` to make fetched parameter values available to your app.
3. Use `fetchAndActivate()` to fetch and make values available in a single call.
   ```dart
   await remoteConfig.fetchAndActivate();
   ```
4. Activate fetched values at appropriate times to ensure a smooth user experience, such as when the app starts.
5. Check the fetch status using `remoteConfig.lastFetchStatus` to determine if the fetch was successful, failed, or throttled.
6. Handle fetch failures gracefully by falling back to default values.
7. Implement error handling for network connectivity issues during fetch operations.

### Real-time Updates

1. Use real-time Remote Config to listen for updates from the backend (not available for Web).
   ```dart
   remoteConfig.onConfigUpdated.listen((event) async {
     await remoteConfig.activate();
     // Use the new config values here
   });
   ```
2. Implement proper state management to update your UI when new configuration values are activated.
3. Consider the impact of real-time updates on app behavior and ensure they don't disrupt the user experience.
4. Test real-time updates thoroughly to ensure they work as expected across different network conditions.

### Throttling and Performance

1. Be aware that fetch calls will be throttled if an app fetches too frequently.
2. The default minimum fetch interval is 12 hours in production.
3. For development, set a lower minimum fetch interval to facilitate rapid iteration.
   ```dart
   await remoteConfig.setConfigSettings(RemoteConfigSettings(
     fetchTimeout: const Duration(minutes: 1),
     minimumFetchInterval: const Duration(minutes: 5),
   ));
   ```
4. Use development settings only in debug builds, not in production.
5. Be mindful of service-side quota limits when setting fetch intervals, especially with a large user base.
6. Cache fetched values locally to reduce network requests and improve performance.

### Testing and Debugging

1. Use conditional values in the Firebase console to test different configurations without deploying new app versions.
2. Implement A/B testing by creating different parameter values for different user segments.
3. Log parameter values and fetch status for debugging purposes.
4. Test your app with both default and remote values to ensure it behaves correctly in all scenarios.
5. Verify that your app gracefully handles configuration changes during runtime.
6. Test offline behavior to ensure your app works properly when Remote Config cannot fetch new values.
