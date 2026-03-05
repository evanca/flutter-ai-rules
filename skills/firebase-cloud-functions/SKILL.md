---
name: firebase-cloud-functions
description: Calls Firebase Cloud Functions from Flutter apps. Use when setting up callable functions, passing data to functions, handling errors from function calls, optimizing performance, or testing with the Firebase Emulator Suite.
---

# Firebase Cloud Functions Skill

This skill defines how to correctly call Firebase Cloud Functions from Flutter applications.

## When to Use

Use this skill when:

* Setting up and configuring Cloud Functions in a Flutter project.
* Calling callable functions and handling their results.
* Handling errors from function calls.
* Optimizing function call performance.
* Testing with the Firebase Emulator Suite.

Do not use this skill for:

* Writing or deploying server-side Cloud Functions code (Node.js/Python/etc.).
* Firebase Firestore, Auth, Storage, or other Firebase services.

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
- For region-specific deployments, specify the region when getting the instance.
- Deploy callable functions to Firebase **before** attempting to call them from your Flutter app.
- Consider implementing **App Check** to prevent abuse of your Cloud Functions.

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
final responseString = result.data as String;
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
} catch (e) {
  if (e is FirebaseFunctionsException) {
    print('Error code: ${e.code}');
    print('Error message: ${e.message}');
    print('Error details: ${e.details}');
  } else {
    print('Error: $e');
  }
}
```

- Handle network connectivity issues and timeouts appropriately.
- Provide meaningful error messages to users when function calls fail.
- Consider implementing retry logic for transient errors.

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
- Monitor function performance in the Firebase Console to identify bottlenecks.
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
- Use integration tests to verify end-to-end function behavior.

---

## References

- [Cloud Functions for Firebase Flutter documentation](https://firebase.google.com/docs/functions/callable?platform=flutter)
- [Firebase Emulator Suite](https://firebase.google.com/docs/emulator-suite)
