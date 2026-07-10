# RevenueCat testing use cases

Source: revenuecat.com/docs/guides/testing-guide/use-cases and /docs/test-and-launch/debugging (compiled 2026-07). Every use case below lists the method and the **verifiable signal** — the dashboard event or CustomerInfo/log state that proves it worked. Cross-reference all events in the RevenueCat customer history; some (like iOS refunds) can take up to 24 hours.

## Prerequisites (do first, every platform)

- **Enable debug logs before `configure()`**: iOS/macOS `Purchases.logLevel = .debug`; Android `Purchases.setLogLevel(LogLevel.DEBUG)`; RN/Flutter set log level before configure. (iOS: disabling `OS_ACTIVITY_MODE` in the Xcode scheme blocks debug logs from printing.)
- **Watch logs for "Invalid Product Identifiers"** and any error-level messages *before* attempting sandbox purchases — fix product config first.
- **Debug overlay** to preview offerings/packages/products and run test purchases: iOS 4.22.0+ `.debugRevenueCatOverlay()` (SwiftUI) / `presentDebugRevenueCatOverlay()` (UIKit); Android 6.9.2+ `DebugRevenueCatBottomSheet`.
- **Sandbox environment** is required for all tests except iOS refund verification. Use **multiple sandbox test IDs** for account-switching/transfer scenarios.

## 1. Subscription lifecycle

| Use case | Method | Verify |
|---|---|---|
| Purchase flow | Buy in sandbox | Purchase event with correct App User ID on overview |
| Free trials & intro offers | Fresh sandbox user, buy product with offer attached | Purchase event `period_type` = `TRIAL` or `INTRO` |
| Cancellation | Cancel via device settings, or RevenueCat API (Google Play) | `CANCELLATION` event in customer history immediately |
| Expiration | Let billing cycle end | `EXPIRATION` event at expiry timestamp; entitlement/content access revoked |
| Upgrades/downgrades | Change tier within a subscription group | `PRODUCT_CHANGE` event with correct old + new product IDs |
| Refund handling | Google Play: refund from dashboard. **iOS: sandbox refunds not possible** — App Store directs users to Apple support | `CANCELLATION` event, reason `CUSTOMER_SUPPORT`, appears after ~24h; app degrades gracefully |
| Google offers | SDK auto-applies longest free trial / cheapest intro; manual via `subscriptionOptions` | Correct offer applies at purchase; offers tagged `rc-ignore-offer` are NOT auto-selected |

**Platform notes:** Google Play uses `PRORATION` modes for tier changes; iOS follows Apple's upgrade/downgrade timing.

## 2. Configuration

| Use case | Method | Verify |
|---|---|---|
| Anonymous App User ID | `configure()` with no appUserID | Log `Initial App User ID - $RCAnonymousID:[hash]`; CustomerInfo shows anonymous ID |
| Identified App User ID | `configure(appUserID:)` | Log shows custom ID; CustomerInfo shows it as Original App User ID |
| Display offering flow | Fetch current offerings / by placement / custom by ID | Offerings render; packages grouped by type (monthly, annual, …) |
| Login/logout flow | configure → logIn(custom ID) → logOut → logIn(different ID) | CustomerInfo updates correctly; **no unintended data merging** between accounts |

## 3. Restoring flow (the account-switching matrix — the trickiest area)

| Use case | Precondition | Verify |
|---|---|---|
| `syncPurchases()` across accounts | ID#1 has active sub, ID#2 has none | ID#2 gains access; `TRANSFER` event in history |
| Restore purchases (transfer to new ID) | Access paid on ID#1 → log out → new ID → tap Restore | New ID gets access without repurchase; `TRANSFER` event |
| Restore with no active subs / conflict | ID#1 has sub, ID#2 none, ID#3 same sub | ID#2 gets transfer; ID#3 gets an error and **no** `TRANSFER` |
| Keep with original ID (transfer disabled) | Log in with a different ID from the same store account | Error message; **no** `TRANSFER`; purchases stay on original ID |
| Share between IDs (legacy aliasing) | — | Both IDs merge in history; ID#2 gains ID#1's entitlements |

## 4. Paywalls

| Use case | Setup | Verify |
|---|---|---|
| Display & purchase | Show paywall | Correct packages render fullscreen; purchase event in history |
| Localization | Set device/store account to target country | Correct language + localized pricing |
| Intro offer eligibility display | Fresh (eligible) user | Paywall shows intro offer; `INITIAL_PURCHASE` event includes offer details |

## 5. RevenueCat Billing (Web)

| Use case | Verify |
|---|---|
| Purchase flow | `INITIAL_PURCHASE` event on completion; entitlements grant access immediately |
| Free trials | Trial applies per configured criteria; auto-converts to paid unless canceled |
| Expiration | `EXPIRATION` event; access to protected content lost |

## Event cheat-sheet (what proves what)

- `INITIAL_PURCHASE` — first purchase / web purchase / paywall intro purchase
- `RENEWAL` — successful renewal
- `PRODUCT_CHANGE` — upgrade/downgrade (carries old + new product IDs)
- `CANCELLATION` — user canceled (reason `CUSTOMER_SUPPORT` = refund)
- `EXPIRATION` — entitlement lapsed at cycle end
- `TRANSFER` — purchases moved to another App User ID (the restore/sync signal)
- `period_type` on a purchase — `TRIAL` / `INTRO` / `NORMAL`
