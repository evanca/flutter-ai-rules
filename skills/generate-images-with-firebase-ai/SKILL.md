---
name: generate-images-with-firebase-ai
description: "Use when generating or editing images from Flutter/Dart with Firebase AI Logic and a Gemini image model (Nano Banana), making the first call work, choosing Gemini Developer API vs Vertex AI, hitting quota, billing or App Check failures, getting empty or image-only responses, sending a user photo as input, controlling aspect ratio or size, writing the image prompt, or deciding what to test."
---

# Generating images with Firebase AI Logic

Gemini image models return interleaved text and image parts from one call. The
response is a sequence to walk, not a string to read.

A request that comes back empty is usually a configuration problem rather than
a bug in your code, so section 1 covers the three settings that cause it.

## 1. Three things that block the very first call

A first call that returns an error, an empty response, or a 403 is almost
always one of these rather than your Dart. Rule them out before you debug code.

**Billing.** Image generation has no free tier. On a Spark-plan project the
image models return `limit: 0` for `generate_content_free_tier_requests`, so
the first request fails on quota having made zero requests. Text models do work
on Spark, which means "my other Gemini call works" proves nothing. Upgrade to
Blaze, then verify the current limits rather than trusting this note:

```bash
gcloud services quota list --service=generativelanguage.googleapis.com --consumer=projects/YOUR_PROJECT_ID
```

**App Check.** Firebase AI Logic enforces App Check when the project has it
turned on. Otherwise the endpoint is open to anyone who extracts your config
from the shipped client, and that config is public by design. Anything
reachable from a device you do not control needs App Check. Debug builds
attest with a debug provider, release builds with a real one. Web has a
specific trap that costs an afternoon, described in `references/setup.md`.

**`responseModalities`.** Without it the model has no permission to return an
image, so you get text describing the picture it would have drawn. Set both
modalities, as in the call below.

## 2. The minimal call that works

```dart
final model = FirebaseAI.googleAI().generativeModel(
  model: 'gemini-3.1-flash-image',
  generationConfig: GenerationConfig(
    responseModalities: [
      ResponseModalities.text,
      ResponseModalities.image,
    ],
    imageConfig: ImageConfig(
      aspectRatio: ImageAspectRatio.landscape16x9,
      imageSize: ImageSize.size2K,
    ),
  ),
);

final response = await model.generateContent([
  Content.multi([
    TextPart(prompt),
    InlineDataPart('image/jpeg', selfieBytes), // omit for text-to-image
  ]),
]);
```

`FirebaseAI.googleAI()` is the Gemini Developer API. Prefer it: it needs no GCP
surface of its own, and its free tier covers text. `FirebaseAI.vertexAI()`
requires Blaze regardless of model and buys you GCP-side controls, so reach for
it when the project already lives in Vertex rather than by default.

Do not pass `appCheck:` or `auth:` to `googleAI()`. Both parameters are
deprecated in current `firebase_ai`; the instance resolves them from the
`FirebaseApp` on its own.

For model IDs, aspect-ratio and size enums, and when Imagen beats Gemini, read
`references/models.md`.

## 3. Reading the response

The convenience `.text` accessor does not capture the full sequence, so walk
the parts directly. Pattern-match on the part type, which keeps the switch
correct when the SDK adds new part types:

```dart
Uint8List? image;
final buffer = StringBuffer();
for (final part in candidate.content.parts) {
  switch (part) {
    case InlineDataPart(:final bytes):
      image ??= bytes;          // first image wins
    case TextPart(:final text):
      buffer.write(text);
    default:
      break;
  }
}
```

Keep the interpretation of a response in its own pure function taking a
`Candidate`. `Candidate`, `Content`, `TextPart` and `InlineDataPart` are all
publicly constructible, so that function is testable with real SDK types, no
Firebase and no test doubles. It is the one seam in this stack that unit tests
genuinely reach.

### When no image comes back

An empty result surfaces as a blank error and reads like a client bug, which
sends people debugging the wrong half of the system. The response carries the
reason, so report it. In order:

