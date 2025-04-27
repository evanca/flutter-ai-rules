# Firebase Crashlytics Rules

### Setup and Configuration

1. Install the Firebase Crashlytics plugin using `flutter pub add firebase_crashlytics`.
2. Install Firebase Analytics using `flutter pub add firebase_analytics` to enable breadcrumb logs for better crash context.
3. Run `flutterfire configure` to ensure your Flutter app's Firebase configuration is up-to-date and add required Crashlytics Gradle plugin for Android.
4. Import the plugin in your Dart code using `import 'package:firebase_crashlytics/firebase_crashlytics.dart';`.
5. For obfuscated code (using `--split-debug-info` and/or `--obfuscate` flags), ensure proper symbol file uploading for readable stack traces.
6. For iOS platforms with obfuscated code, use Flutter 3.12.0+ and Crashlytics Flutter plugin 3.3.4+ for automatic symbol file generation and uploading.
7. For Android with obfuscated code, use Firebase CLI (v.11.9.0+) to upload Flutter debug symbols before reporting crashes.
   ```bash
   firebase crashlytics:symbols:upload --app=FIREBASE_APP_ID PATH/TO/symbols
   ```

### Error Handling

1. Configure Flutter framework error handling by overriding `FlutterError.onError` with `FirebaseCrashlytics.instance.recordFlutterFatalError`.
   ```dart
   void main() async {
     WidgetsFlutterBinding.ensureInitialized();
     await Firebase.initializeApp();
     
     // Pass all uncaught "fatal" errors from the framework to Crashlytics
     FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
     
     runApp(MyApp());
   }
   ```
2. For non-fatal Flutter errors, use `FirebaseCrashlytics.instance.recordFlutterError` instead.
3. Catch asynchronous errors that aren't handled by the Flutter framework using `PlatformDispatcher.instance.onError`.
   ```dart
   PlatformDispatcher.instance.onError = (error, stack) {
     FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
     return true;
   };
   ```
4. For errors outside of the Flutter context, install an error listener on the current `Isolate`.
   ```dart
   Isolate.current.addErrorListener(RawReceivePort((pair) async {
     final List<dynamic> errorAndStacktrace = pair;
     await FirebaseCrashlytics.instance.recordError(
       errorAndStacktrace.first,
       errorAndStacktrace.last,
       fatal: true,
     );
   }).sendPort);
   ```
5. Report caught exceptions using `recordError` to track non-fatal issues.
   ```dart
   await FirebaseCrashlytics.instance.recordError(
     error,
     stackTrace,
     reason: 'a non-fatal error'
   );
   ```
6. Be aware that Crashlytics only stores the most recent eight recorded non-fatal exceptions, with older ones being lost.
7. Include additional diagnostic information about errors using the `information` parameter.
   ```dart
   await FirebaseCrashlytics.instance.recordError(
     error,
     stackTrace,
     reason: 'a non-fatal error',
     information: ['further diagnostic information about the error', 'version 2.0'],
   );
   ```

### Crash Report Customization

1. Add custom keys to provide specific state information about your app leading up to a crash.
   ```dart
   FirebaseCrashlytics.instance.setCustomKey('str_key', 'hello');
   FirebaseCrashlytics.instance.setCustomKey('bool_key', true);
   FirebaseCrashlytics.instance.setCustomKey('int_key', 1);
   ```
2. Limit custom keys to a maximum of 64 key/value pairs, with each pair up to 1 kB in size.
3. Add custom log messages to provide more context for events leading up to a crash.
   ```dart
   FirebaseCrashlytics.instance.log("User tapped on payment button");
   ```
4. Be aware that Crashlytics limits logs to 64kB and deletes older log entries when a session's logs exceed that limit.
5. Set user identifiers to help diagnose issues for specific users.
   ```dart
   FirebaseCrashlytics.instance.setUserIdentifier("user-123");
   ```
6. Clear user identifiers by setting them to a blank string when needed.
7. Avoid including unique values (like user IDs or timestamps) directly in exception messages; use custom keys instead.

### Performance and Optimization

1. Be aware that Crashlytics processes exceptions on a dedicated background thread to minimize performance impact.
2. For fatal reports, Crashlytics sends them in real-time without requiring app restart.
3. For non-fatal reports, Crashlytics writes them to disk to be sent with the next fatal report or when the app restarts.
4. Crashlytics rate-limits the number of reports sent from a device to reduce network traffic if necessary.
5. Implement proper error handling in critical code paths to avoid unnecessary crashes.
6. Use breadcrumb logs to understand user actions leading up to a crash, which requires Firebase Analytics integration.
7. Consider disabling Crashlytics in debug builds if you want to avoid reporting development crashes.
   ```dart
   // Only enable Crashlytics in non-debug builds
   if (kReleaseMode) {
     await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(true);
   } else {
     await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
   }
   ```

### Testing and Debugging

1. Force a test crash to verify your Crashlytics setup is working correctly.
   ```dart
   FirebaseCrashlytics.instance.crash();
   ```
2. Test both fatal and non-fatal error reporting to ensure proper configuration.
3. Verify that stack traces are properly symbolicated, especially when using code obfuscation.
4. Check that custom keys, logs, and user identifiers are properly associated with crash reports.
5. Test error handling in different app states and scenarios to ensure comprehensive crash reporting.
6. Monitor the Crashlytics dashboard regularly to identify and address emerging issues.
7. Use the Firebase console to set up alerts for new issues or regressions.
