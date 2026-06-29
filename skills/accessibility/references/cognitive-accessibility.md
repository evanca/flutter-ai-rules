# Cognitive Accessibility (W3C COGA)

Source: [Making Content Usable for People with Cognitive and Learning Disabilities](https://www.w3.org/TR/coga-usable/) (W3C)

## Why this is separate from WCAG

COGA is explicit that this guidance sits **on top of** WCAG, not inside it:

> "Following this guidance is not required for conformance to WCAG. However, following this guidance will increase accessibility for people with cognitive and learning disabilities."

This matters because cognitive and learning disabilities are mostly **hidden, hard to diagnose, and very common** — and WCAG's testable success criteria don't capture most of what these users need. A page can pass WCAG and still be unusable for someone with dyslexia, ADHD, dementia, or aphasia. So treat COGA as the place to look when something is *technically conformant but still confusing, overwhelming, or memory-heavy.*

## Who it covers

A person typically has *some* cognitive functions affected while others are fully intact, and may have more than one condition at once. COGA's personas span: mild cognitive impairment / aging, autism, Down syndrome, dementia, dyscalculia, traumatic brain injury, memory loss, aphasia, dyslexia, and ADHD. Neurodiversity here means the different ways a brain can process and interpret information — not a deficit to be "fixed."

## The eight objectives and their patterns

Use the objectives as a checklist; reach for the specific patterns when a flow is failing one of them.

### 1. Help users understand what things are and how to use them
Make the page's purpose clear · use a familiar hierarchy and design · use a consistent visual design · make each step clear · clearly identify controls and their use · make the relationship clear between controls and the content they affect · use icons that help the user (pair icons with text labels).

### 2. Help users find what they need
Make important tasks and features easy to find · make the site hierarchy easy to understand and navigate · use a clear, understandable page structure · make the most important actions and information prominent · break media into chunks · provide search.

### 3. Use clear and understandable content
Use clear words · use a simple tense and voice · avoid double negatives and nested clauses · use literal language (avoid idioms/metaphor) · keep text succinct · use clear, unambiguous formatting and punctuation · include the symbols/letters needed to decipher words · provide a summary of long documents and media · separate each instruction (one instruction per step) · use white space · ensure foreground content isn't obscured by background · explain implied content · provide alternatives for numerical concepts.

### 4. Help users avoid mistakes and know how to correct them
Ensure controls and content don't move unexpectedly · let users go back · notify users of fees and charges at the start of a task · design forms to prevent mistakes · make it easy to undo form errors · use clear, visible labels · use clear step-by-step instructions · accept different input formats (e.g., phone numbers with or without spaces) · avoid data loss and timeouts · provide feedback · help the user stay safe · use familiar metrics and units.

### 5. Help users focus
Limit interruptions · make short critical paths · avoid too much content (don't overload the screen) · provide the information a user needs to complete and prepare for a task.

### 6. Ensure processes do not rely on memory
Provide a login that doesn't rely on memory or other cognitive skills · allow a simple, single-step login · provide a login alternative with fewer words · let users avoid navigating voice menus · don't rely on users calculating or memorizing information across steps.

### 7. Provide help and support
Provide human help · provide alternative content for complex information and tasks · clearly state the results and disadvantages of actions, options, and selections · provide help for forms and non-standard controls · make it easy to find help and give feedback · provide help with directions · provide reminders.

### 8. Support adaptation and personalization
Let users control when content moves or changes · enable APIs and extensions · support simplification · support a personalized and familiar interface (let people keep settings that work for them).

## How to apply this in a review

1. Read the actual user-facing text aloud. If a sentence has a double negative, an idiom, jargon, or more than one instruction, rewrite it (Objective 3).
2. Trace the critical path. Count the steps and the things the user must *remember* between steps — eliminate the memory dependencies (Objectives 5 & 6).
3. Look at every form and destructive action. Can mistakes be prevented, undone, and clearly explained? Are costs and consequences shown *before* commitment (Objective 4 & 7)?
4. Check consistency and labels. Same thing named the same way everywhere; icons paired with text (Objectives 1 & 2).
