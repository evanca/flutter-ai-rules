# Mobile-Only Store Listing Minimum for Google Play and Apple App Store

Sourced from official Google Play Console/policy help and Apple App Store Connect/Xcode docs. Compiled 2026-07. **Specs change over time — re-verify against the live console at submission, especially the "not stated / verify" items.**

## Executive summary

For a **mobile-only launch**, the minimum submission set differs between the stores:

- **Google Play (phone)**: separate **Play icon**, **feature graphic** (now required to publish), **short description**, **full description**, **≥2 screenshots**, plus **category**, **support email**, **privacy policy**, **Data safety**, **content rating**, **target audience**, and an **ads yes/no** declaration. No keywords field.
- **Apple App Store (iPhone-only)**: **app icon supplied in the build**, **app name**, **subtitle**, **description**, **keywords**, **support URL**, **privacy policy URL**, **copyright**, **category**, **age rating**, **App Privacy answers**, and **≥1 iPhone screenshot**. App previews optional.

Key contrasts: Google requires a feature graphic + 2 screenshots but has no keywords; Apple requires keywords + support URL but only 1 screenshot minimum and the icon comes from the build (not a separate listing upload). Apple has stricter device-family screenshot rules.

## Google Play — required fields and assets (phone only)

| Item | Status | Specs / limits | Notes |
|---|---|---|---|
| App name | Required | 30 chars max, one localized name per language | Public listing title; must be policy-compliant |
| Short description | Required | 80 chars max | Shown first on the detail page; localize when possible |
| Full description | Required | 4,000 chars max | Google warns against repetitive/irrelevant keywords |
| Play icon | Required | 32-bit PNG with alpha, 512×512 px, max 1024 KB | Separate store icon; no misleading badges/ranking text |
| Feature graphic | Required | JPEG or 24-bit PNG, no alpha, 1024×500 px; no standalone max file size stated | Large-format art + preview-video cover; **required to publish** |
| Phone screenshots | Required | Min 2 to publish; JPEG or 24-bit PNG, no alpha; min side 320 px, max 3840 px; longest side ≤ 2× shortest; up to 8 per device type | Google recommends ≥4 at 1080×1920 portrait or 1920×1080 landscape for featuring |
| Preview video | Optional, recommended | 1 YouTube URL (no direct upload); public/unlisted, embeddable, not age-restricted, ads/monetization disabled | Strongly recommended for games |
| Category | Required | Select app/game type + category in Store settings | Tags optional, up to 5 |
| Support email | Required | Email required; website/phone optional | Displayed on listing |
| Privacy policy URL | Required | Active, public, non-geofenced, non-editable, no PDFs | Required for ALL apps, even those collecting no data |
| Data safety form | Required | Console declaration, no char limit | Required for all published apps except internal-testing-only |
| Content rating | Required | IARC questionnaire | Result shown on listing |
| Target audience | Required | Target age group declaration in App content | Children → Families policy applies |
| Contains ads | Required | Yes/No in App content | If yes, "Contains ads" label shown |
| Conditional disclosures | Only if applicable | Restricted-permission declarations, app access instructions for gated areas, News app declaration, account deletion URL if accounts exist | Not universal |

## Apple App Store — required fields and assets (iPhone only)

