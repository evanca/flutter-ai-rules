---
name: store-listing-assets
description: "Use when writing store copy to character limits (name, subtitle, descriptions, keywords) or preparing listing images (icon, feature graphic, screenshots, preview video)."
---

# Store Listing Assets & Copy

Prepare the metadata, copy, and visual assets that go into an App Store / Google Play **phone** listing, sized and length-fit to each store's exact requirements. This is the *listing production* skill; pair it with a separate review-readiness audit at submission time so the fields are polished and the app itself is ready for review.

Two references hold the authoritative specs; consult them for exact numbers rather than reciting from memory (they drift):
- `references/mobile_listing_checklist.md` — the actionable checklist (shared prep → per-store required → recommended → final check)
- `references/spec_reference.md` — the full spec tables, minimal valid examples, store-specific traps, and known gaps to verify live

**Default scope is phone-only.** Skip tablet, iPad, desktop, Chromebook, TV, watch, Mac, and visionOS assets unless the user says the app supports them — and if they do, note that those are separate asset families outside these specs.

## How to use this skill

1. **Gather the inputs once** (shared prep): final app name, what the app does in one sentence, primary category, whether it has ads, whether it collects/shares/tracks data, privacy policy URL, support contact, and launch languages. These feed both stores.
2. **Confirm which store(s)** the user is targeting — the required set differs enough that doing both blindly wastes effort.
3. **Produce copy AND/OR assets** per the requests below, always checking generated text against the live character/byte limits and generated images against the exact pixel/format specs.

## Writing store copy (fit to limits)

Character limits are hard constraints — always count and show the count. Key limits (full set in the references):

| Field | Google Play | Apple |
|---|---|---|
| App name | 30 chars | 2–30 chars |
| Subtitle | — (no field) | 30 chars |
| Short description | 80 chars | — (use Promotional Text, 170) |
| Full description | 4,000 chars | 4,000 chars, plain text |
| Keywords | — (no field; don't keyword-stuff the description) | ≤100 **bytes**, each keyword >2 chars |

Copywriting rules that keep the listing compliant:
- **Lead with what the app does**, in the first sentence — it's what shows before "more".
- **Apple keywords are bytes, not characters**, comma-separated with no spaces (`notes,checklists,tasks`) to save bytes; non-ASCII eats more than one byte each. Keywords are invisible to users but drive search — don't repeat the app name or category (already indexed).
- **Avoid claim words**: "best", "#1", "free" (unless unconditionally true), rankings, awards, and pricing claims — in text AND baked into images. These trigger rejection and are called out in both stores' policies.
- When both stores are in play, write once and adapt: Play's 80-char short description ≈ Apple's subtitle+promo-text job; Apple needs a keywords line Play doesn't.
- Offer to localize per launch language; note Apple defaults screenshots/shared metadata from the primary language when you add a localization, **except description and keywords** (write those per language).

## Producing visual assets (exact specs)

When generating or resizing images with tooling (ImageMagick, etc.), hit these exactly — wrong format/alpha/dimension is an instant listing error:

**Google Play**
- Play icon: **512×512 px**, 32-bit PNG **with alpha**, ≤1024 KB
- Feature graphic: **1024×500 px**, JPEG or 24-bit PNG, **no alpha** — required to publish
- Phone screenshots: 2–8, JPEG or 24-bit PNG, no alpha, min side 320 px, max 3840 px, longest side ≤ 2× shortest. Recommended: ≥4 at 1080×1920 (portrait) or 1920×1080 (landscape)

**Apple (iPhone)**
- Icon: comes from the **build** (Xcode asset catalog, one 1024×1024 source) — not a separate listing upload
- iPhone screenshots: 1–10, .jpg/.jpeg/.png. Preferred 6.9": **1320×2868**, 1290×2796, or 1260×2736 portrait; if not providing 6.9", 6.5" required: **1284×2778** or 1242×2688. Apple scales down to smaller iPhones
- App preview (optional): ≤3 per size/language, 15–30 s, ≤500 MB, ≤30 fps, H.264/.mp4 (reusable iPhone res 886×1920 / 1920×886)

Screenshot content rules: show **real app UI in use** (not splash/login/mockups), no unsupported devices, no fake UI, no misleading or pricing claims baked in. Verify generated images match the actual submitted build.

## Deliverables

- **Full listing copy set** — name, subtitle/short description, full description, keywords, promotional text — each labeled with its character/byte count against the limit, per targeted store
- **Asset spec sheet / production** — the exact dimensions and formats the user needs, or the generated/resized images themselves (offer to run ImageMagick for resizing/format conversion)
- **Fill-in-the-fields walkthrough** — the checklist from `references/mobile_listing_checklist.md` adapted to the user's app, marking which conditional items apply (account deletion URL, app access instructions, restricted permissions, export compliance)
- **Pre-submission asset audit** — the section 6 final check: assets match the build, no placeholder/staging content, name consistent everywhere, previewed in each language

At submission time, also run a review-readiness audit, and if RevenueCat/paywalls are involved, verify paywall clarity separately.
