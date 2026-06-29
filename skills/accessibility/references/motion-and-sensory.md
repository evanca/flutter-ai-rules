# Motion, Sensory, and Age-Related Needs

## Reduced motion

Animation is not neutral. For people with **vestibular (inner-ear) disorders**, motion like scaling, panning, parallax, and large transitions can trigger genuine nausea, dizziness, and disorientation. For people with **photosensitive epilepsy**, flashing can trigger seizures.

Operating systems expose a user setting for this, and the web surfaces it through the `prefers-reduced-motion` media feature.

Source: [prefers-reduced-motion — MDN](https://developer.mozilla.org/en-US/docs/Web/CSS/@media/prefers-reduced-motion)

> "is used to detect if a user has enabled a setting on their device to minimize the amount of non-essential motion. The setting is used to convey to the browser on the device that the user prefers an interface that removes, reduces, or replaces motion-based animations."

Values:
- `no-preference` — no preference set; evaluates as false.
- `reduce` — the user has asked for reduced motion; `@media (prefers-reduced-motion)` is equivalent to `@media (prefers-reduced-motion: reduce)`.

### The key principle: reduce or replace, don't just delete

Motion often carries meaning (where did this come from, what just changed). When a user prefers reduced motion, **swap the vestibular-triggering motion for a calmer cue** — a cross-fade/opacity change instead of a scale or slide — rather than removing all feedback. The MDN example does exactly this: a pulsing scale animation becomes a gentle dissolve.

```css
.animation {
  animation: pulse 1s linear infinite both;
  background-color: purple;
}

/* Tone down the animation to avoid vestibular motion triggers. */
@media (prefers-reduced-motion: reduce) {
  .animation {
    animation: dissolve 4s linear infinite both;
    background-color: green;
    text-decoration: overline;
  }
}

@keyframes pulse {
  0%   { transform: scale(1); }
  25%  { transform: scale(0.9); }
  50%  { transform: scale(1); }
  75%  { transform: scale(1.1); }
  100% { transform: scale(1); }
}

@keyframes dissolve {
  0%   { opacity: 1; }
  50%  { opacity: 0.3; }
  100% { opacity: 1; }
}
```

What to reduce or replace when `reduce` is set: scaling (`transform: scale()`), panning large objects, parallax scrolling, large page transitions, autoplaying motion, and zoom effects. Subtle opacity/color transitions are generally safe.

On native platforms the same idea applies — read the OS "Reduce Motion" flag (e.g., `MediaQuery.disableAnimations` in Flutter, `UIAccessibility.isReduceMotionEnabled` on iOS, `Settings.Global.ANIMATOR_DURATION_SCALE` on Android) and pick a calmer transition.

### Flashing

Independently of the user's motion preference, never show content that flashes more than about three times per second — it is a seizure risk for photosensitive users.

## Older users: age-related ability change

Source: [Older Users and Web Accessibility — W3C WAI](https://www.w3.org/WAI/older-users/)

Ageing brings gradual changes that overlap directly with established disability access needs, across four areas:

- **Vision** — "reduced contrast sensitivity, color perception, and near-focus, making it difficult to read web pages."
- **Physical / motor** — "reduced dexterity and fine motor control, making it difficult to use a mouse and click small targets."
- **Hearing** — "difficulty hearing higher-pitched sounds and separating sounds," especially with background music.
- **Cognitive** — "reduced short-term memory, difficulty concentrating, and being easily distracted, making it difficult to follow navigation and complete online tasks."

The encouraging consequence:

> "websites, applications, and tools that are accessible to people with disabilities are more accessible to older users as well."

In other words, you don't need a separate "senior mode." Solid contrast, large and well-spaced targets, clear audio, simple navigation, and low memory load — the same things you do for disabled users — cover most age-related needs. W3C notes WCAG addresses most older-user needs already.

> Scope note: this file is about *age-related ability decline*, which is accessibility. The broader treatment of **age as context and identity** — first-time-online confidence, life stage, designing for children — lives in the **inclusive-design** skill, not here.
