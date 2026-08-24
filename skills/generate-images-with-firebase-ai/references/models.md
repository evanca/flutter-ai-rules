# Models and output controls

## Model IDs

Image model IDs churn faster than anything else here. Treat any ID written
down, including these, as a starting guess to confirm rather than a fact.

`gemini-3.1-flash-image` is Nano Banana 2, the current default for
text-and-image in, text-and-image out. `gemini-2.5-flash-image` is the previous
generation and resolves to `gemini-2.5-flash-preview-image`.

Confirm what your project can actually reach before debugging a failing call,
since a retired or misspelled ID and an unbilled project fail in similar ways:

```bash
curl -s "https://generativelanguage.googleapis.com/v1beta/models?key=$GEMINI_API_KEY" | grep '"name"'
```

## Gemini image generation vs Imagen

Both are reachable from `firebase_ai`. They are not interchangeable.

| | Gemini (`generativeModel`) | Imagen (`imagenModel`) |
| --- | --- | --- |
| Input image | Yes: edit, restyle, keep a face | Text prompt only |
| Text back with the image | Yes, interleaved parts | No |
| Multiple images per call | No | `numberOfImages` |
| Negative prompt | No | `negativePrompt` |
| Watermark control | No | `addWatermark` |
| Conversational refinement | Yes, via chat | No |

Choose Gemini when the user supplies a photo, when you need machine-readable
text alongside the image, or when you want to iterate on a result. Choose
Imagen for pure text-to-image where you want several candidates in one call or
a negative prompt.

The rest of this file covers Gemini.

## `ImageConfig`, the only reliable size control

```dart
GenerationConfig(
  responseModalities: [ResponseModalities.text, ResponseModalities.image],
  imageConfig: ImageConfig(
    aspectRatio: ImageAspectRatio.landscape16x9,
    imageSize: ImageSize.size2K,
  ),
)
```

Aspect ratios in `ImageAspectRatio`: `square1x1`, `portrait9x16`,
`landscape16x9`, `portrait3x4`, `landscape4x3`, `portrait2x3`, `landscape3x2`,
`portrait4x5`, `landscape5x4`, `portrait1x4`, `landscape4x1`, `portrait1x8`,
`landscape8x1`, `ultrawide21x9`.

Sizes in `ImageSize`: `size512`, `size1K`, `size2K`, `size4K`.

Note what is missing. 2:1 is not on the list, and neither is any other ratio you
might reasonably want. If yours is absent, asking for it in the prompt text is a
suggestion the model frequently ignores, so measure the returned image and lay
out from the measurement. Both fields are optional, and the enums grow between
releases, so check the installed package rather than assuming this list is
current:

```bash
grep -A 3 "enum ImageAspectRatio" ~/.pub-cache/hosted/pub.dev/firebase_ai-*/lib/src/image_config.dart
```

## Cost

Image generation is billed per generated image and is far more expensive than
text. Two consequences are worth designing around from the start.

A retry costs the same as the first try, so make failure states offer retry
deliberately rather than looping automatically.

An end-to-end test suite spends real money per run, roughly 30 to 60 seconds
and a live billed generation per pass. That argues for running it occasionally
against localhost rather than on every commit.
