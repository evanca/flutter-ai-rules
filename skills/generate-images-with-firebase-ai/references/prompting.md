# Prompting image models

None of these failures are code failures, and no unit test reaches any of them.
Each one costs a generation to discover, and they recur across projects, so
they are worth reading before you write the first prompt.

## The model reads your formatting as content

Shouty capitals get painted into the image. A prompt containing `ARTIST NAME`
produced artwork with the literal words "ARTIST NAME" set in display type. The
model cannot tell your emphasis from text you want reproduced, and capitals
read as lettering to typeset.

Two fixes, and you want both. Never emphasise with capitals in a prompt that
generates an image; use ordinary sentences. Then state the exclusion
positively:

> Every piece of text in the artwork must be one of the invented strings above.
> Never paint instruction words, field labels or placeholders such as "artist
> name" or "title" into the image.

The same goes for any structural scaffolding, including bracketed
placeholders, `<tags>` and `{{template}}` markers. If it looks like text, it
can end up in the picture.

## Attributes of a source photo survive unless you actively negate them

Asking for a new outfit gets you the old outfit in a new colour. Face, pose and
framing carry over readily, which is usually what you want, but so do clothing,
background and lighting, which usually is not.

Negate the specific attributes rather than the category, and say why it
matters:

> Wardrobe, and this is important: completely replace the clothing worn in the
> supplied photo. Do not keep the original garment, its colour, its pattern or
> its neckline. Nothing the person is wearing in the source photo should
> survive into the artwork.

"Dress them differently" does not do this. Enumerating garment, colour, pattern
and neckline does.

## Text appearing twice will be spelled two ways

If the same string is typeset in two places, such as front and back panels or a
title and a spine, the model will drift between them. It is generating pixels,
not copying a variable.

Say explicitly that the two are compared: "The album title must be spelled
identically on both halves, because they are shown side by side." Naming the
reason works better than repeating the instruction.

## Multi-panel layouts do not share a background by default

Ask for two panels and you get two separate photographs butted together, with a
visible seam and a tonal step at the join. Describe the continuity as the goal
rather than the panels as the units:

> The two halves must read as one continuous image. The background must flow
> unbroken across the centre fold, with no seam, no tonal step and no visible
> join.

## Let the model own the whole layout

Compositing text over a deliberately empty region in Flutter is worse than
asking the model to typeset it. The model lays type out better than a
constraint-based layout can, and a region it typeset itself is a region whose
background it composed around the type. Splitting the job is what produces the
seam problem above.

So the image is the output. Do not plan to parse anything back out of the
pixels.

## Vary one axis, keep the rest fixed

To make repeat runs feel different without feeling like a different product,
fix everything structural in the prompt and rotate a single art-direction
block.

Move the visual attributes together, as named presets. Rotating palette alone
puts chrome clothing on a grunge backdrop, which reads as a mistake rather than
a look. Palette, wardrobe, typography and treatment all belong to one
reference:

```dart
class CoverStyle {
  final String name;        // surfaced in the UI so a good roll is recognisable
  final String palette;
  final String wardrobe;
  final String typography;
  final String treatment;
}
```

Log which preset produced each generation. When a result comes back unusually
good or unusually bad, that log is the only record of what caused it.

Close the art direction with a commitment line, such as "Commit fully to this
art direction: the palette, wardrobe, lettering and film treatment above should
all be unmistakable at a glance." A hedged interpretation of a strong reference
is what produces bland output.

## Asking for structured text alongside the image

Ask for a fenced ```json block, keep the schema to a handful of flat string
keys, and reconcile it with the pixels explicitly: "The name painted into the
artwork must match the JSON above character for character."

Then parse it defensively. Across one session the same prompt returned fenced
JSON, bare JSON, prose-wrapped JSON, and no text at all. Try the fence, fall
back to the first balanced `{...}`, and return null instead of throwing. An
image without its caption is still worth showing.
