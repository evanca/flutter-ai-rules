---
name: firebase-cloud-functions
description: "Calls Firebase Cloud Functions from Flutter apps. Use when implementing callable functions, passing structured data to server-side logic, handling function errors and timeouts, configuring region-specific deployments, or testing with the Firebase Emulator Suite. Trigger terms: cloud functions, httpsCallable, server-side logic, callable functions, Firebase functions, backend calls."
---

# Firebase Cloud Functions Skill

This skill defines how to correctly call Firebase Cloud Functions from Flutter applications.

## When to Use

Use this skill when:

* Implementing callable Cloud Functions in a Flutter project.
* Passing structured data to server-side functions and processing results.
* Handling errors, timeouts, and retries for function calls.
* Configuring region-specific function deployments.
* Testing Cloud Functions locally with the Firebase Emulator Suite.

---

## 1. Setup and Configuration

```
flutter pub add cloud_functions
```

```dart
import 'package:cloud_functions/cloud_functions.dart';

// After Firebase.initializeApp():
final functions = FirebaseFunctions.instance;
```

- Initialize Firebase before using any Cloud Functions features.
- For region-specific deployments, specify the region:

```dart
final functions = FirebaseFunctions.instanceFor(region: 'europe-west1');
```

- Deploy callable functions to Firebase **before** attempting to call them from the Flutter app.
- Consider implementing **App Check** to prevent abuse of Cloud Functions.

---

## 2. Calling Functions

Use `httpsCallable` to reference a function, then `call` to invoke it:

```dart
final result = await FirebaseFunctions.instance
  .httpsCallable('functionName')
  .call(data);
```

- Pass data as a `Map` — it is automatically serialized to JSON:

```dart
final result = await FirebaseFunctions.instance
  .httpsCallable('addMessage')
  .call({
    "text": messageText,
    "push": true,
  });
```

- Access the result via the `data` property — it is automatically deserialized from JSON:

```dart
final responseData = result.data;
// Cast to expected type if needed:
final message = result.data as Map<String, dynamic>;
final status = message['status'] as String;
```

- **Do not** pass authentication tokens in function parameters — they are automatically included by the SDK.
- Keep function names consistent between client code and server-side implementations.

---

## 3. Error Handling

Always wrap function calls in `try-catch` and check for `FirebaseFunctionsException`:

```dart
try {
  final result = await FirebaseFunctions.instance
    .httpsCallable('functionName')
    .call(data);
  // Handle successful result
} on FirebaseFunctionsException catch (e) {
  switch (e.code) {
    case 'not-found':
      // Function does not exist
      break;
    case 'permission-denied':
      // User lacks permission
      break;
    case 'unavailable':
      // Service temporarily unavailable — retry
      break;
    default:
      debugPrint('Function error [${e.code}]: ${e.message}');
  }
} catch (e) {
  debugPrint('Unexpected error: $e');
}
```

- Handle network connectivity issues and timeouts appropriately.
- Provide meaningful error messages to users when function calls fail.
- Implement retry logic with exponential backoff for transient errors (`unavailable`, `deadline-exceeded`).

---

## 4. Performance Optimization

Set a timeout appropriate to the expected execution time:

```dart
final callable = FirebaseFunctions.instance.httpsCallable(
  'functionName',
  options: HttpsCallableOptions(
    timeout: const Duration(seconds: 30),
  ),
);
```

- Minimize the amount of data passed to and from functions to reduce latency.
- Use batch operations when possible to reduce the number of function calls.
- Consider client-side caching for frequently used function results.
- Account for **cold starts** for infrequently used functions.
- Implement proper loading states in the UI while waiting for function responses.

---

## 5. Testing and Development

Use the Firebase Emulator Suite for local development and testing:

```dart
FirebaseFunctions.instance.useFunctionsEmulator('localhost', 5001);
```

- Test functions with both valid and invalid inputs to ensure proper validation.
- Verify that functions handle authentication correctly.
- Test with different user roles and permissions to ensure proper access control.
- Implement unit tests for client-side function calling logic.

---

## References

- [Cloud Functions for Firebase Flutter documentation](https://firebase.google.com/docs/functions/callable?platform=flutter)
- [Firebase Emulator Suite](https://firebase.google.com/docs/emulator-suite)
