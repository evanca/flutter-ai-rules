# What to test, and what testing cannot reach

The seam is at your boundary. Everything past it needs evals rather than tests:
whether the model understood the prompt, whether the image is any good, whether
the type is legible.

A green suite says nothing about whether the app produces a good image. It says
your interpretation of a response is correct. That is worth having, and it is
not where the bugs will be. Plan the other layers accordingly.

## Layer 1: unit tests on your interpretation of a response

Cheap, fast, deterministic. Two functions are worth testing and they are the
only two: parsing the model's structured text, and turning one `Candidate` into
your draft type.

`Candidate`, `Content`, `TextPart` and `InlineDataPart` are all publicly
constructible, so these run against real SDK types with no Firebase and no test
doubles. Nothing is verified against a stand-in.

Cover the cases that actually occur: interleaved parts split correctly;
image-only yields a draft with missing text rather than an error; a stopped
generation reports its finish reason; a wholly empty response says so instead
of trailing off; the first image wins when several arrive. For the text parser,
fenced JSON, bare JSON, prose-wrapped JSON and no JSON at all must each end in
usable data or a null, never an exception.

`Candidate`'s constructor is positional, so build it through one helper in the
test file. A signature change in `firebase_ai` then breaks one line rather than
every test. That is also the reason to keep these tests few. The alternative to
a brittle test here is no test at all, but there is no reason to multiply the
brittleness.

## Layer 2: golden tests on layout, colour and geometry

Deterministic without any font work. The test environment substitutes a fixed
test font, so text renders as placeholder glyph boxes but renders identically
every run. Geometry and colour come through intact, which is what most visual
bugs actually are: a caption overlapping text the model printed into the same
corner, an uploaded photo cropped instead of fitted, a button spanning the
wrong column, an element clipped by a `Stack`.

Goldens protect decisions already made. They will not tell you the first render
is wrong.

## Layer 3: end-to-end on localhost, the wiring a user walks through

[Patrol](https://patrol.leancode.co/) is a third-party Flutter UI-testing
framework by LeanCode ([pub.dev](https://pub.dev/packages/patrol),
[GitHub](https://github.com/leancodepl/patrol)). Evaluate it as a dependency on
its own merits before adopting it. It launches Chromium through Playwright,
which reaches the three things that otherwise need a human at the keyboard.
Method names below come from its
[web testing docs](https://patrol.leancode.co/documentation/web); check that
page for current signatures rather than trusting this table.

| Gap | Patrol web API |
| --- | --- |
| Native file dialog, so every upload needs a person | `uploadFile(files: [UploadFileData(...)])` |
| Camera permission prompt cannot be accepted | `grantPermissions(permissions: [...])` |
| Download button never verified end to end | `verifyFileDownloads()` |

This layer costs real money per run. Each pass triggers a live billed
generation and takes 30 to 60 seconds, which argues for running it occasionally
rather than on every commit. It also verifies the flow, not the artwork. "An
image came back, the fields populated, a file downloaded" is assertable; "the
image is good" is not.

`grantPermissions` handles the camera prompt. Producing actual frames needs
Chromium's fake-media-device flags.

If Patrol is not a dependency you want, the layer itself still matters. Any
driver that can reach native file dialogs and browser permissions buys the same
thing. What you lose without one is coverage of upload, permissions and
download, which are exactly the steps a unit test cannot walk.

## Layer 4: evals on prompt adherence and image quality

Sampled generations scored by a judge model. Nondeterministic, costs money per
run, and the only layer that reaches the failures in `prompting.md`. Nothing
else touches them.

## What sits outside all four

Initialisation order. App Check minting a fresh token per browser is a web-only
plugin behaviour that resolves to a stub off-web, so it is not reproducible in a
VM test at all. Found by inspecting a live global in a running browser.

Progress reporting. The API gives no progress signal, so any staged "working..."
UI is paced on a timer. A test can assert the timer advances; it cannot assert
the story it tells is true. Stop at the last stage rather than claiming a
completion the model has not reported.

Main-isolate stalls. A full-size photo freezing the UI during base64 encoding
passes every correctness assertion. It needs a profile, or someone noticing.

The release attestation path. `ReCaptchaV3Provider` never executes in debug,
which makes it the most likely thing to break in production and the least
reachable by a test. See the release check in `setup.md`.