| Item | Status | Specs / limits | Notes |
|---|---|---|---|
| App name | Required | 2–30 chars, localized | Public product-page name |
| Subtitle | Required (per Apple's required-properties reference) | 30 chars max, localized | Under the app name on the product page |
| Description | Required | 4,000 chars max, plain text, localized | Public product-page copy |
| Keywords | Required | ≤100 bytes total, each keyword >2 chars, localized | Not shown publicly; search metadata |
| Support URL | Required | Full URL incl. protocol, localized | Must lead to real contact info |
| Privacy Policy URL | Required | Full URL | Separate from App Privacy answers |
| App Privacy | Required | Questions/data types in ASC | "No, we do not collect data" path allowed |
| Age rating | Required | Apple questionnaire | Unrated apps cannot publish |
| Category metadata | Required | Primary Category (Secondary also listed as required); Games/Stickers need subcategories | |
| Copyright | Required | Free text, © added automatically | |
| iPhone screenshots | Required | 1–10 in .jpeg/.jpg/.png. Preferred 6.9": 1320×2868, 1290×2796, or 1260×2736 portrait (or landscape). If not providing 6.9", 6.5" required: 1284×2778 or 1242×2688 | Apple scales down to smaller iPhones; no standalone max file size stated |
| App preview | Optional, recommended | Up to 3 per size/language; H.264 or ProRes 422 HQ; .mov/.m4v/.mp4; max 500 MB; 15–30 s; ≤30 fps; reusable iPhone res 886×1920 portrait / 1920×886 landscape | Previews appear before screenshots |
| App icon | Required | Supplied in Xcode build (not a separate ASC upload); iOS auto-generates variations from one 1024×1024 image | Comes from build pipeline; no standalone max file size stated |
| Marketing URL | Optional | Full URL, localizable | |
| Promotional Text | Optional | 170 chars max | Editable without a new version submission |
| Conditional disclosures | Only if applicable | Export-compliance answers (encryption), regulated-medical-device status, regional compliance | Not universal |

## Minimal valid examples (syntactic, not optimized marketing)

### Google Play
| Field | Example |
|---|---|
| App name | `Acorn Notes` |
| Short description | `Fast notes and checklists that sync across your devices.` |
| Full description | `Acorn Notes lets you capture notes, build checklists, and keep everything organized. Create lists, pin important items, and sync your content across your signed-in devices.` |
| Category | `Productivity` |
| Support email | `support@example.com` |
| Privacy policy URL | `https://example.com/privacy` |
| Contains ads | `No` |
| Data safety | `No data collected` |
| Target audience | `Ages 16-17 and 18+` |
| Preview video URL | `https://www.youtube.com/watch?v=EXAMPLE12345` |

### Apple App Store
| Field | Example |
|---|---|
| App name | `Acorn Notes` |
| Subtitle | `Fast lists and notes` |
| Description | `Acorn Notes helps you capture ideas, build checklists, and stay organized. Create notes, group lists, and keep important items easy to find.` |
| Keywords | `notes,checklists,tasks,organizer,sync` |
| Support URL | `https://example.com/support` |
| Privacy Policy URL | `https://example.com/privacy` |
| Primary Category | `Productivity` |
| Secondary Category | `Utilities` |
| Copyright | `2026 Acorn Labs LLC` |
| App Privacy | `No, we do not collect data from this app` |
| Age rating | `No objectionable content; no unrestricted web access` |
| Optional app preview | `886×1920 H.264 .mp4, 20 seconds` |

## Store-specific notes

- **Google Play trap:** the current minimum requires BOTH a 512×512 icon AND a 1024×500 feature graphic to publish, plus ≥2 screenshots. Tablet/Chromebook screenshots have a separate minimum of 4 (out of scope here).
- **Apple trap:** device-family specificity. iPhone and iPad media are separate; Apple scales from the highest required size down. iPhone-only = a single iPhone family set. iPad support adds a separate requirement outside this scope.
- **Localization:** Google — one localized name per language plus localized text/screenshots/graphics; falls back to default or auto-translation. Apple — metadata localizations selected by user language/storefront; localized keywords affect search; adding a localization defaults screenshots and shared properties from the primary language except description and keywords.

## Known gaps ("not stated on cited page" — verify at submission)

- Apple screenshot spec page publishes formats/counts/pixel dimensions but **not a standalone max screenshot file size**; same for the Apple icon source asset.
- Google preview-assets page publishes screenshot formats and pixel constraints but **not a separate screenshot file-size cap** (icon cap is 1024 KB).
- Apple's required-properties reference lists Subtitle and Secondary Category as required but the web table's yes/no markers don't parse cleanly for every row — treat as required, confirm in ASC.
- Google says min 2 screenshots "across different device types" to publish while also allowing up to 8 per device type; for mobile-only, treat 2 phone screenshots as the minimum and sanity-check the live Play Console UI.
