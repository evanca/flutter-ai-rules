---
name: ai-scope-qa
description: Use when designing or reviewing QA prompts, conversation tests, or evaluations for an app's AI scope boundaries, ambiguous and off-topic requests, false refusals, topic drift, or prompt injection.
---

# AI Scope QA

Build a contextual test set that checks whether an app's AI completes legitimate
tasks and respects its boundaries. Measure false refusals as well as missed
refusals. A chatbot that rejects everything has failed the product task.

## Establish the contract

Read the project's current product scope, input/safety policy, prompt/context
contract and authoritative action interfaces. Separate intended behavior from
what is implemented. Identify supported tasks, social interaction, clarification,
unsupported actions, app support, sensitive input and excluded requests.

Do not copy another product's restrictions into this one. Professional-advice,
romance, emergency-response, mixed-request handling, retention and quota rules
are product-specific decisions subject to applicable platform requirements.
An unsettled decision is `pending_policy`, not an invented passing expectation.
Ask only for decisions that block the requested work; continue independent cases.

Keep three questions distinct:

1. Is the request within the app's intended scope?
2. Is the requested action supported and authorized in this context?
3. Does a separate safety or privacy rule change the handling?

Relevant vocabulary does not establish scope. An impossible fictional action is
not automatically an attack; a quoted instruction is not automatically an active
command. First-person language alone does not establish a real-life disclosure.

## Build the test set

- Read [the prompt checklist](references/prompt-checklist.md) when selecting
  coverage. Adapt its phrases to the actual app, supported languages and surfaces.
  Keep context and expected behavior beside each prompt.
- Include clear allowed cases, ordinary off-topic requests, near-domain requests,
  ambiguity and deliberate overrides. Pair adversarial examples with legitimate
  inputs containing similar words to expose keyword-based over-refusal.
- Add meaning-preserving variants and pairs whose changed meaning should change
  the result. Include the same words under different preceding conversations.
- Use multi-turn sequences for topic drift, return after refusal, delayed commands,
  compaction and resume when the app supports them. Test indirect injection in its
  actual untrusted channel, not only as a direct user message.
- Use synthetic records, dummy accounts and harmless canaries. Do not put real
  personal data, credentials or actual secrets into fixtures or evaluation logs.

Read [case design and evaluation](references/case-design.md) when preparing
fixtures, a harness or a results report. Reuse the project's existing schema and
resolver; this skill does not require a new framework or a parallel policy engine.

## Grade behavior, not refusal wording alone

Pin expected decisions to policy references. Check fixed notices exactly where
their copy is contractual; judge generated language against a reviewed rubric
instead of one exact sentence. Assess observable effects, access, disclosures,
quota and persistence separately from the displayed response. A polite refusal
does not undo an unauthorized operation that already happened.

Keep deterministic application tests separate from model-quality evaluations.
A fake response proves only the surrounding application behavior. A simulation
through a different SDK/model/context is separate evidence from the production
integration.

Run live evaluations only within existing authorization, test boundaries and
provider/run budgets. Stop at the agreed ceiling or a configuration, billing or
data-handling failure; do not silently retry, spend more or broaden permissions.
Preparing a checklist does not itself authorize live calls or deployment.

## Deliver

Provide the scope/decision assumptions, selected cases with expectations, coverage
gaps, unresolved policy and evidence status: drafted, structurally checked,
application-tested or model-evaluated. If evaluations ran, report per-case outcomes,
versions, relevant rates with denominators, failures and limits. Do not label an
empty response, timeout or missing telemetry as a successful refusal.

Use [the primary references](references/sources.md) for methodology and attribution.
They support testing practices, not a universal prompt list, sample count,
acceptance threshold or the correctness of a particular product policy.
