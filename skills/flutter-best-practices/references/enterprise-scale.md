# Enterprise Scale

Based on LeanCode's account of building a banking app with 30+ Flutter
developers across 15 teams over two years
(https://leancode.co/blog/building-an-enterprise-application-in-flutter).
Read this when a project involves multiple teams, multiple packages, or
clearly separable business domains. For single-team apps, `feature-structure.md`
is usually enough — but the navigation, localization, and testing sections
here apply earlier than you'd think.

## Contents

1. [Monorepo & package structure](#monorepo--package-structure)
2. [Code ownership](#code-ownership)
3. [Cross-domain communication](#cross-domain-communication)
4. [Navigation](#navigation)
5. [Localization](#localization)
6. [API contracts](#api-contracts)
7. [UI/E2E testing](#uie2e-testing)
8. [Legacy code & deprecation](#legacy-code--deprecation)
9. [Design system](#design-system)

## Monorepo & package structure

Structure follows Conway's Law: *"Any organization that designs a system
will produce a design whose structure is a copy of the organization's
communication structure."* So make packages mirror business-domain squads,
not technical layers — teams then work autonomously without constant
cross-team coordination.

- One monorepo; local packages referenced by **path**, not published.
- Packages are organized **vertically by business domain** (loans, payments,
  onboarding), never horizontally (ui-package, logic-package, data-package).
  A user story cuts through all layers, so a vertical package lets one team
  ship it end to end.
- Inside each package: feature directories containing everything the feature
  needs (cubits, widgets, pages, data classes) — the structure from
  `feature-structure.md`, one level up.
- A main **app package** integrates everything; it belongs to the technical
  squad (below).

**Manage the monorepo with Melos** (`package:melos`):

- concurrent command execution across packages (bootstrap, test, format,
  lint) with package filtering
- automatic versioning and changelog generation
- custom shell scripts as a task runner — one canonical way to restore
  dependencies, run tests, lint; huge for onboarding and CI
- caveat: some Flutter commands take file locks and fail when run in
  parallel — serialize those.

## Code ownership

- Assign ownership at the **team** level, never to individuals — ownership
  must survive people changing roles.
- Owning code means maintaining it and keeping it aligned with evolving
  standards, not just having written it.
- Create an explicit **technical squad** ("artificial" team) that owns what
  no domain team naturally would: cross-cutting concerns, shared/common
  packages, architecture oversight, and the main app package.

## Cross-domain communication

Domains (packages) must not reach into each other's internals. Two sanctioned
channels:

**Synchronous — facades exposing streams.** A domain exposes data as streams
(backed by `BehaviorSubject`, so late subscribers get the current value).
Build automatic retry into the facade; don't surface errors through it when
consumers couldn't react sensibly anyway.

**Asynchronous — events.** To invert a dependency, publish an event: a
self-contained data package describing what occurred ("user completed
onboarding"). Other domains react — typically refreshing data or updating
UI. This is *not* event sourcing; events are notifications, not the source
of truth.

## Navigation

- Split each page into a globally visible **target** and a package-private
  **builder**. A target is like an Android intent: a small class naming a
  page plus the context data it needs.
- All targets live in one central **navigation package** every domain can
  depend on — so any domain can navigate anywhere without depending on the
  destination's package.
- Decouple the navigation API from Flutter so that **business logic
  (cubits/blocs) can navigate** without touching `BuildContext`.

## Localization

Move translation out of the dev workflow into a product workflow with a
Translation Management System (e.g. Phrase) that speaks `.arb`:

- translation history, in-context comments, domain glossaries for
  translator consistency
- multi-stage pipeline: initial terms → translation → native-speaker review
  → acceptance
- export/import synced with version control, tagged per release
- business teams own the content; developers wire it via
  `flutter_localizations` + `intl`.

## API contracts

- Generate Dart clients from **strongly-typed contract definitions** owned by
  the backend team — a single source of truth. (LeanCode uses their own
  contract tooling rather than OpenAPI, judging OpenAPI generators to have
  impedance mismatches; the principle matters more than the tool.)
- Type safety end to end: if the contract says `int`, you cannot send a
  `String` — mismatches die at compile time, not in QA.
- Generated clients are readable and discoverable in normal IDE tooling;
  documentation lives in code instead of an external doc that rots.
- Version the schema with git commits/tags.

## UI/E2E testing

- Use **Patrol** for UI tests — built for Flutter, and it can handle native
  OS surfaces plain integration tests can't: permission dialogs, SMS-code
  retrieval, push notifications.
- Make UI tests **acceptance criteria inside sprint user stories**, owned by
  the whole SCRUM team (devs + QA). Tests written alongside features evolve
  with them; tests written by a separate downstream team rot.
- Run a minimal viable subset on every build; run the full suite
  periodically.

## Legacy code & deprecation

- Mark patterns to abandon with Dart's `@Deprecated(...)` — communicating
  through the analyzer beats communicating through wiki pages.
- Actually track the migration (e.g. in technical-squad syncs); a deprecation
  nobody acts on makes corruption compound.
- Fix "broken windows" proactively: visible tolerated code smells teach
  everyone that smells are tolerated.

## Design system

- A dedicated design squad of developers **and** designers owns the design
  system; developers implement components in continuous collaboration with
  UX/UI.
- Feature teams use design-system components **exclusively** — that's what
  keeps look, behavior, and color usage consistent across 15 teams' output.
