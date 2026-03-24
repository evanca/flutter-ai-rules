---
name: firebase-ai
description: "Integrate Firebase AI Logic into Flutter apps using the Gemini Developer API. Use when setting up the firebase_ai plugin, generating text or chat responses with Gemini models, streaming AI output, implementing multimodal prompts, handling AI service errors, or applying security and privacy considerations for AI features."
---

# Firebase AI Skill

This skill defines how to correctly use Firebase AI Logic in Flutter applications.

## When to Use

Use this skill when:

* Setting up and configuring Firebase AI in a Flutter project.
* Generating text content or chat responses with Gemini models.
* Implementing streaming AI responses for real-time UI updates.
* Sending multimodal prompts (text + images) to Gemini.
* Handling errors, offline scenarios, and rate limits for AI operations.
* Applying security and privacy considerations for AI features.

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
final model =
    FirebaseAI.googleAI().generativeModel(model: 'gemini-2.5-flash');
```

- Ensure the Firebase project is configured for AI services via the Firebase AI Logic page in the Firebase Console.
- Initialize Firebase before using any Firebase AI features.
- Use `FirebaseAI.googleAI()` for the **Gemini Developer API** backend (recommended starting point).
- Implement **App Check** to prevent abuse of Firebase AI endpoints.

**Platform support:**

| Platform | Support |
|---|---|
| iOS | Full |
| Android | Full |
| Web | Full |
| macOS / other Apple | Beta |
| Windows | Not supported |

---

## 2. Generating Content

### Single-turn text generation

```dart
final response = await model.generateContent([
  Content.text('Summarize the benefits of Flutter for mobile development'),
]);
final text = response.text; // The generated summary string
```

### Multi-turn chat

```dart
final chat = model.startChat();
final response = await chat.sendMessage(
  Content.text('What is the difference between StatelessWidget and StatefulWidget?'),
);
print(response.text);

// Follow-up in the same conversation
final followUp = await chat.sendMessage(
  Content.text('When should I use StatefulWidget?'),
);
print(followUp.text);
```

### Streaming responses

Use streaming to display partial results as they arrive:

```dart
final stream = model.generateContentStream([
  Content.text('Write a step-by-step guide to implementing dark mode in Flutter'),
]);

await for (final chunk in stream) {
  // Append chunk.text to the UI progressively
  setState(() => _output += chunk.text ?? '');
}
```

### Multimodal prompts (text + image)

```dart
final imageBytes = await File('photo.jpg').readAsBytes();
final response = await model.generateContent([
  Content.multi([
    TextPart('Describe what you see in this image'),
    InlineDataPart('image/jpeg', imageBytes),
  ]),
]);
```

---

## 3. Error Handling

Wrap AI calls in structured error handling:

```dart
try {
  final response = await model.generateContent([Content.text(prompt)]);
  return response.text;
} on FirebaseAIException catch (e) {
  if (e.message?.contains('quota') ?? false) {
    // Handle rate limiting — show retry message or queue the request
    return 'Service is busy. Please try again shortly.';
  }
  return 'AI service error: ${e.message}';
} catch (e) {
  return 'Unexpected error: $e';
}
```

- Provide meaningful error messages to users when AI operations fail.
- Handle **offline scenarios** with appropriate fallback behavior (e.g., cached responses).
- Implement **exponential backoff** for rate-limited or transient errors.

---

## 4. Security and Privacy

- Follow Firebase Security Rules best practices when using AI services alongside other Firebase products.
- Ensure proper **authentication and authorization** for AI feature access.
- Sanitize user input before sending it to the model to prevent prompt injection.
- Be mindful of **data privacy requirements** when processing user content with AI services.
- Implement appropriate **content filtering and moderation** using safety settings:

```dart
final model = FirebaseAI.googleAI().generativeModel(
  model: 'gemini-2.5-flash',
  safetySettings: [
    SafetySetting(HarmCategory.harassment, HarmBlockThreshold.medium),
    SafetySetting(HarmCategory.dangerousContent, HarmBlockThreshold.high),
  ],
);
```

---

## References

- [Firebase AI Logic Flutter documentation](https://firebase.google.com/docs/ai-logic/get-started?platform=flutter)
