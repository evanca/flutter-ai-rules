---
name: accessibility
description: >-
  Make a UI operable by people with disabilities using assistive tech and varied input
  methods (WCAG POUR, cognitive accessibility, sensory/motion). Use when working on
  accessibility / a11y, WCAG, ARIA, screen readers, keyboard navigation, focus order,
  color contrast, alt text, captions, reduced motion, target sizes, or accessible forms
  and errors. For context, language, culture, device, or affordability, use the
  inclusive-design skill instead.
---

# Accessibility

Accessibility answers one question:

> **Can someone use this with assistive tools, a different input method, or a different ability?**

It is specifically about people with disabilities being able to **perceive, understand, navigate, and interact** with a product on equal terms — whether they use a screen reader, only a keyboard, a switch, voice control, magnification, or captions. This is the *ability* half of designing for everyone. The *context* half — language, culture, device, affordability, confidence — belongs to the sibling **inclusive-design** skill. They overlap but have different focuses; keep them distinct so neither gets diluted.

## When to use

Use this skill when the task involves any of: WCAG conformance, ARIA, semantic markup, screen-reader support, keyboard/focus management, color contrast, text alternatives (alt text, captions, transcripts), accessible forms and error messages, target sizes, timing/timeouts, motion sensitivity, or cognitive accessibility. Also use it whenever someone asks to "make this accessible," run an a11y audit, or check whether a disabled user can complete a task.

**When *not* to use it:** if the real concern is who gets *left out* by context — non-English speakers, people on cheap phones or slow networks, people who can't afford data, first-time or anxious users, or global name/address formats — that is inclusion, not accessibility. Switch to the **inclusive-design** skill.

## The mental model: POUR

WCAG organizes all of accessibility under four principles. Use them as your audit lens — every issue you find maps to one of them.

- **Perceivable** — users can sense the content through *some* channel. Don't rely on one sense alone. (Text alternatives for images, captions/transcripts for audio and video, sufficient color contrast, not using color alone to convey meaning, content that reflows and survives zoom.)
- **Operable** — users can drive the interface with *whatever input they have*. (Everything reachable and usable by keyboard, visible focus, no keyboard traps, adequate target sizes, generous or adjustable time limits, nothing that flashes in a seizure-inducing way.)
- **Understandable** — users can predict and comprehend behavior. (Clear labels, instructions, and error messages; consistent navigation; predictable interactions; readable language.)
- **Robust** — assistive tech can actually parse it. (Valid semantic structure; correct name/role/value on every control; native semantics first, ARIA only to fill gaps.)

A useful test for any element: *if I could not see it, hear it, use a mouse, or read quickly — could I still complete this task?* If the answer is no under any of those, you've found the principle that's failing.

## Who and what you are designing for

Design for the assistive tools and input methods people actually use, not an abstract "disabled user":

- **Screen readers** (VoiceOver, TalkBack, NVDA, JAWS) — need correct semantics, reading order, labels, and announcements of dynamic changes.
- **Keyboard-only and switch users** — need a logical focus order, visible focus, and no mouse-only interactions.
- **Voice control** — needs visible, speakable labels that match the accessible name.
- **Screen magnification and zoom** — needs layouts that reflow without horizontal scrolling or clipping at 200%+.
- **Captions / transcripts users** — Deaf and hard-of-hearing users, *and* anyone in a loud or silent environment.
- **People with cognitive and learning disabilities** — need clear language, low memory load, and forgiving flows (see below).

Note the recurring pattern: most of these help far more people than the group they target — the same insight that drives inclusive design.

## Fast audit checklist

Walk these in order; each line is a concrete thing to check or fix.

1. **Keyboard** — Tab through the whole flow. Is every control reachable and operable? Is focus visible? Is the order logical? Can you get trapped?
2. **Screen reader** — Does every control announce a meaningful name and role? Are images given text alternatives (or marked decorative)? Are dynamic updates (errors, loading, toasts) announced?
3. **Contrast & color** — Does text meet contrast minimums (4.5:1 body, 3:1 large)? Is any meaning carried by color alone (e.g., red = error with no icon/text)?
4. **Structure** — Are headings, lists, landmarks/regions, and labels semantic rather than visual-only? Does reading order match visual order?
5. **Forms & errors** — Is every field labeled (not placeholder-only)? Are errors identified in text, tied to their field, and explained with how to fix?
6. **Targets & timing** — Are tap targets large enough and spaced? Are time limits absent, generous, or adjustable? Is autosave used to prevent data loss?
7. **Media & motion** — Captions/transcripts for audio/video? Does the UI honor reduced-motion preferences? Nothing flashing more than ~3×/second?
8. **Zoom/reflow** — At 200% zoom (or large system font), does content reflow without clipping or horizontal scroll?

## Beyond conformance: cognitive accessibility

WCAG alone does not cover everything people with cognitive and learning disabilities (dyslexia, ADHD, autism, dementia, aphasia, memory or attention differences) need. The W3C COGA guidance is **supplemental, not required for WCAG conformance**, and it is where the highest-leverage improvements for the largest hidden population usually live: clear language, consistent design, single-step instructions, not relying on memory, forgiving error recovery, and minimizing distraction.

Read **[references/cognitive-accessibility.md](references/cognitive-accessibility.md)** for COGA's eight objectives and their concrete design patterns when the task touches readability, complex flows, forms, logins, or "this is confusing/overwhelming."

## Motion, sensory, and age-related needs

Animation and motion can cause real harm (nausea, dizziness, loss of focus) for people with vestibular disorders, and seizures for people with photosensitivity. Honor the user's `prefers-reduced-motion` setting — reduce or replace motion rather than removing all feedback.

Older users are a large group whose age-related changes in vision, dexterity, hearing, and memory overlap directly with disability needs — designing well here helps everyone age into your product. (Treat *age as a context/identity dimension* — first-time confidence, life stage — in the inclusive-design skill; treat *age-related ability change* here.)

Read **[references/motion-and-sensory.md](references/motion-and-sensory.md)** for `prefers-reduced-motion` patterns (with code), photosensitivity limits, and the older-user ability overlap.

## How to verify

Automated checkers (axe, Lighthouse, Accessibility Scanner, etc.) catch maybe a third of issues — necessary but never sufficient. Always add manual checks: navigate the real flow with the keyboard only, then again with a screen reader, then with the OS reduced-motion and large-text settings on. The bug a tool can't catch — a focus order that makes no sense, a label that lies — is usually the one that actually blocks someone.

## References

Load these only when the task calls for the depth:

- [references/cognitive-accessibility.md](references/cognitive-accessibility.md) — W3C COGA: the 8 objectives and their design patterns (beyond WCAG).
- [references/motion-and-sensory.md](references/motion-and-sensory.md) — reduced motion (with CSS example), photosensitivity, older-user ability overlap.

Primary sources:

- [Accessibility, Usability, and Inclusion — W3C WAI](https://www.w3.org/WAI/fundamentals/accessibility-usability-inclusion/)
- [Making Content Usable for People with Cognitive and Learning Disabilities (COGA) — W3C](https://www.w3.org/TR/coga-usable/)
- [Older Users and Web Accessibility — W3C WAI](https://www.w3.org/WAI/older-users/)
- [prefers-reduced-motion — MDN](https://developer.mozilla.org/en-US/docs/Web/CSS/@media/prefers-reduced-motion)
