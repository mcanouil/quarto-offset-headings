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
quarto add mcanouil/quarto-offset-headings
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

## Configuration

| Option      | Type    | Default | Description                                                                          |
| ----------- | ------- | ------- | ------------------------------------------------------------------------------------ |
| `by`        | integer | `0`     | Document-level offset applied to every heading. Resulting level clamped to `[1, 6]`. |
| `recursive` | boolean | `true`  | Default cascade behaviour for per-heading offsets when the attribute is omitted.     |

### Attributes

| Attribute                   | Type    | Default     | Description                                                           |
| --------------------------- | ------- | ----------- | --------------------------------------------------------------------- |
| `offset-headings-by`        | integer | -           | Offset added to this heading. Resulting level clamped to `[1, 6]`.    |
| `offset-headings-recursive` | boolean | `recursive` | When true, cascade the offset to every nested heading below this one. |

## Example

Here is the source code for a minimal example: [example.qmd](example.qmd).

Rendered output:

- [HTML](https://m.canouil.dev/quarto-offset-headings/).