| Check | Where | Means |
| --- | --- | --- |
| `response.promptFeedback?.blockReason` | before candidates | Your input was rejected. Read `blockReasonMessage` too. |
| `response.candidates` empty | n/a | Nothing generated at all. |
| `candidate.finishReason` | on the candidate | The model stopped: safety, recitation, or a token limit. `finishMessage` adds detail. |
| No image but text present | after walking parts | It answered in prose instead of drawing. Usually a prompt problem. |
| Everything empty, no reason | n/a | Say so plainly and let the user retry. This happens intermittently. |

Image-only responses, with no text at all, also happen intermittently on
prompts that reliably return both. If you ask for text alongside the image,
treat its absence as normal and degrade instead of throwing.

## 4. Sending a user photo

Downscale before you send. `InlineDataPart.toJson()` base64-encodes the bytes
synchronously on the main isolate, so a full-size phone photo freezes the UI
for seconds while the request is built. Gemini downsamples large images anyway,
so you pay for detail that is then discarded. Scale at pick time rather than
after:

```dart
final file = await picker.pickImage(
  source: ImageSource.gallery,
  maxWidth: 1280,
  maxHeight: 1280,
  imageQuality: 85,
);
```

Size the cap to your subject rather than to a habit. 1280px on the long edge
holds a face or a single figure comfortably, while fine texture, legible text
in the source, or a wide scene the model has to read across will want more.
Match `mimeType` to what the picker actually returned.

## 5. Sizing the result

Use `ImageConfig` when your ratio is one of the supported enum values, because
it is a real constraint. Asking for a ratio in the prompt text is a suggestion
the model frequently ignores. If you need a ratio the enum does not offer, 2:1
for instance, measure what came back and lay out from the measurement:

```dart
final descriptor = await ui.ImageDescriptor.encoded(
  await ui.ImmutableBuffer.fromUint8List(bytes),
);
final size = ui.Size(descriptor.width.toDouble(), descriptor.height.toDouble());
descriptor.dispose();
```

Wrap it so a failure returns null instead of throwing. An image you cannot
measure is still an image worth showing.

## 6. Getting text and image from one call

You often want machine-readable data about the image the model just drew, such
as a caption or the names it invented. Once that data is pixels your app cannot
read it, so ask for it as text in the same call and reconcile the two halves in
the prompt: "the title painted into the image must match the JSON character for
character."

Parse that text defensively. Asked for a fenced ```json block, the model will
across one session return fenced JSON, bare JSON, prose-wrapped JSON, and
nothing at all. Try the fence, fall back to the first balanced `{...}`, and
return null instead of throwing.

## 7. Prompting

The failures here are not code failures, and no unit test reaches them. The
recurring ones have specific fixes worth knowing before you write the first
prompt: placeholder words painted literally into the artwork, the source
photo's clothing surviving an outfit change, text spelled differently in two
places, and panels that do not share a background. Read
`references/prompting.md`.

## 8. Deciding what to test

The seam is at your boundary. Unit tests protect your interpretation of a
response and nothing past it, so a green suite says nothing about whether the
app produces a good image. `references/testing.md` covers the layers and what
each one cannot reach.

## External documentation

Everything here is a summary that will drift. When a detail matters, confirm it
at the source.

- [Firebase AI Logic docs](https://firebase.google.com/docs/ai-logic), including
  [get started](https://firebase.google.com/docs/ai-logic/get-started) and
  [generate images with Gemini](https://firebase.google.com/docs/ai-logic/generate-images-gemini)
- [`firebase_ai`](https://pub.dev/packages/firebase_ai), the Dart SDK. Its
  source is the fastest way to settle an API question:
  `~/.pub-cache/hosted/pub.dev/firebase_ai-*/lib/src/`
- [`image_picker`](https://pub.dev/packages/image_picker), which supplies the
  `pickImage` call in section 4. A third-party choice you can swap.
- [Patrol](https://patrol.leancode.co/), a third-party E2E framework by
  LeanCode, discussed in `references/testing.md`

## Reference files

- `references/setup.md`: Firebase console path, provider choice, billing, and the web App Check debug-token trap
- `references/models.md`: model IDs, aspect-ratio and size enums, Gemini vs Imagen
- `references/prompting.md`: the mistakes image prompts actually make, and the phrasings that fix them
- `references/testing.md`: unit, golden, e2e and eval layers, and what each cannot reach
