---
name: revenuecat-testing
description: "Use when testing RevenueCat purchases/subscriptions, setting up sandbox testing, debugging a purchase/restore/trial, verifying entitlements or events, or writing an IAP QA plan."
---

# RevenueCat Testing

Help a developer systematically verify their RevenueCat integration works before shipping — turning "I added RevenueCat, does it actually work?" into a concrete, checkable QA plan. The full use-case matrix, methods, platform differences, and the verifiable signal for each case live in `references/use_cases.md`. Read it for exact event names and preconditions; this file is the operating guide.

**The organizing principle:** every RevenueCat behavior has a **verifiable signal** — a specific dashboard event (`INITIAL_PURCHASE`, `TRANSFER`, `EXPIRATION`, `PRODUCT_CHANGE`, `CANCELLATION`), a `period_type` value, or a CustomerInfo/debug-log state. A test isn't "did the app not crash"; it's "did the expected event appear in the customer's history with the right fields." Always tie a test to its signal, or it isn't really testing anything.

## How to use this skill

1. **Get the setup facts**: platform(s) (iOS / Android / cross-platform / web billing), SDK (native, RN, Flutter, etc.), whether they've enabled debug logs and sandbox accounts yet, and what specifically they're trying to verify or why they think something is broken.
2. **Establish prerequisites first** — most "purchases don't work" reports are config problems visible before any purchase:
   - Debug logs on *before* `configure()` (iOS `Purchases.logLevel = .debug`; Android `setLogLevel(LogLevel.DEBUG)`), and check for **"Invalid Product Identifiers"** and error-level logs. Fix those before touching purchase flows.
   - Sandbox environment set up; multiple sandbox test IDs ready if any account-switching is in scope.
   - Point them at the debug overlay (`debugRevenueCatOverlay()` / `DebugRevenueCatBottomSheet`) to preview offerings and run test purchases quickly.
3. **Map their goal to use cases** from the reference and produce the plan (below).

**Reference implementation (especially for Flutter):** RevenueCat ships an official **Purchase Tester** sample app at `github.com/RevenueCat/purchases-flutter/tree/main/revenuecat_examples/purchase_tester`. It's a runnable app exercising the flows this skill tests — dedicated screens for product change (`product_change_testing_screen.dart`), paywalls and paywall-footer, customer center, virtual currency, winback offers, and custom paywall-impression testing — plus an end-to-end integration test at `integration_test/app_test.dart`. Point Flutter users there to (a) run a known-good build to isolate whether a bug is in their code vs. their store/RevenueCat config, and (b) model their own `integration_test` widget tests on `app_test.dart`. For non-Flutter SDKs, RevenueCat has equivalent Purchase Tester apps in each SDK repo.

## The five testing domains

Pull the specific rows from `references/use_cases.md`; here's the shape so you know what to cover:

1. **Subscription lifecycle** — purchase, free trial/intro offer (`period_type` = `TRIAL`/`INTRO`), renewal, upgrade/downgrade (`PRODUCT_CHANGE`), cancellation, expiration, refund. **Platform gotcha to always flag:** iOS sandbox refunds are not possible — the App Store routes users to Apple support and the `CANCELLATION`/`CUSTOMER_SUPPORT` event can take ~24h; Google Play refunds are dashboard-driven.
2. **Configuration** — anonymous vs identified App User IDs (verify via debug log + CustomerInfo), offering display, and login/logout — where the key risk is **unintended data merging** between accounts.
3. **Restoring flow** — the account-switching/transfer matrix. This is the highest-value, most-bug-prone area: `syncPurchases()`, restore-to-new-ID, the three-ID conflict case (transfer succeeds for the empty ID, errors for the one that already owns the sub), and transfer-disabled behavior. The signal throughout is whether a `TRANSFER` event fires (or correctly does *not*).
4. **Paywalls** — display & purchase, localization (device/store-account country → language + localized price), and intro-offer eligibility display for fresh users.
5. **RevenueCat Billing (web)** — purchase, trial auto-conversion, expiration.

## Deliverables

- **QA test plan** — a checklist of the use cases relevant to their app (skip web billing if they're mobile-only, skip trials if they have none), each row as: *action → expected event/signal → where to see it*. This is the primary output; make it copy-pasteable into a QA doc or issue tracker.
- **Debugging a specific failure** — diagnose against the reference: is it a prereq problem (invalid product IDs, logs off, wrong sandbox account)? a wrong-signal expectation (e.g. expecting `TRANSFER` when transfer is disabled)? a platform difference (iOS refund can't be sandbox-tested)? Name the expected event and where it should appear, then work backward from what they actually see.
- **Restore/transfer walkthrough** — when the user is confused about account switching, walk the specific ID configuration and the expected `TRANSFER`-or-error outcome for each ID, since this is the area the docs spend the most care on.
- **Sandbox setup guidance** — the prerequisites section, adapted to their platform and SDK.

Tie every recommendation to the verifiable signal in `references/use_cases.md` — the event cheat-sheet at the bottom of that file maps each event to what it proves.
