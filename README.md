# Flutter Rules for Windsurf, Cursor, and Other AI-Powered IDEs

## 🚀 Introduction

This repository provides a comprehensive, (almost) non-opinionated collection of Flutter-related rules tailored for use with **Windsurf**, **Cursor**, and other AI-powered IDEs. These rules are designed to improve your development workflow, ensure consistency, and help you get the most out of your AI coding assistant.

## 📁 Repository Structure

- **`rules/`**  
  Contains individual rule files, each focused on a specific topic or tool (e.g., `bloc.md`, `effective_dart.md`, etc.).  
  These files are:
    - Based **only** on official documentation from Flutter, Dart, or relevant package websites.
    - Categorized by subject to make them easy to mix, match, and reference.
    - Meant to be refined, adjusted, or extracted based on your project needs.

- **`combined/`**  
  Contains pre-made, curated sets of rules that combine commonly used topics (e.g., Flutter + Riverpod + Mockito).  
  These files:
    - Are kept under **6,000 characters** to comply with **Windsurf's** limit.
    - Can be used **as-is** by copying them into your global or local rules configuration.

## ✅ How To Use

### Option 1: Use Pre-Made Combined Rules

If you want a quick setup:

1. Browse the [`combined/`](./combined) folder.
2. Copy a file that suits your project.
3. Paste it into your IDE's global or local rules config.
4. You're ready to go.

### Option 2: Use Individual Rule Files

If you prefer more control:

1. Browse the [`rules/`](./rules) folder.
2. Pick files relevant to your project (e.g., `riverpod.md`, `bloc.md`, etc.).
3. You can:
    - **Include** them directly in your IDE setup.
    - **Reference** them in prompts to add context.
    - **Extract** only the parts that are useful for your context.
    - **Include** them partially or fully in a PRD (Product Requirements Document).

Everything is modular — use what works best for you.

## 📏 No Opinions, Just Documentation

All rules are sourced from official documentation — no personal preferences or subjective interpretations. That’s intentional. You’re free to alter them to your taste, but this repo keeps things objective by sticking to the source.

Note: This might sometimes lead to contradictory rules (e.g., if one package suggests one folder architecture and another recommends a different one).

## 📌 Use Cases

- Set up global rules for a Flutter project in your IDE.
- Configure project-specific constraints for popular state management packages.
- Provide clear expectations in a PDR when working with a team.
- Extract only what you need to avoid rule clutter.

## 🛠️ Contributing

Contributions are welcome! If you'd like to suggest a new rule or improve an existing one, here’s how you can help:

1. Fork this repository.
2. Add or modify rules in the appropriate folder.
3. Submit a pull request with a clear explanation of your changes.  
   **Make sure to include an official documentation link** for any rule set you’re adding or modifying to keep everything objective and reliable.

## 📚 References

Here are the official sources that have been used to build these rules:

### Flutter
- [Flutter App Architecture](https://docs.flutter.dev/app-architecture) - Official Flutter architecture guidelines
- [Flutter Common Errors](https://docs.flutter.dev/testing/common-errors) - Common errors documentation
- [Flutter ChangeNotifier State Management](https://docs.flutter.dev/data-and-backend/state-mgmt/simple) - Simple state management with ChangeNotifier

### Dart
- [Effective Dart](https://dart.dev/effective-dart) - Official Dart style guidelines
- [Dart 3 Updates](https://dart.dev/language) - Documentation on Dart 3 features including:
  - [Records](https://dart.dev/language/records)
  - [Patterns](https://dart.dev/language/patterns)
  - [Pattern Types](https://dart.dev/language/pattern-types)
  - [Branches](https://dart.dev/language/branches)

### State Management
- [Bloc Library](https://bloclibrary.dev/) - Official Bloc library documentation
- [Provider](https://pub.dev/packages/provider) - Official Provider package documentation
- [Riverpod](https://riverpod.dev/) - Official Riverpod documentation

### Testing
- [Mockito](https://pub.dev/packages/mockito) - Official Mockito for Dart documentation
- [Mocktail](https://pub.dev/packages/mocktail) - Official Mocktail documentation
