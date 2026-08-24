# Attribution and licensing

This repository is [MIT licensed](./LICENSE). The skills in it are *derived from* official
documentation that this project does not own, so this file records what the MIT license covers,
what it does not, and under which terms each upstream source was used.

License terms were verified on **2026-08-24**. Upstream terms change — check the source before
relying on this summary. This is a good-faith record, not legal advice.

## What the MIT license covers

The original expression in this repository:

- the selection of topics and the decision to split them into individual skills
- the trigger `description` line that makes each skill load at the right moment
- the wording, condensation, ordering, and structure of every `SKILL.md` and reference file
- the scripts, the combined rule sets, and the repository's organization

Facts, ideas, APIs, and instructions are not copyrightable. "Prefer `const` constructors" or
"register a fallback value before stubbing" is a fact about a tool, not protected expression, and
restating one in new words creates a new work.

## What it does not cover

The MIT license grants rights to this repository's own content. It does not, and cannot, relicense
third-party text. Where upstream wording is quoted, that wording stays under its original license
and is attributed at the point of use.

## Source licenses

| Source | Prose | Code samples | Skills |
|---|---|---|---|
| [Flutter](https://docs.flutter.dev) and [Dart](https://dart.dev) docs | CC BY 4.0 | 3-Clause BSD | `architecture-feature-first`, `dart-3-updates`, `effective-dart`, `flutter-app-architecture`, `flutter-best-practices`, `flutter-errors`, `flutter-pre-caching`, `flutter-use-column-row-first`, `testing` |
| [Firebase](https://firebase.google.com/docs) and Google developer docs | CC BY 4.0 | Apache 2.0 | all `firebase-*` skills, `flutterfire-configure`, `generate-images-with-firebase-ai` |
| [GitHub Docs](https://github.com/github/docs) | CC BY 4.0 | — | `code-review` |
| [FlutterFire](https://firebase.flutter.dev) | 3-Clause BSD | 3-Clause BSD | `flutterfire-configure` |
| Package repositories and READMEs — [bloc](https://github.com/felangel/bloc), [riverpod](https://github.com/rrousselGit/riverpod), [provider](https://github.com/rrousselGit/provider), [mocktail](https://github.com/felangel/mocktail) | MIT | MIT | `bloc`, `riverpod`, `provider`, `mocktail`, `flutter-change-notifier` |
| [mockito](https://github.com/dart-lang/mockito), [Patrol](https://patrol.leancode.co) | Apache 2.0 | Apache 2.0 | `mockito`, `patrol-e2e-testing` |
| [Genkit](https://pub.dev/packages/genkit) | Apache 2.0 | Apache 2.0 | `developing-genkit-dart` |
| [GOV.UK](https://www.gov.uk) service guidance | Open Government Licence v3.0 | — | `inclusive-design` |
| [MDN Web Docs](https://developer.mozilla.org) | **CC BY-SA 2.5 or later** | CC0 | `accessibility`, `flutter-pre-caching` |
| [W3C](https://www.w3.org) — WCAG, WAI | **W3C Document License** | — | `accessibility`, `inclusive-design` |

CC BY 4.0 has no share-alike clause, so adapted material may be redistributed under other terms —
including MIT — as long as attribution is given, the license is identified, and changes are
indicated. Every skill built on these sources links the specific page it came from, and all of them
are rewritten rather than reproduced.

### Restricted reuse: MDN and W3C

**MDN Web Docs is CC BY-SA**, not CC BY. Share-alike means an adaptation of MDN prose must itself
be licensed CC BY-SA, which is incompatible with MIT. MDN is therefore used only as short
quotations, each in quotation marks with a link to the page, with the surrounding material written
independently. Quotation is not adaptation. Contributors must not paraphrase MDN more closely:
quote it plainly, or state the fact in their own words.

**The W3C Document License does not permit derivative works**, except for the purpose of
implementing a specification. WCAG and WAI material is used as restated fact and short attributed
quotation only, never as adapted text.

## Sources that are not openly licensed

These publish under all-rights-reserved terms. Material from them appears only as independently
restated fact — success criteria, character limits, event names, platform behavior — never as
copied or adapted text:

| Source | Skills |
|---|---|
| Apple App Store Connect and Google Play Console help | `store-listing-assets` |
| [RevenueCat docs](https://www.revenuecat.com/docs/) | `revenuecat-testing` |
| [LeanCode](https://leancode.co) engineering articles | `flutter-best-practices` |
| [Refactoring.Guru](https://refactoring.guru) | `code-review` |
| Microsoft Inclusive Design toolkit, ITU statistics | `inclusive-design` |

## How this repository stays compliant

1. **Every skill links its source.** Contributions must include an official documentation link —
   see the contributing section of the [README](./README.md).
2. **Content is rewritten, not reproduced.** Skills are condensations in this project's own words.
3. **Quotations are marked.** Verbatim upstream wording appears in quotation marks or block quotes
   with a source link next to it.
4. **Changes are indicated.** Every skill is explicitly a restatement and reorganization, and the
   `references/` directories note the page each file draws on.
5. **Raw fetched documentation is not redistributed.** The verbatim upstream copies under
   `references/` at the repository root are working files for diffing against upstream. They are
   excluded from what `scripts/publish.sh` publishes.

## If you redistribute this repository

You receive this project's own content under the MIT license. Keep this file with it: it carries
the attribution that the CC BY 4.0, CC BY-SA, Apache 2.0, and BSD sources require. If you copy a
single skill out of the set, carry that skill's source link with it.

Trademarks — Flutter, Dart, Firebase, and the other product names used here — belong to their
respective owners. This project is not affiliated with, endorsed by, or sponsored by Google, Apple,
Mozilla, the W3C, RevenueCat, or any package author.
