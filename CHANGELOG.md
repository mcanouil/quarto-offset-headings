# Changelog

## Unreleased

## 0.4.0 (2026-07-23)

### Breaking Changes

- feat!: Remove the `quarto-shift` option and the compensation for Quarto's automatic `shift-heading-level-by: -1`. The compensation could not detect an explicit `shift-heading-level-by` and silently produced wrong levels when one was set. The filter now only warns when Quarto's automatic shift can apply, recommending `shift-heading-level-by: 0` in the front matter, which disables the shift at the source.

### New Features

- feat: Add the `quarto-shift-warning` option (default `true`) to silence the automatic heading shift warning once `shift-heading-level-by: 0` is set explicitly, since an explicit `shift-heading-level-by` is invisible to Lua filters.

### Documentation

- docs: Rewrite the automatic heading shift section around the explicit `shift-heading-level-by: 0` fix.
- docs: Set `shift-heading-level-by: 0` in the Typst format of both example fixtures.

## 0.3.0 (2026-07-23)

### New Features

- feat: Add the `quarto-shift` option to state or disable the `shift-heading-level-by` Quarto applies after the filter runs.

### Bug Fixes

- fix: Compensate for the `shift-heading-level-by: -1` Quarto applies to Typst and PDF/LaTeX output when a document has no level-1 heading, so heading levels match across formats. Previously a heading left at level 1 was destroyed by that shift: the first one replaced the document title and the others became plain paragraphs.

### Documentation

- docs: Document the interaction with Quarto's automatic heading shift, including the AsciiDoc book and explicit `shift-heading-level-by` limitations.

## 0.2.2 (2026-06-08)

- fix: move lua filter to pre-ast to ensure it runs before any filters (e.g., `cascade`).

## 0.2.1 (2026-05-31)

### Bug Fixes

- fix: Warn and clamp when `max-level` (document option or per-heading attribute) is outside the global heading range `[1, 6]` instead of silently clamping.

### Documentation

- docs: State explicit cross-format support (HTML, PDF/LaTeX, Typst, DOCX).
- docs: Document the combine rule: document-level offset and per-heading offsets always add together before clamping.
- docs: Clarify that `max-level` caps the combined level (original level + document offset + per-heading or cascade offset), not the per-heading offset on its own.
- docs: Add a worked example combining cascade, `max-level`, and `depth` on a single heading.
- docs: Add `example-combine.qmd` fixture exercising the combine rules, cap, and depth.

## 0.2.0 (2026-05-24)

### New Features

- feat: Add `offset-headings-max-level` attribute and `extensions.offset-headings.max-level` option to cap how deep a positive offset may push a heading.
- feat: Add `offset-headings-depth` attribute and `extensions.offset-headings.depth` option to bound how many descendant levels inherit a cascading offset.

## 0.1.0 (2026-05-22)

### New Features

- feat: Initial release.
