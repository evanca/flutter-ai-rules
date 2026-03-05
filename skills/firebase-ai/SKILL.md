---
name: firebase-ai
description: Integrates Firebase AI Logic into Flutter apps. Use when setting up the firebase_ai plugin, calling Gemini models, handling AI service errors, or applying security and privacy considerations for AI features.
---

# Firebase AI Skill

This skill defines how to correctly use Firebase AI Logic in Flutter applications.

## When to Use

Use this skill when:

* Setting up and configuring Firebase AI in a Flutter project.
* Implementing AI features on supported platforms.
* Handling errors and offline scenarios for AI operations.
* Applying security and privacy considerations for AI features.

Do not use this skill for:

* Firebase Firestore, Auth, Storage, or other Firebase services.
* Non-Firebase AI/ML integrations.

---

## 1. Setup and Configuration

```
flutter pub add firebase_ai
```

```dart
import 'package:firebase_ai/firebase_ai.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// Initialize FirebaseApp
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);

// Initialize the Gemini Developer API backend service
// Create a GenerativeModel instance with a model that supports your use case
final model =
    FirebaseAI.googleAI().generativeModel(model: 'gemini-2.5-flash');
```

- Ensure your Firebase project is properly configured for AI services (via the Firebase AI Logic page in the Firebase Console).
- Initialize Firebase before using any Firebase AI features.
- Use `FirebaseAI.googleAI()` for the **Gemini Developer API** backend (recommended starting point).
- Consider implementing **App Check** to prevent abuse of your Firebase AI endpoints.

**Platform support:**

| Platform | Support |
|---|---|
| iOS | Full |
| Android | Full |
| Web | Full |
| macOS / other Apple | Beta |
| Windows | Not supported |

---

## 2. Best Practices

- Be aware of **rate limits and quotas** when implementing AI features — monitor usage and costs in the Firebase Console.
- Handle AI service errors gracefully with appropriate **fallback mechanisms**.
- Consider **user privacy** when implementing AI features that process user data.
- Test AI functionality across all supported platforms during development.

---

## 3. Error Handling

- Implement proper error handling for AI service failures.
- Provide meaningful error messages to users when AI operations fail.
- Handle **offline scenarios** and implement appropriate fallback behavior.
- Handle **rate limiting and quota exceeded** errors appropriately.

---

## 4. Security

- Follow Firebase Security Rules best practices when using AI services alongside other Firebase products.
- Ensure proper **authentication and authorization** for AI feature access.
- Be mindful of **data privacy requirements** when processing user content with AI services.
- Implement appropriate **content filtering and moderation** as needed.

---

## References

- [Firebase AI Logic Flutter documentation](https://firebase.google.com/docs/ai-logic/get-started?platform=flutter)
