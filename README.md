# Offset Headings

A Quarto extension that offsets heading levels by a positive or negative amount, in any output format.

Use it to shift a single heading, an entire heading subtree, or every heading in a document, without depending on a format-specific option.

The filter operates on Pandoc `Header` elements, so it works the same way across every output format Quarto produces, including HTML, PDF (LaTeX), Typst, and DOCX.

## Motivation

Quarto and Pandoc already expose a `shift-heading-level-by` option, but it runs as a final post-processing pass over the whole document.
Because it applies after every Lua filter has finished, other extensions cannot see or react to the shifted levels, and you cannot target an individual heading or branch of the document.

This extension runs as a Lua filter instead.
Heading offsets are resolved during filtering, so they compose with other filter-based extensions, and you can offset a single heading, a subtree, or the entire document with per-heading control rather than one blanket value.

## Installation

```bash
quarto add mcanouil/quarto-offset-headings@0.2.0
```

This will install the extension under the `_extensions` subdirectory.
If you are using version control, you will want to check in this directory.

## Usage

To use the extension, add the following to your document's front matter:

```yaml
filters:
  - offset-headings
```

### Offset every heading

Set a document-level offset to shift all headings at once:

```yaml
extensions:
  offset-headings:
    by: 1
```

### Offset a single heading

Add the `offset-headings-by` attribute to any heading:

```markdown
## Section {offset-headings-by="1"}
```

This produces a level-3 heading; the following headings are unaffected.

Negative values pull a heading up:

```markdown
### Section {offset-headings-by="-1"}
```

### Offset a heading and its descendants

Cascading is on by default: the same offset flows to every nested heading below the attributed one.

```markdown
## Section {offset-headings-by="1"}

### Subsection
```

Both headings shift by 1.
Cascading stops as soon as a heading at or above the original level of the attributed heading is reached.

Set `offset-headings-recursive` to `false` to limit the offset to the attributed heading alone:

```markdown
## Section {offset-headings-by="1" offset-headings-recursive="false"}

### Subsection
```

Only the first heading shifts; the subsection keeps its level.
The document-level `recursive` option sets this default for every heading that omits the attribute.

### Combine document and per-heading offsets

The document-level offset and per-heading offsets always add together.
A heading's final level is its original level plus the document offset plus any offset from its own attribute or an active recursive cascade.
The result is then clamped to the range `[1, 6]`, and to `max-level` when one applies.

For example, with a document-level offset of `1`:

```yaml
extensions:
  offset-headings:
    by: 1
```

```markdown
## Section
```

The level-2 heading becomes a level-3 heading from the document offset alone.

Add a per-heading offset on top:

```markdown
## Section {offset-headings-by="1"}
```

The same level-2 heading becomes a level-4 heading: original (2) + document offset (1) + per-heading offset (1).

A negative per-heading offset can cancel the document offset:

```markdown
## Section {offset-headings-by="-1"}
```

The level-2 heading stays at level 2: original (2) + document offset (1) + per-heading offset (-1).

### Cap how deep a heading can be pushed

Use `offset-headings-max-level` to stop a positive offset from pushing a heading past a chosen level:

```markdown
## Section {offset-headings-by="3" offset-headings-max-level="4"}
```

A level-2 heading would normally become a level-5 heading, but the cap holds it at level 4.
The cap applies to the **combined** level (original level + document offset + per-heading or cascade offset), not just to the per-heading offset on its own.
It applies to the attributed heading and to any descendants reached through an active cascade.
The global range `[1, 6]` still applies, so the cap can never push a heading shallower than level 1 or deeper than level 6.
Values outside `[1, 6]` are clamped and a warning is emitted.
The document-level `max-level` option sets this default for every heading that omits the attribute.

### Limit how far a cascade reaches

Cascading flows to every descendant by default.
Use `offset-headings-depth` to bound how many descendant levels inherit the offset:

```markdown
## Section {offset-headings-by="1" offset-headings-depth="1"}

### Subsection

#### Sub-subsection
```

With a depth of 1, only descendants within one level of the attributed heading's original level inherit the offset.
The section and its subsection shift, while the sub-subsection keeps its level.
A value of `0` means unlimited depth, matching the default cascade behaviour.
The document-level `depth` option sets this default for every heading that omits the attribute.

### Worked example: cascade, max-level, and depth together

The cascade, the cap, and the depth limit all act on the same heading.
Consider a document with a document-level offset of `1` and the following heading:

```yaml
extensions:
  offset-headings:
    by: 1
```

```markdown
## Section {offset-headings-by="2" offset-headings-max-level="4" offset-headings-depth="1"}

### Subsection

#### Sub-subsection
```

The attributed heading becomes a level-4 heading: original (2) + document offset (1) + per-heading offset (2) = 5, capped at `max-level` (4).
The subsection is within the cascade depth (`depth=1`), so it would become a level-5 heading (3 + 1 + 2), and the cap holds it at level 4.
The sub-subsection is beyond the cascade depth, so it only receives the document offset and becomes a level-5 heading (4 + 1).

## Configuration

| Option      | Type    | Default | Description                                                                                               |
| ----------- | ------- | ------- | --------------------------------------------------------------------------------------------------------- |
| `by`        | integer | `0`     | Document-level offset applied to every heading. Resulting level clamped to `[1, 6]`.                      |
| `recursive` | boolean | `true`  | Default cascade behaviour for per-heading offsets when the attribute is omitted.                          |
| `max-level` | integer | `6`     | Default cap on the combined heading level (original + document offset + per-heading offset) when the attribute is omitted. Global `[1, 6]` applies; out-of-range values are clamped with a warning. |
| `depth`     | integer | `0`     | Default cascade depth limit when the attribute is omitted. `0` means unlimited depth.                     |

### Attributes

| Attribute                   | Type    | Default     | Description                                                                                   |
| --------------------------- | ------- | ----------- | --------------------------------------------------------------------------------------------- |
| `offset-headings-by`        | integer | `0`         | Offset added to this heading. Resulting level clamped to `[1, 6]`.                            |
| `offset-headings-recursive` | boolean | `recursive` | When true, cascade the offset to every nested heading below this one.                         |
| `offset-headings-max-level` | integer | `max-level` | Caps the combined heading level (original + document offset + per-heading offset). Global `[1, 6]` still applies; out-of-range values are clamped with a warning. |
| `offset-headings-depth`     | integer | `depth`     | Bounds how many descendant levels inherit the cascade. `0` means unlimited depth.             |

## Example

Here is the source code for a minimal example: [example.qmd](example.qmd).

Rendered output:

- [HTML](https://m.canouil.dev/quarto-offset-headings/).
- [Typst](https://m.canouil.dev/quarto-offset-headings/example-typst.pdf).

A second fixture, [example-combine.qmd](example-combine.qmd), exercises the combine rules: document-level offset added to per-heading offsets, the `max-level` cap on the combined level, and the cascade depth limit.
