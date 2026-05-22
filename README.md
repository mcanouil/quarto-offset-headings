# Offset Headings

A Quarto extension that offsets heading levels by a positive or negative amount, in any output format.

Use it to shift a single heading, an entire heading subtree, or every heading in a document, without depending on a format-specific option.

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
    offset-headings-by: 1
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

Set `offset-headings-recursive` to `true` to cascade the same offset to every nested heading:

```markdown
## Section {offset-headings-by="1" offset-headings-recursive="true"}

### Subsection
```

Both headings shift by 1.
Cascading stops as soon as a heading at or above the original level of the attributed heading is reached.

The document-level offset and per-heading offsets combine: a heading receives the document offset plus any offset from its attribute or an active recursive cascade.

## Configuration

| Option              | Type    | Default | Description                                              |
| ------------------- | ------- | ------- | -------------------------------------------------------- |
| `offset-headings-by` | integer | `0`     | Document-level offset applied to every heading. Clamped to `[1, 6]`. |

### Attributes

| Attribute                   | Type    | Default | Description                                                            |
| --------------------------- | ------- | ------- | ---------------------------------------------------------------------- |
| `offset-headings-by`        | integer | -       | Offset added to this heading. Clamped to `[1, 6]`.                     |
| `offset-headings-recursive` | boolean | `false` | When true, cascade the offset to every nested heading below this one.  |

## Example

Here is the source code for a minimal example: [example.qmd](example.qmd).

Rendered output:

- [HTML](https://m.canouil.dev/quarto-offset-headings/).
