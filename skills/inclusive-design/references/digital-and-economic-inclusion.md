# Digital & Economic Inclusion

This dimension is about the people your product never reaches because of *what they can afford, what device they hold, and how connected and confident they are* — not their abilities. It's the most commonly forgotten axis of inclusion because design and dev teams almost always work on fast hardware over fast, free networks.

## What digital inclusion means

Source: [Digital Inclusion Action Plan: First Steps — UK Government](https://www.gov.uk/government/publications/digital-inclusion-action-plan-first-steps/digital-inclusion-action-plan-first-steps)

> Digital inclusion is "ensuring that everyone has the access, skills, support and confidence to participate in and benefit from our modern digital society, whatever their circumstances."

Note that *access* is only one of four parts — skills, support, and confidence matter just as much, and a product can fail people on any of them.

### The barriers, as the UK plan frames them

- **Skills** — digital competencies and access to training. About a quarter of the UK population has the lowest level of digital capability.
- **Data & device poverty** — affordable, reliable connectivity and a suitable device. 37% of offline households cite lack of equipment as a barrier; 6% of UK households have no home internet at all.
- **Accessible services** — usable services *with a non-digital alternative path* for those who can't or won't go online.
- **Confidence & local support** — understanding the benefit of being online, trusting that it's safe, and having in-person help nearby. Lack of interest/motivation (69% of those without home internet) and distrust are real barriers, not just cost.

Who is most affected: low-income households, older people, disabled people, the unemployed, and young people not in education or work. Digital exclusion compounds economic exclusion — among the digitally excluded, unemployment runs far above the national average. The plan frames this as requiring "long term, systemic change," not a one-off feature.

## The global, intersectional view

Source: [Digital Inclusion — ITU](https://www.itu.int/en/ITU-D/Digital-Inclusion/Pages/about.aspx)

> "Digital inclusion begins with ICT accessibility as a foundational requirement and succeeds only through a holistic, intersectional, and intersectoral approach" — toward "ensuring that all people, everywhere, can meaningfully use technology and participate in the digital economy, society, and environment."

Two things to take from ITU:

1. **Accessibility is the foundation, not the whole.** You start with accessibility and build inclusion on top — exactly the relationship between the two skills.
2. **The barriers intersect.** A person is rarely excluded on one axis. ITU emphasizes women and girls, older persons, persons with disabilities, young people and children, and people in rural, remote, and Indigenous communities — and an individual often sits at several of these at once. Design for the intersections.

## What this means in design and engineering

- **Test on a real low-end device over a throttled, metered connection** — not a flagship phone on office Wi-Fi. Measure payload size, time-to-interactive, and data cost per session.
- **Degrade gracefully.** Provide a usable experience without the latest hardware, large downloads, or constant connectivity. Consider offline support, lightweight/low-bandwidth modes, and not auto-loading heavy media.
- **Respect data as money.** Don't silently consume large amounts of data; let users control downloads, autoplay, and sync.
- **Don't assume the latest OS, big screens, or high-end GPUs.** Support older versions and small screens.
- **Lower the confidence barrier.** First-time and low-confidence users need plain-language onboarding, reassurance that they can't break anything, visible help, and trust signals about safety and privacy. (This connects to [cognitive-load-and-wellbeing.md](cognitive-load-and-wellbeing.md).)
- **Keep a non-digital or low-tech path** where the service is essential — a phone number, an in-person option — so going digital-only doesn't strand people.
