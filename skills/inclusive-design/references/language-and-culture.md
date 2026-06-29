# Language & Culture Inclusion

## Internationalization vs. localization

Source: [Localization vs. Internationalization — W3C](https://www.w3.org/International/questions/qa-i18n)

Two distinct jobs, often confused:

- **Internationalization (i18n)** — "the design and development of a product, application or document content that enables easy localization for target audiences that vary in culture, region, or language." It's the *architecture* that makes adaptation possible — no hard-coded strings, externalized text, Unicode throughout, layouts that survive text expansion and right-to-left scripts.
- **Localization (l10n)** — "the adaptation of a product, application or document content to meet the language, cultural and other requirements of a specific target market." It's the *adaptation itself*.

Do the internationalization work up front; retrofitting it later is expensive. Localization then covers far more than translated strings:

- Language and UI text translation
- Cultural elements — symbols, icons, colors, imagery (these carry different meanings across cultures)
- Number, date, and time formats
- Currency
- Collation and sorting order
- Personal names and forms of address
- Keyboard configurations
- Region-specific legal requirements

W3C notes that when business practices or learning paradigms differ between cultures, localization can require a comprehensive redesign — not just a string swap. Plan for that.

## Inclusive name handling

Sources: [Personal names around the world — W3C](https://www.w3.org/International/questions/qa-personal-names) · [Personal names (techniques) — W3C](https://www.w3.org/International/techniques/authoring-html)

Name and form fields are where well-meaning products quietly tell people "you don't fit." Most form designs encode a single culture's naming assumptions. The reality:

- **Not everyone has a given-name + family-name structure.** "In cultures such as parts of Southern India, Malaysia and Indonesia, a large number of people have names that consist of a given name only, with no patronym."
- **Family-name order varies.** Chinese, Japanese, and many other names put the family name first.
- **Family members don't always share a surname.** "It would be wrong to assume that members of the same family share the same family name."
- **Single-letter names are real.** "Don't assume that a single letter name is an initial. People do have names that are one letter long."
- **Most of the world isn't in ASCII.** A large majority of people don't use the Latin alphabet, and of those who do, many use accents and characters that don't occur in English.

### Practical form-design rules

- **Question separate fields.** "Ask yourself whether you really need to have separate fields for given name and family name." A single full-name field is the most inclusive default; only split when you have a concrete need.
- **If you must split, add fields rather than carve up the name.** "Consider whether it would make sense to have one or more extra fields, in addition to the full name field, where you ask the user to enter the part(s) of their name that you need."
- **Avoid culture-bound labels.** "Try to avoid using the labels 'first name' and 'last name' in non-localized forms." If you do split, "ensure that you label clearly which parts you want where."
- **Ask how people want to be addressed.** "Ask separately, when setting up a profile for example, how that person would like you to address them." Don't algorithmically guess a greeting from a name field.
- **Give names room.** "Make input fields long enough to enter long names, and ensure that if the name is displayed on a web page later there is enough space for it." / "Avoid limiting the field size for names in your database."
- **Use Unicode end to end.** "If you do accept non-ASCII names, you should use a Unicode character encoding (eg. UTF-8) in your pages, your back end databases and in all the software code in between."

### Quick test

Try entering these into your form and database: a mononym (one name only), a name with the family name first, a name with diacritics or non-Latin script, a single-letter name, and a very long name. If any of them can't be entered, stored, or displayed back correctly, the form is excluding real people.
