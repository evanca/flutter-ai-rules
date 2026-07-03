# Mobile-only Store Listing Checklist

> Scope: **phone only**. Skip tablet, iPad, desktop, Chromebook, TV, watch, Mac, and visionOS assets unless your app supports them.

## 1. Shared prep

- [ ] Confirm app name is final.
- [ ] Prepare privacy policy URL.
- [ ] Prepare support contact or support URL.
- [ ] Decide primary category.
- [ ] Decide target age group / age rating answers.
- [ ] Confirm whether app contains ads.
- [ ] Confirm whether app collects, shares, or tracks user data.
- [ ] Prepare localized copy and assets for each launch language.

## 2. Google Play, required

### Store copy
- [ ] App name, max **30 chars**.
- [ ] Short description, max **80 chars**.
- [ ] Full description, max **4,000 chars**.
- [ ] Category.
- [ ] Support email.
- [ ] Privacy policy URL.

### Visual assets
- [ ] App icon: **512 × 512 px**, PNG, 32-bit with alpha, max **1024 KB**.
- [ ] Feature graphic: **1024 × 500 px**, JPG or 24-bit PNG, no alpha.
- [ ] Phone screenshots: minimum **2**, maximum **8**.
  - [ ] JPG or 24-bit PNG.
  - [ ] No alpha.
  - [ ] Min side: **320 px**.
  - [ ] Max side: **3840 px**.
  - [ ] Longest side no more than **2×** shortest side.

### Console declarations
- [ ] Data Safety form.
- [ ] Content rating questionnaire.
- [ ] Target audience declaration.
- [ ] Contains ads: Yes / No.
- [ ] App access instructions, only if login or gated content exists.
- [ ] Account deletion URL, only if users can create accounts.
- [ ] Restricted permission declarations, only if applicable.

## 3. Google Play, recommended

- [ ] Use at least **4 phone screenshots**.
- [ ] Preferred screenshot size:
  - [ ] Portrait: **1080 × 1920 px**.
  - [ ] Landscape: **1920 × 1080 px**.
- [ ] Add preview video via YouTube URL.
  - [ ] Public or unlisted.
  - [ ] Embeddable.
  - [ ] Not age-restricted.
  - [ ] Ads / monetization disabled.
- [ ] Localize title, descriptions, screenshots, icon, and feature graphic where useful.
- [ ] Avoid "best", "#1", "free", rankings, awards, pricing claims, or misleading badges in title, icon, screenshots, and feature graphic.

## 4. Apple App Store, required

### App record
- [ ] App name, **2 to 30 chars**.
- [ ] Bundle ID.
- [ ] SKU.
- [ ] Primary language.
- [ ] Primary category.
- [ ] Copyright.

### Store copy
- [ ] Subtitle, max **30 chars**.
- [ ] Description, max **4,000 chars**, plain text.
- [ ] Keywords, max **100 bytes**.
- [ ] Support URL.
- [ ] Privacy Policy URL.

### Visual assets
- [ ] App icon included in the build.
  - [ ] Use Xcode asset catalog.
  - [ ] Source icon: **1024 × 1024 px**.
- [ ] iPhone screenshots: minimum **1**, maximum **10**.
  - [ ] JPG, JPEG, or PNG.
  - [ ] Use modern iPhone size set.
  - [ ] Preferred 6.9-inch portrait sizes:
    - [ ] **1320 × 2868 px**, or
    - [ ] **1290 × 2796 px**, or
    - [ ] **1260 × 2736 px**.
  - [ ] Or 6.5-inch portrait sizes if not using 6.9-inch:
    - [ ] **1284 × 2778 px**, or
    - [ ] **1242 × 2688 px**.

### App Store Connect declarations
- [ ] App Privacy answers.
- [ ] Age rating questionnaire.
- [ ] Export compliance answers, especially if app uses encryption.
- [ ] Regulated content / medical declarations, only if applicable.

## 5. Apple App Store, recommended

- [ ] Add Promotional Text, max **170 chars**.
- [ ] Add Marketing URL.
- [ ] Add app preview video, optional.
  - [ ] Up to **3** per device size and language.
  - [ ] **15 to 30 seconds**.
  - [ ] Max **500 MB**.
  - [ ] Up to **30 fps**.
  - [ ] H.264 or ProRes 422 HQ.
  - [ ] `.mov`, `.m4v`, or `.mp4` depending on codec.
- [ ] Localize app name, subtitle, description, keywords, URLs, screenshots, and previews.
- [ ] Keep screenshots focused on real app UI.
- [ ] Do not show unsupported devices, fake UI, misleading claims, or pricing claims that may change.

## 6. Final submission check

- [ ] No tablet, iPad, desktop, Chromebook, Mac, TV, watch, or visionOS assets included unless supported.
- [ ] All screenshots match the submitted app build.
- [ ] All privacy answers match actual SDK and app behavior.
- [ ] Privacy policy is live, public, and not a PDF.
- [ ] Support contact works.
- [ ] App name is consistent across app, store, website, and privacy policy.
- [ ] No placeholder text, test accounts, debug UI, staging URLs, or lorem ipsum.
- [ ] Build uploaded and selected for review.
- [ ] Release notes added where required.
- [ ] Store listing preview checked in each launch language.
