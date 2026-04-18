---
name: patrol-e2e-testing
description: "Create, maintain, and run end-to-end tests for Flutter apps using Patrol 4.x. Use when writing E2E tests, adding integration test coverage, testing native interactions like permissions or system dialogs, capturing UI bug regressions, or validating cross-platform behavior on Android, iOS, and Web."
---

# Patrol E2E Testing Skill

Design, implement, and run end-to-end (E2E) tests using Patrol 4.x in Flutter projects.

## When to Use

Use this skill when:

* A new screen or user flow needs E2E test coverage.
* A feature interacts with native components (permissions, notifications, system dialogs, deep links).
* A UI bug should be captured as a regression test.
* Cross-platform behavior (Android / iOS / Web) must be validated.
* Setting up Patrol in a new or existing Flutter project.

## Setup

Follow the official Patrol documentation for installation and project initialization:
[https://patrol.leancode.co/documentation#setup](https://patrol.leancode.co/documentation#setup)

Key Patrol conventions:

* Add `patrol` as a dev dependency.
* Place tests in `patrol_test/`.
* Name test files with a `_test.dart` suffix.
* Execute tests with `patrol test`.

## Workflow

Follow these steps when implementing or updating Patrol tests.

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

### 6. Stabilization patterns

Flaky tests undermine confidence. Apply these patterns:

```dart
// AVOID — arbitrary delay
await Future.delayed(Duration(seconds: 3));

// PREFER — explicit wait condition
await $.waitUntilVisible($(#targetWidget));

// For animations, pump until settled
await $.pumpAndSettle();
```

* Never use `Future.delayed` as a synchronization mechanism.
* Use `waitUntilVisible` or `waitUntilExists` to wait for UI state.
* Set `settleTimeout` in `PatrolTesterConfig` for slow CI environments.

### Output requirements

When applied, this skill produces:

1. Patrol test(s) covering the specified feature.
2. Any required widget `Key` additions to production code.
3. Exact `patrol test` command(s) to execute locally.
4. Notes explaining stabilization or timing decisions.

**Checkpoint:** Run `patrol test --target <file>` locally to confirm the test passes before committing.

### Quality bar

A valid Patrol test must be:

* **Deterministic** — no arbitrary delays; uses explicit wait conditions.
* **Readable** — clear test name describing the user journey.
* **Minimal but complete** — one assertion chain per journey.
* **Secret-safe** — credentials loaded from `String.fromEnvironment`, never hardcoded.
* **CI-ready** — passes headless with `--web-headless true` or on emulator.