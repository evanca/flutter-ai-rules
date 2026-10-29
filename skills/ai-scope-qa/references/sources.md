# Primary references

Reviewed 29 October 2026. These sources informed the testing method; the bundled
prompts are original adaptations. Recheck current provider documentation before
integrating a live API or depending on a product feature.

| Source | What it supports | Important limit |
| --- | --- | --- |
| Larson et al., 2019, [An Evaluation Dataset for Intent Classification and Out-of-Scope Prediction](https://aclanthology.org/D19-1131/) ([paper](https://aclanthology.org/D19-1131.pdf)) | Measure out-of-scope recognition separately from supported-intent classification. The corpus spans 150 intent classes across 10 domains. | Historical intent-classification research; it does not benchmark a current generative model or define an app's allowed scope. |
| Ribeiro et al., 2020, [Beyond Accuracy: Behavioral Testing of NLP Models with CheckList](https://aclanthology.org/2020.acl-main.442/) ([paper](https://aclanthology.org/2020.acl-main.442.pdf)) | Minimum-functionality cases, meaning-preserving perturbations and directional expectations; linguistic coverage such as negation, coreference and robustness. | A testing methodology, not a universal conversational policy or mandatory number of cases. |
| Google Cloud, [Dialogflow CX test cases](https://docs.cloud.google.com/dialogflow/cx/docs/concept/test-case) | Turn-level and conversation-level expectations, including intent, flow, tools and parameters. Generated text can vary while behavior remains correct. | Product-specific tooling. Borrowing the expectation model does not require adopting Dialogflow or establish Gemini/Firebase production behavior. |
| OWASP, [LLM Prompt Injection Prevention Cheat Sheet](https://cheatsheetseries.owasp.org/cheatsheets/LLM_Prompt_Injection_Prevention_Cheat_Sheet.html) | Direct and indirect injection, authority/encoding/multi-turn variants, benign controls, observable side effects and explicit evaluation limits. | Example attacks are illustrative smoke tests. Prompt screening and refusal text alone do not establish security. Its operational logging advice must be reconciled with the project's privacy requirements. |

The distinction between an app's primary task and its support controls, fictional
versus real-world referents, quota behavior and data-retention checks is an
application of these methods to product requirements. The sources do not settle
romance, professional-advice, emergency-response or other policy decisions.

No source here establishes an optimal case count or acceptance threshold for a
particular product. Choose coverage and review criteria from its actual risks,
supported capabilities and observed failures; keep those decisions explicit.
