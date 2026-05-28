# Changelog

## Unreleased

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
