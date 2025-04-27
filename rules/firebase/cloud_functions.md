# Firebase Cloud Functions Rules

### Setup and Configuration

1. Install the Cloud Functions plugin using `flutter pub add cloud_functions`.
2. Import the plugin in your Dart code using `import 'package:cloud_functions/cloud_functions.dart';`.
3. Initialize Firebase before using any Cloud Functions features.
4. Access the Cloud Functions instance using `final functions = FirebaseFunctions.instance;`.
5. For region-specific deployments, specify the region when getting the instance.
6. Deploy your callable functions to Firebase before attempting to call them from your Flutter app.
7. Consider implementing App Check to prevent abuse of your Cloud Functions.

### Calling Functions

1. Call a Cloud Function using the `httpsCallable` method followed by the `call` method.
   ```dart
   final result = await FirebaseFunctions.instance
     .httpsCallable('functionName')
     .call(data);
   ```
2. Pass data to functions as a Map, which will be automatically serialized to JSON.
   ```dart
   final result = await FirebaseFunctions.instance
     .httpsCallable('addMessage')
     .call({
       "text": messageText,
       "push": true,
     });
   ```
3. Access the function result data using the `data` property of the returned object.
   ```dart
   final responseData = result.data;
   ```
4. Be aware that the data returned from a function is automatically deserialized from JSON.
5. Use type casting to convert the returned data to the expected type.
   ```dart
   final responseString = result.data as String;
   ```
6. Avoid passing sensitive information like authentication tokens in function parameters, as they are automatically included by the SDK.
7. Keep function names consistent between your client code and server-side implementations.

### Error Handling

1. Use try-catch blocks to handle errors when calling Cloud Functions.
   ```dart
   try {
     final result = await FirebaseFunctions.instance
       .httpsCallable('functionName')
       .call(data);
     // Handle successful result
   } catch (e) {
     if (e is FirebaseFunctionsException) {
       // Handle specific function error
       print('Error code: ${e.code}');
       print('Error message: ${e.message}');
       print('Error details: ${e.details}');
     } else {
       // Handle general error
       print('Error: $e');
     }
   }
   ```
2. Check for `FirebaseFunctionsException` to handle specific function errors.
3. Access error details using the `code`, `message`, and `details` properties of `FirebaseFunctionsException`.
4. Implement proper error handling for network connectivity issues.
5. Handle timeouts appropriately, especially for long-running functions.
6. Provide meaningful error messages to users when function calls fail.
7. Consider implementing retry logic for transient errors.

### Performance Optimization

1. Set appropriate timeouts for function calls based on expected execution time.
   ```dart
   final functions = FirebaseFunctions.instance;
   functions.useFunctionsEmulator('localhost', 5001);
   final callable = functions.httpsCallable(
     'functionName',
     options: HttpsCallableOptions(
       timeout: const Duration(seconds: 30),
     ),
   );
   ```
2. Minimize the amount of data passed to and from functions to reduce latency.
3. Use batch operations when possible to reduce the number of function calls.
4. Consider implementing client-side caching for frequently used function results.
5. Monitor function performance using Firebase Console to identify bottlenecks.
6. Be mindful of cold starts for infrequently used functions.
7. Implement proper loading states in your UI while waiting for function responses.

### Testing and Development

1. Use the Firebase Emulator Suite for local development and testing.
   ```dart
   FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);
   ```
2. Test functions with various input data to ensure robust error handling.
3. Implement unit tests for client-side function calling logic.
4. Use integration tests to verify end-to-end function behavior.
5. Test functions with both valid and invalid inputs to ensure proper validation.
6. Verify that functions handle authentication correctly.
7. Test functions with different user roles and permissions to ensure proper access control.
