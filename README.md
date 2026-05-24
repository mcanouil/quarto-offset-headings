# Offset Headings

A Quarto extension that offsets heading levels by a positive or negative amount, in any output format.

Use it to shift a single heading, an entire heading subtree, or every heading in a document, without depending on a format-specific option.

## Motivation

Quarto and Pandoc already expose a `shift-heading-level-by` option, but it runs as a final post-processing pass over the whole document.
Because it applies after every Lua filter has finished, other extensions cannot see or react to the shifted levels, and you cannot target an individual heading or branch of the document.

This extension runs as a Lua filter instead.
Heading offsets are resolved during filtering, so they compose with other filter-based extensions, and you can offset a single heading, a subtree, or the entire document with per-heading control rather than one blanket value.

## Installation

```bash
quarto add mcanouil/quarto-offset-headings@0.1.1
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

The document-level offset and per-heading offsets combine: a heading receives the document offset plus any offset from its attribute or an active recursive cascade.

### Cap how deep a heading can be pushed

Use `offset-headings-max-level` to stop a positive offset from pushing a heading past a chosen level:

```markdown
## Section {offset-headings-by="3" offset-headings-max-level="4"}
```

A level-2 heading would normally become a level-5 heading, but the cap holds it at level 4.
The cap applies to the attributed heading and to any descendants reached through an active cascade.
The global range `[1, 6]` still applies, so the cap can never push a heading shallower than level 1 or deeper than level 6.
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

## Configuration

| Option      | Type    | Default | Description                                                                                               |
| ----------- | ------- | ------- | --------------------------------------------------------------------------------------------------------- |
| `by`        | integer | `0`     | Document-level offset applied to every heading. Resulting level clamped to `[1, 6]`.                      |
| `recursive` | boolean | `true`  | Default cascade behaviour for per-heading offsets when the attribute is omitted.                          |
| `max-level` | integer | `6`     | Default deepest level a positive offset may reach when the attribute is omitted. Global `[1, 6]` applies. |
| `depth`     | integer | `0`     | Default cascade depth limit when the attribute is omitted. `0` means unlimited depth.                     |

### Attributes

| Attribute                   | Type    | Default     | Description                                                                                   |
| --------------------------- | ------- | ----------- | --------------------------------------------------------------------------------------------- |
| `offset-headings-by`        | integer | `0`         | Offset added to this heading. Resulting level clamped to `[1, 6]`.                            |
| `offset-headings-recursive` | boolean | `recursive` | When true, cascade the offset to every nested heading below this one.                         |
| `offset-headings-max-level` | integer | `max-level` | Caps how deep this heading may be pushed by a positive offset. Global `[1, 6]` still applies. |
| `offset-headings-depth`     | integer | `depth`     | Bounds how many descendant levels inherit the cascade. `0` means unlimited depth.             |

## Example

Here is the source code for a minimal example: [example.qmd](example.qmd).

Rendered output:

- [HTML](https://m.canouil.dev/quarto-offset-headings/).
- [Typst](https://m.canouil.dev/quarto-offset-headings/example-typst.pdf).
