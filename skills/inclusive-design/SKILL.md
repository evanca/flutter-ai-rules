---
name: inclusive-design
description: "Use when working on inclusion, i18n/localization, global name/address forms, low-end devices, slow/metered networks, affordability, or first-time/low-confidence users; not WCAG/screen readers (see accessibility)."
---

# Inclusive Design

Inclusive design answers a different question from accessibility:

> **Does this respect the real-world context, identity, language, culture, device, confidence level, and constraints of the person using it?**

Accessibility asks whether someone *can operate* the interface with their abilities and assistive tools. Inclusion asks who gets *left out* by the assumptions baked into the product — the person on a $40 phone over a metered 2G connection, the person whose name doesn't fit your form, the person reading in their third language, the person who has never done this online before and is afraid of getting it wrong. WCAG conformance does not address any of that. This skill does.

Per W3C, accessibility, usability, and inclusion overlap but each has a distinct focus: accessibility targets **disability**, usability targets the **quality of the experience** (effective, efficient, satisfying), and inclusion targets the **full breadth of human diversity** — hardware and software, literacy, economic situation, education, geography, culture, age, and language.

## When to use

Use this skill when the work is about *who you might be excluding and why* — not about a specific assistive-tech bug. Triggers: reviewing a design "through an inclusive lens," building personas, internationalization/localization, designing name/address/profile forms for a global audience, supporting low-end devices or poor connectivity, lowering cost/data barriers, onboarding nervous or first-time users, reducing stress and cognitive load, or any "are we leaving anyone out?" conversation.

**When *not* to use it:** if the task is screen-reader support, keyboard navigation, focus order, color contrast, alt text, ARIA, captions, or passing WCAG — that's the **accessibility** skill. The two are partners; pick by focus.

## The core mental model

### 1. Disability — and exclusion in general — is a *mismatch*, not a trait

The social model reframes disability as a mismatch between a person and their environment, product, or society — not a deficiency in the person. As August de los Reyes put it:

> "The biggest challenge is reframing disability as a mismatch between one's abilities and the environment. In other words, **disability is designed**."

The empowering corollary: if mismatches are designed, they can be *un*-designed. The same logic extends past disability to every exclusion in this skill — a form that rejects a valid name, an app that needs more bandwidth than a user can afford, copy only a fluent reader can parse. Each is a designed mismatch you can remove. Microsoft states it as: *disability = mismatched human interactions.*

### 2. Microsoft's three principles of inclusive design

- **Recognize exclusion.** "Exclusion happens when we solve problems using our own biases." Start by finding who your current solution shuts out.
- **Learn from diversity.** "Human beings are the real experts in adapting to diversity." The people at the edges are the source of insight, not an afterthought.
- **Solve for one, extend to many.** Design a great solution for one excluded person by "focusing on what's universally important to all humans" — and it tends to help everyone. Captions (built for Deaf users) help in loud airports and teach kids to read; high-contrast modes (built for low vision) help everyone in bright sun. Build for one, benefit many.

### 3. The Persona Spectrum

A constraint is rarely permanent-only. Microsoft's Persona Spectrum maps each limitation across **permanent, temporary, and situational** states — which both grows the affected population enormously and reveals the universal need:

| Ability | Permanent | Temporary | Situational |
|---|---|---|---|
| Touch (one arm) | amputation | broken arm | a new parent holding a baby |
| See | blindness | cataracts / eye dilation | driving; bright sunlight |
| Hear | deafness | ear infection | a loud bar; a quiet library |
| Speak | non-verbal | laryngitis | a heavy accent on voice UI |

> "We use the Persona Spectrum to understand related mismatches and motivations across a spectrum of permanent, temporary, and situational scenarios."

The scaling is the point: ~26,000 Americans a year experience permanent upper-limb loss, but counting temporary and situational impairments the number is **more than 20 million**. Designing for the edge serves the middle.

## How to run an inclusion review

Go dimension by dimension and ask "who does this assume, and who does that leave out?" Each dimension has a reference file with the depth.

1. **Language & culture** — Is content translatable and localizable? Do name, address, date, number, and currency formats assume one culture? Do forms assume everyone has a first + last name? → [references/language-and-culture.md](references/language-and-culture.md)
2. **Device, network & economics** — Does it work on a cheap, old, small-screen phone over a slow, metered connection? Does it assume always-on connectivity, the latest hardware, or that data is free? Is there a low-bandwidth or offline path? → [references/digital-and-economic-inclusion.md](references/digital-and-economic-inclusion.md)
3. **Confidence, stress & cognitive load** — Does it respect that the user may be anxious, distracted, new, or low on mental energy? Does it give control, celebrate progress, and forgive mistakes rather than blame the user? → [references/cognitive-load-and-wellbeing.md](references/cognitive-load-and-wellbeing.md)
4. **Identity & life stage** — Does it represent diverse people respectfully (names, genders, family structures, skin tones, examples)? Does it work for the very young, the very old, and the first-time-online?
5. **Recognize your own exclusion** — Whose biases shaped the defaults? Who wasn't in the room? Build a Persona Spectrum for the riskiest constraint and design for its edge.

For the philosophy, principles, Persona Spectrum activities, and the accessibility/usability/inclusion distinction in full, see [references/frameworks.md](references/frameworks.md).

## A note on doing this well

Inclusion is not a checklist you complete; it's a habit of noticing your assumptions. The fastest way to find exclusion is to stop designing for an "average user" (who doesn't exist) and instead pick a specific person at the edge — someone unlike you in language, income, device, or confidence — and walk your flow as them. The friction they hit is the design's, not theirs.

## References

- [references/frameworks.md](references/frameworks.md) — the 3 principles, Persona Spectrum, the mismatch model, and the accessibility vs. usability vs. inclusion distinction, with sources.
- [references/language-and-culture.md](references/language-and-culture.md) — internationalization vs. localization, and inclusive name/form handling for a global audience.
- [references/digital-and-economic-inclusion.md](references/digital-and-economic-inclusion.md) — device, connectivity, affordability, skills, and confidence barriers (UK Gov + ITU framing).
- [references/cognitive-load-and-wellbeing.md](references/cognitive-load-and-wellbeing.md) — motivation, stress, focus, memory, notifications, and agency (Microsoft cognition + mental health).

Primary sources:

- [Inclusive 101 Guidebook — Microsoft](https://inclusive.microsoft.design/articles/inclusive-101-guidebook)
- [Accessibility, Usability, and Inclusion — W3C WAI](https://www.w3.org/WAI/fundamentals/accessibility-usability-inclusion/)
- [Digital Inclusion — ITU](https://www.itu.int/en/ITU-D/Digital-Inclusion/Pages/about.aspx)
