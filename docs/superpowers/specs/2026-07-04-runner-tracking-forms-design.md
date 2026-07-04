# Runner Tracking Forms — Design

**Date:** 2026-07-04
**Status:** Approved design, pending implementation plan

## Goal

Port the printable Runner Tracking Forms — currently maintained in Google Sheets and
exported to PDF — into this Jekyll site. The forms are generated from an OpenSplitTime
(OST) bib/name CSV export, cleaned up, and rendered as print-ready HTML pages linked
from the site index.

Two form types per race:

1. **Bib-based roster form** — a pre-printed roster sorted by bib number, with write-in
   columns for tracking each runner through an aid station.
2. **Time-based arrival log** — a blank grid where volunteers log Time IN + Bib Number
   in the order runners arrive.

The same roster form is reused at every aid station for a race (the aid station name is
handwritten), so forms are generated **per race**, not per aid station.

## Source data

- **Input:** OST CSV export, columns `First Name, Last Name, Gender, Birthdate, Age,
  Email, Phone, City, State, Country, Bib Number`.
- **Seed file:** `~/Downloads/Participants - OST Export and Tracking Sheet - OST Import.csv`
  (226 High Lonesome 100 runners) — used to seed the initial HiLo roster.
- Only `First Name` and `Bib Number` are used in the forms. All other columns are ignored.

## Cleanups vs. the Google Sheets version

- **Name = first name only** (was "First name + Last initial", e.g. "Jesse H." → "Jesse").
- **Consistent pacer columns** — `Pacer In?` / `Pacer Out?` appear on *every* page (the
  Sheets version dropped them after page 1).
- **Tighter, controlled print layout** — consistent row heights, clean page/column breaks
  that never split a row.
- **Cleaner header** — race name + year, form title, blank "Aid Station" line, page numbers.
  No logo (no asset in repo yet; header is text-based and a logo can be added later).
- **Light instructions** added to each form.

## Architecture

Data flow:

```
OST CSV → scripts/build-roster.rb → _data/rosters/<race>.yml → _layouts/form.html → static print page
```

Rosters are committed to git, so forms rebuild with the site — no live CSV dependency at
serve/build time.

### Components

1. **Roster conversion script** — `scripts/build-roster.rb`
   - Ruby (matches the existing Jekyll/Ruby toolchain; no new runtime).
   - Usage: `ruby scripts/build-roster.rb <path-to-csv> <race-slug>`
   - Reads the OST CSV, writes `_data/rosters/<race>.yml` as a list sorted numerically by
     bib: `- {bib: 1, name: "Jon"}`.
   - Cleanup: first name only, whitespace trimmed, rows with a blank bib or blank name
     skipped.
   - Idempotent — safe to re-run whenever a roster changes.
   - Usage documented in `CLAUDE.md`.

2. **Race metadata** — `_data/races.yml`
   - Keyed by race slug: `hilo: {name: "High Lonesome 100", year: 2025}`.
   - Feeds the form header (name + year). Small and reusable (could later feed the index
     and intros).

3. **Form layout** — `_layouts/form.html`
   - Standalone, **print-optimized** layout. Deliberately does **not** use the
     `manual-wrapper` / `markdown-body` / github-markdown-css chain (that styling is
     screen-oriented).
   - Renders: header (race name + year, "Runner Tracking Form", blank "Aid Station: ____"
     line, page numbers), a short instructions blurb, then branches on `page.form_type`:
     - `bib`  → include `forms/bib-roster.html`
     - `time` → include `forms/time-log.html`

4. **Bib roster partial** — `_includes/forms/bib-roster.html`
   - Reads `site.data.rosters[page.race]`.
   - Columns on **every page**: Bib · Name · Time IN · Pacer In? · Time OUT · Pacer Out?.
   - **Two roster columns per page.** Rows are chunked in Liquid (~40 rows per column,
     ~80 per page) so a row never splits across a column/page break.
   - Ends with a blank **"New Runners"** write-in section (~8 blank rows: Bib · Time IN ·
     Time OUT).

5. **Time-log partial** — `_includes/forms/time-log.html`
   - Blank grid of Time IN + Bib Number cells, roomy for handwriting, two columns per page
     across ~2 pages.
   - Header includes a **Direction: Inbound / Outbound** line.

6. **Print CSS** — `@media print` block in `css/style.css`
   - US Letter page size, sane margins.
   - Repeated table header row on each printed page.
   - Page-break control (no split rows).
   - Hides any site chrome (nav/footer) when printing.
   - Solid black borders, checkbox glyphs for pacer columns.

7. **Form pages** — per race under `forms/`:
   - `forms/<race>-bib.html`  — front matter: `layout: form`, `race:`, `form_type: bib`.
   - `forms/<race>-time.html` — front matter: `layout: form`, `race:`, `form_type: time`.
   - Start with **HiLo** (only race with CSV data). Sawatch / Westline Winder get pages
     once their rosters exist.

8. **Index links** — add a "Runner Tracking Forms" links block per race in `index.markdown`.

## Light instructions (draft)

- **Bib-based form:** "Fill in the Aid Station name above. Record Time IN and Time OUT for
  each runner as they arrive and leave. Check the pacer boxes if a pacer is with them. Add
  anyone not on the list to the New Runners section."
- **Time-based form:** "Fill in the Aid Station name and direction above. As each runner
  passes, write the current time (Time IN) and their bib number in the next open cell, in
  order of arrival."

## Scope / YAGNI

- Only HiLo has roster data now; build HiLo forms first, structure so other races drop in.
- No logo handling until an asset exists.
- No live/dynamic CSV loading — conversion is an explicit, committed build step.
- `_data/races.yml` carries only what the header needs (name, year).

## Open items resolved during design

- Both form types in scope.
- CSV → `_data` yaml via a Ruby script (not native CSV read, not hand-maintained).
- Name = first name only.
- Pacer columns kept on every page.
- Per-race form pages linked from the index (not per-aid, not one combined page).
- Instruction wording and blank-row counts left to implementer's judgment (drafted above).
