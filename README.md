# Offset Headings

A Quarto extension that offsets heading levels by a positive or negative amount, in any output format.

Use it to shift a single heading, an entire heading subtree, or every heading in a document, without depending on a format-specific option.

Unlike Pandoc's `shift-heading-level-by`, which runs after every Lua filter and applies one value to the whole document, this resolves offsets during filtering, so they compose with other filter-based extensions and can target one heading at a time.

## Installation

```bash
quarto add mcanouil/quarto-offset-headings@0.4.0
```

This will install the extension under the `_extensions` subdirectory.
If you are using version control, you will want to check in this directory.

## Documentation

The full documentation lives at <https://m.canouil.dev/quarto-offset-headings/>: every option and attribute, how the offsets combine, the cascade and its depth limit, and the interaction with Quarto's automatic heading shift.

[`example.qmd`](example.qmd) is a short, standalone starting point you can copy.
[`example-combine.qmd`](example-combine.qmd) exercises the combine rules.

## Licence

[MIT](https://github.com/mcanouil/quarto-offset-headings?tab=MIT-1-ov-file#readme).
