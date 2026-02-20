---
name: patrol-e2e-testing
description: Generates and maintains end-to-end tests for Flutter apps using Patrol. Use when adding E2E coverage for new features, regression tests for UI bugs, or testing native interactions (permissions, system dialogs, deep links)
---

# Patrol E2E Testing Skill

This skill defines how to design, implement, and run end-to-end (E2E) tests using Patrol 4.x in Flutter projects.

It focuses on:

* Covering new feature flows with deterministic UI tests
* Converting reproducible UI bugs into regression tests
* Handling native OS interactions
* Running tests locally and in CI using correct Patrol CLI commands

## When to Use

Use this skill when:

* A new screen or user flow must be covered with E2E tests.
* A feature interacts with native components (permissions, notifications, system dialogs).
* A UI bug should be captured as a regression test.
* Cross-platform behavior (Android / iOS / Web) must be validated.

Do not use this skill for:

* Pure unit tests
* Simple widget tests that do not require full app integration

## Setup

For installation and project initialization, follow the official documentation:

[https://patrol.leancode.co/documentation#setup](https://patrol.leancode.co/documentation#setup)

Key Patrol conventions:

* `patrol` is added as a dev dependency.
* Tests live in `patrol_test/`.
* Test files must end with `_test.dart`.
* Tests are executed with `patrol test`.

## How to use this skill

Follow the steps below when implementing or updating Patrol tests.

### 1. Identify the user journey

Break the feature into:

* **Actions**: taps, scrolls, input, navigation, deep links.
* **Observable outcomes**: visible text, screen changes, enabled buttons, dialogs.

Rules:

* One test per primary (happy-path) journey.
* Separate tests for critical edge cases.
* Avoid combining unrelated flows in a single test.

### 2. Structure the Patrol test

Basic Patrol structure:

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:patrol/patrol.dart';

void main() {
  patrolTest(
    'user can log in successfully',
    ($) async {
      await $.pumpWidgetAndSettle(const MyApp());

      const email = String.fromEnvironment('E2E_EMAIL');
      const password = String.fromEnvironment('E2E_PASSWORD');

      await $(#emailField).enterText(email);
      await $(#passwordField).enterText(password);
      await $(#loginButton).tap();

      await $.waitUntilVisible($(#homeScreenTitle));

      expect($(#homeScreenTitle).text, equals('Welcome'));
    },
  );
}
```

Key concepts:

* Use `patrolTest()` instead of `testWidgets()`.
* `$` is the Patrol tester.
* Use `$(#keyName)` to find widgets by `Key`.
* Use explicit wait conditions (e.g., `waitUntilVisible`).

### 3. Handle native dialogs

For OS-level permission dialogs:

```dart
patrolTest('grants camera permission', ($) async {
  await $.pumpWidgetAndSettle(const MyApp());

  await $(#openCameraButton).tap();

  if (await $.native.isPermissionDialogVisible()) {
    await $.native.grantPermission();
  }

  await $.waitUntilVisible($(#cameraPreview));
});
```

Use native automation only when required by the feature.

### 4. Selector & interaction quick reference

**Finding widgets:**

```dart
$('some text')        // by text
$(TextField)          // by type
$(Icons.arrow_back)   // by icon
```

**Tapping:**

```dart
// Tap a widget containing a specific text label
await $(Container).$('click').tap();

// Tap a container that contains an ElevatedButton
await $(Container).containing(ElevatedButton).tap();

// Tap only the enabled ElevatedButton
await $(ElevatedButton)
    .which<ElevatedButton>(
      (b) => b.enabled,
    )
    .tap();
```

**Entering text:**

```dart
// Enter text into the second TextField on screen
await $(TextField).at(1).enterText('your input');
```

**Scrolling:**

```dart
await $(widget_you_want_to_scroll_to).scrollTo();
```

**Native interactions:**

```dart
// Grant permission while app is in use
await $.native.grantPermissionWhenInUse();

// Open notification shade and tap a notification by text
await $.native.openNotifications();
await $.native.tapOnNotificationBySelector(
  Selector(textContains: 'text'),
);
```

### 5. Running Patrol tests

Run all tests:

```bash
patrol test
```

Run a specific file with live reload (development mode):

```bash
patrol develop -t integration_test/my_test.dart
```

Run a specific file:

```bash
patrol test --target patrol_test/login_test.dart
```

Run on web:

```bash
patrol test --device chrome
```

Headless web (CI):

```bash
patrol test --device chrome --web-headless true
```

Filter by tags:

```bash
patrol test --tags android
```

### Output requirements when this skill is used

When applied, this skill must produce:

1. Patrol test(s) covering the specified feature.
2. Any required widget key additions.
3. Exact `patrol test` command(s) to execute locally.
4. Notes explaining stabilization decisions.

### Quality bar

A valid Patrol test must be:

* Deterministic (no arbitrary delays)
* Readable
* Minimal but complete
* Secret-safe (no hardcoded credentials)
* CI-ready