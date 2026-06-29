# Inclusive Design Frameworks

## Accessibility vs. usability vs. inclusion

Source: [Accessibility, Usability, and Inclusion — W3C WAI](https://www.w3.org/WAI/fundamentals/accessibility-usability-inclusion/)

Three overlapping ideas, three different focuses:

- **Accessibility** — focus: **disability**. "Web accessibility means that people with disabilities can equally perceive, understand, navigate, and interact with websites and tools."
- **Usability** — focus: **experience quality**. "Usability is about designing products to be effective, efficient, and satisfying." (Not specific to disability.)
- **Inclusion** — focus: **breadth of diversity**. "Inclusion is about diversity, and ensuring involvement of everyone to the greatest extent possible." It spans far beyond disability: hardware and software, literacy, economic situation, education, geography, culture, age, and language.

They overlap heavily, which is why teams conflate them — but treating inclusion as "just accessibility" loses the context, identity, and economic dimensions, and treating accessibility as "just inclusion" lets concrete disability needs go unmet. Keep both.

## The mismatch model (social model of disability)

Sources: [DevOps Dojo — UX/Accessibility, Microsoft](https://devblogs.microsoft.com/devops/devops-dojo-ux-accessibility/) · [From disabled to super-abled — Microsoft News](https://news.microsoft.com/en-xm/features/disabled-super-abled-help-technology/) · [Inclusive 101 Guidebook — Microsoft](https://inclusive.microsoft.design/articles/inclusive-101-guidebook)

Disability is not a fixed property of a person; it emerges at the point of interaction between a person and a world that wasn't built for them.

> WHO, as cited by Microsoft: "Disability is not just a health problem. It is a complex phenomenon, reflecting the interaction between features of a person's body and features of the society in which he or she lives."

Microsoft compresses this to an equation:

> **"Disability = mismatched human interactions."**

And August de los Reyes draws out the designer's responsibility:

> "The biggest challenge is reframing disability as a mismatch between one's abilities and the environment. In other words, disability is designed."

The practical power of this framing: a mismatch is something *you made* and therefore something *you can unmake*. It moves the work from "accommodating broken people" to "fixing a broken environment," and it generalizes — anything that excludes (language, cost, device, confidence) is a designed mismatch you can remove.

Context for scale: per WHO (as cited by Microsoft), over **1 billion people — about 15% of the world** — live with some form of disability; roughly **70% of disabilities are invisible**; and only about **1 in 10** people who need assistive technology have access to it.

## The three principles

Source: [Inclusive 101 Guidebook — Microsoft](https://inclusive.microsoft.design/articles/inclusive-101-guidebook)

1. **Recognize exclusion.** "Exclusion happens when we solve problems using our own biases." Designers unconsciously build for people like themselves; the first move is to find who that shuts out.
2. **Learn from diversity.** "Human beings are the real experts in adapting to diversity." People living with constraints have already invented workarounds — treat them as co-designers, not test subjects.
3. **Solve for one, extend to many.** Solve deeply for one excluded person by "focusing on what's universally important to all humans," and the solution radiates outward. This is the curb-cut effect:
   - **Closed captions** — built for the Deaf community; now used to watch video in loud airports and silent offices, and to teach children to read.
   - **High-contrast / dark modes** — built for low vision; used by everyone in bright sunlight.
   - Other "designed for one, used by all" examples Microsoft cites: remote controls, automatic door openers, audiobooks, and email.

## The Persona Spectrum

Sources: [Inclusive 101 Guidebook](https://inclusive.microsoft.design/articles/inclusive-101-guidebook) · [Inclusive Activity Cards](https://inclusive.microsoft.design/articles/inclusive-activity-cards)

> "We use the Persona Spectrum to understand related mismatches and motivations across a spectrum of permanent, temporary, and situational scenarios."

Every ability constraint exists in three states, and naming all three both multiplies the affected population and exposes the universal need:

| Ability area | Permanent | Temporary | Situational |
|---|---|---|---|
| **Touch** | amputation / one arm | a broken arm | a new parent holding an infant |
| **See** | blindness | cataracts, eye dilation | driving; bright sunlight |
| **Hear** | deafness | an ear infection | a loud bar; a quiet library |
| **Speak** | non-verbal | laryngitis | a strong accent on a voice UI |

The canonical stat: ~26,000 Americans/year experience permanent upper-extremity loss, but "when we include people with temporary and situational impairments, the number is greater than 20 million." The edge case *is* the mass market once you add time and context.

### Using it in practice (Microsoft Inclusive Activity Cards)

Source: [Inclusive Activity Cards — Microsoft](https://inclusive.microsoft.design/articles/inclusive-activity-cards)

Microsoft's activity cards turn the philosophy into design-process moves across five phases — Get Oriented, Frame, Ideate, Iterate, Optimize. The most reusable activities:

- **Create a Persona Spectrum** — take your riskiest constraint and lay out its permanent/temporary/situational versions before designing.
- **Mismatch to Solution** — name the specific mismatch, then design it away.
- **Context and Capability Match / Situational Adaptation** — check whether the design holds up as the user's context shifts (one-handed, distracted, outdoors, offline).
- **Human Analogy** — borrow how people already solve the problem in the physical world.

The throughline: don't design for a statistical "average user." Pick a real person at the edge, build for them, and extend.
