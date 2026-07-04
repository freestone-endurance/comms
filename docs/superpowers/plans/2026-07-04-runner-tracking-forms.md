# Runner Tracking Forms Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Generate print-ready HTML runner-tracking forms (bib-based roster + time-based arrival log) from an HL100 registration CSV, integrated into the existing Jekyll site and linked from the index.

**Architecture:** A Ruby script converts the registration CSV into a committed `_data/rosters/<race>.yml` file. A standalone, print-optimized `form` Jekyll layout renders per-race form pages, pulling the roster from `site.data.rosters` and race name/year from `_data/races.yml`. Two form types (`bib`, `time`) are selected by page front matter. All print styling lives in a dedicated `css/forms.css` linked only by the form layout, so it never touches the rest of the site.

**Tech Stack:** Jekyll (Liquid templates, `_data` YAML), Ruby stdlib (`csv`, `yaml`), plain CSS with `@media print` / `@page`.

## Global Constraints

- `baseurl` is `/comms` — every asset link in a layout MUST use `{{ site.baseurl }}/...`.
- Only pages with YAML front matter are processed by Jekyll; every form page and layout starts with a front-matter block (`---`).
- Data is read with the existing pattern `site.data.<file>[page.race]` (see `_includes/timeline.html`).
- Race slug for High Lonesome 100 is `hilo` (matches `_data/timeline.yaml`, `_includes/parts/intros/hilo.markdown`).
- Roster YAML uses **string** keys (`bib`, `name`) so Jekyll exposes them as `runner.bib` / `runner.name`.
- Name shown on forms is **first name only**. Only `Status == "Active"` rows with a non-blank bib and name are included.
- There is no test framework in this repo. "Tests" are: run the script against a fixture / run `bundle exec jekyll build`, then assert on the generated output in `_site/`.
- Commit messages end with:
  `Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>`

## File Structure

- Create `scripts/build-roster.rb` — CSV → `_data/rosters/<race>.yml` converter.
- Create `scripts/fixtures/roster-sample.csv` — tiny fixture for verifying the script.
- Create `_data/rosters/hilo.yml` — generated HL100 roster (committed).
- Create `_data/races.yml` — race display name + year, keyed by slug.
- Create `_layouts/form.html` — standalone print layout; branches on `page.form_type`.
- Create `_includes/forms/roster-table.html` — renders one roster half-table (given `include.rows`).
- Create `_includes/forms/bib-roster.html` — splits roster into two columns + New Runners section.
- Create `_includes/forms/time-log.html` — blank arrival-log grid.
- Create `css/forms.css` — all form + print styling.
- Create `forms/hilo-bib.html` — bib form page (front matter only).
- Create `forms/hilo-time.html` — time form page (front matter only).
- Modify `index.markdown` — add "Runner Tracking Forms" links.
- Modify `CLAUDE.md` — document roster regeneration + adding forms.

---

## Task 1: Roster conversion script + generated HL100 roster

**Files:**
- Create: `scripts/build-roster.rb`
- Create: `scripts/fixtures/roster-sample.csv`
- Create (generated): `_data/rosters/hilo.yml`

**Interfaces:**
- Produces: CLI `ruby scripts/build-roster.rb <csv-path> <race-slug>` → writes `_data/rosters/<race-slug>.yml`, an array of `{ "bib" => Integer, "name" => String }` sorted ascending by bib. Prints `Wrote <n> runners to <path>`.
- Produces: `_data/rosters/hilo.yml` consumed by Task 2 via `site.data.rosters.hilo`.

- [ ] **Step 1: Write the fixture CSV (the failing-test input)**

Create `scripts/fixtures/roster-sample.csv`:

```csv
Status,Bib,First Name,Last Name,Email Address,Gender
Dropped,,Erin,Linehan,erinlinehan1@gmail.com,F
Active,3,Daniel,Trampe,dan@example.com,M
Active,1,Jeffrey,Colt,easycolt@gmail.com,M
Active,,Blank,Bibless,blank@example.com,F
Active,2,Ryan,Sullivan,rsullivan623@gmail.com,M
```

This covers: a `Dropped` row (excluded), out-of-order bibs (must sort), an `Active` row with a blank bib (excluded), and normal rows.

- [ ] **Step 2: Run the converter against the fixture to verify it fails**

Run: `ruby scripts/build-roster.rb scripts/fixtures/roster-sample.csv testsample`
Expected: FAIL — `ruby: No such file or directory -- scripts/build-roster.rb (LoadError)` (the script does not exist yet).

- [ ] **Step 3: Write the converter script**

Create `scripts/build-roster.rb`:

```ruby
#!/usr/bin/env ruby
# frozen_string_literal: true
#
# Convert an HL100 registration CSV into a Jekyll roster data file.
# Usage: ruby scripts/build-roster.rb <path-to-csv> <race-slug>
# Writes _data/rosters/<race-slug>.yml, sorted ascending by bib.
#
# Columns are looked up by header name, so column order/extra columns are fine.
# Only rows with Status == "Active" and a non-blank Bib and First Name are kept.
# The form shows first name only.

require "csv"
require "yaml"

csv_path, race = ARGV
unless csv_path && race
  abort "Usage: ruby scripts/build-roster.rb <path-to-csv> <race-slug>"
end

rows = CSV.read(csv_path, headers: true)

runners = rows.filter_map do |row|
  next unless row["Status"]&.strip == "Active"

  bib = row["Bib"]&.strip
  name = row["First Name"]&.strip
  next if bib.nil? || bib.empty? || name.nil? || name.empty?

  { "bib" => Integer(bib, 10), "name" => name }
end

runners.sort_by! { |runner| runner["bib"] }

out_dir = File.join("_data", "rosters")
require "fileutils"
FileUtils.mkdir_p(out_dir)
out_path = File.join(out_dir, "#{race}.yml")
File.write(out_path, YAML.dump(runners))

puts "Wrote #{runners.length} runners to #{out_path}"
```

- [ ] **Step 4: Run against the fixture to verify it passes**

Run: `ruby scripts/build-roster.rb scripts/fixtures/roster-sample.csv testsample`
Expected: prints `Wrote 3 runners to _data/rosters/testsample.yml`

Then verify content:
Run: `cat _data/rosters/testsample.yml`
Expected (order and exclusions matter — Jeffrey/1, Ryan/2, Daniel/3; no Erin, no Blank):

```yaml
---
- bib: 1
  name: Jeffrey
- bib: 2
  name: Ryan
- bib: 3
  name: Daniel
```

- [ ] **Step 5: Remove the throwaway test output**

Run: `rm _data/rosters/testsample.yml`
(The fixture stays in git as documentation; the `testsample` output does not.)

- [ ] **Step 6: Generate the real HL100 roster**

Run: `ruby scripts/build-roster.rb ~/Downloads/"2026 Runners - HL100 - Runners.csv" hilo`
Expected: prints `Wrote <n> runners to _data/rosters/hilo.yml` where `<n>` is roughly 280 (all `Active` rows with bibs).

Verify it looks right:
Run: `head -6 _data/rosters/hilo.yml`
Expected: starts at bib 1 with a real first name, ascending, string keys `bib:` / `name:`.

- [ ] **Step 7: Commit**

```bash
git add scripts/build-roster.rb scripts/fixtures/roster-sample.csv _data/rosters/hilo.yml
git commit -m "Add roster converter script and HL100 roster data

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>"
```

---

## Task 2: Form layout, print CSS, and the bib-based form page

**Files:**
- Create: `_data/races.yml`
- Create: `css/forms.css`
- Create: `_layouts/form.html`
- Create: `_includes/forms/roster-table.html`
- Create: `_includes/forms/bib-roster.html`
- Create: `forms/hilo-bib.html`

**Interfaces:**
- Consumes: `site.data.rosters.hilo` (Task 1) — array of `{bib, name}`.
- Produces: `_layouts/form.html` — a leaf layout (its own `<!doctype html>`); pages set `layout: form`, `race:`, `form_type:`. For `form_type: bib` it includes `forms/bib-roster.html`; for `form_type: time` it includes `forms/time-log.html` (Task 3).
- Produces: `_includes/forms/roster-table.html` — renders one `<table class="roster-col">` from `include.rows` (an array of `{bib, name}`).
- Produces: `/comms/forms/hilo-bib.html` built page.

- [ ] **Step 1: Add race metadata**

Create `_data/races.yml`:

```yaml
hilo:
  name: High Lonesome 100
  year: 2026
sawatch-ascent:
  name: Sawatch Ascent
  year: 2026
westline-winder:
  name: Westline Winder
  year: 2026
```

- [ ] **Step 2: Add the print stylesheet**

Create `css/forms.css`:

```css
/* Runner tracking form styles. Linked ONLY from the `form` layout, so these
   rules never affect the rest of the site. Optimized for printing on Letter. */

@page {
  size: letter;
  margin: 0.5in;
}

body.form {
  font-family: Arial, Helvetica, sans-serif;
  font-size: 10pt;
  color: #000;
  margin: 0.5in;
}

.screen-note {
  background: #ffe;
  border: 1px solid #cc0;
  padding: 0.5em;
  margin: 0 0 1em;
}

.form-header {
  display: flex;
  justify-content: space-between;
  align-items: flex-end;
  border-bottom: 2px solid #000;
  padding-bottom: 6px;
  margin-bottom: 8px;
}

.form-heading h1 { font-size: 16pt; margin: 0; }
.form-heading h2 { font-size: 13pt; margin: 2px 0 0; font-weight: bold; }

.form-meta { text-align: right; }
.form-meta p { margin: 0 0 4px; }

.write-line {
  display: inline-block;
  width: 2.5in;
  border-bottom: 1px solid #000;
}

.form-instructions {
  font-size: 9pt;
  font-style: italic;
  margin: 0 0 8px;
}

.roster-cols {
  display: flex;
  gap: 0.3in;
  align-items: flex-start;
}
.roster-col { flex: 1; }

table {
  border-collapse: collapse;
  width: 100%;
}

th, td {
  border: 1px solid #000;
  padding: 2px 4px;
  font-size: 9pt;
  text-align: left;
}

th {
  font-size: 8pt;
  background: #eee;
  -webkit-print-color-adjust: exact;
  print-color-adjust: exact;
}

/* Repeat the column headers on every printed page. */
thead { display: table-header-group; }
/* Never split a runner's row across a page or column break. */
tr { break-inside: avoid; }

td.bib { font-weight: bold; text-align: center; width: 0.4in; }
td.time { min-width: 0.85in; }
td.check { text-align: center; width: 0.55in; }

.checkbox {
  display: inline-block;
  width: 11px;
  height: 11px;
  border: 1px solid #000;
}

.new-runners-title {
  margin: 12px 0 4px;
  font-size: 11pt;
  text-align: center;
}
.new-runners td { height: 0.28in; }

.time-log td { height: 0.42in; }

@media print {
  .screen-note { display: none; }
  a[href]:after { content: ""; }
}
```

- [ ] **Step 3: Add the one-table include**

Create `_includes/forms/roster-table.html`:

```html
<table class="roster-col">
  <thead>
    <tr>
      <th>Bib</th>
      <th>Name</th>
      <th>Time IN</th>
      <th>Pacer In?</th>
      <th>Time OUT</th>
      <th>Pacer Out?</th>
    </tr>
  </thead>
  <tbody>
    {% for runner in include.rows %}
    <tr>
      <td class="bib">{{ runner.bib }}</td>
      <td class="name">{{ runner.name }}</td>
      <td class="time"></td>
      <td class="check"><span class="checkbox"></span></td>
      <td class="time"></td>
      <td class="check"><span class="checkbox"></span></td>
    </tr>
    {% endfor %}
  </tbody>
</table>
```

- [ ] **Step 4: Add the bib-roster include**

Create `_includes/forms/bib-roster.html` (splits the roster into two side-by-side columns, then a blank New Runners section):

```html
{% assign roster = site.data.rosters[page.race] %}
{% assign total = roster | size %}
{% assign half = total | plus: 1 | divided_by: 2 %}
{% assign right_len = total | minus: half %}
{% assign left = roster | slice: 0, half %}
{% assign right = roster | slice: half, right_len %}

<div class="roster-cols">
  {% include forms/roster-table.html rows=left %}
  {% include forms/roster-table.html rows=right %}
</div>

<h3 class="new-runners-title">New Runners</h3>
<table class="new-runners">
  <thead>
    <tr>
      <th>Bib</th>
      <th>Time IN</th>
      <th>Pacer In?</th>
      <th>Time OUT</th>
      <th>Pacer Out?</th>
    </tr>
  </thead>
  <tbody>
    {% for i in (1..8) %}
    <tr>
      <td></td>
      <td></td>
      <td class="check"><span class="checkbox"></span></td>
      <td></td>
      <td class="check"><span class="checkbox"></span></td>
    </tr>
    {% endfor %}
  </tbody>
</table>
```

- [ ] **Step 5: Add the form layout**

Create `_layouts/form.html`:

```html
---
---
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8">
  {% assign race = site.data.races[page.race] %}
  <title>{{ race.name }} Runner Tracking Form</title>
  <link rel="stylesheet" href="{{ site.baseurl }}/css/forms.css">
</head>
<body class="form">
  <p class="screen-note">Print this page with Cmd/Ctrl-P (Letter, portrait). Enable "Background graphics" if the header shading or boxes look faint.</p>

  <header class="form-header">
    <div class="form-heading">
      <h1>{{ race.name }} {{ race.year }}</h1>
      <h2>Runner Tracking Form</h2>
    </div>
    <div class="form-meta">
      {% if page.form_type == 'time' %}
      <p><strong>Direction:</strong> Inbound&nbsp;/&nbsp;Outbound <em>(prefer Inbound)</em></p>
      {% endif %}
      <p class="form-aid">Aid Station: <span class="write-line"></span></p>
    </div>
  </header>

  {% if page.form_type == 'bib' %}
  <p class="form-instructions">Fill in the Aid Station name above. Record Time IN and Time OUT for each runner as they arrive and leave. Check the pacer boxes if a pacer is with them. Add anyone not on the list to the New Runners section at the end.</p>
  {% include forms/bib-roster.html %}
  {% elsif page.form_type == 'time' %}
  <p class="form-instructions">Fill in the Aid Station name and direction above. As each runner passes, write the current time (Time IN) and their bib number in the next open cell, in order of arrival.</p>
  {% include forms/time-log.html %}
  {% endif %}
</body>
</html>
```

Note: the `{% include forms/time-log.html %}` line only executes when `form_type == 'time'`; because `hilo-bib.html` sets `form_type: bib`, the missing time-log include (added in Task 3) does not break this task's build.

- [ ] **Step 6: Add the bib form page**

Create `forms/hilo-bib.html`:

```html
---
layout: form
race: hilo
form_type: bib
title: High Lonesome 100 — Bib Runner Tracking Form
---
```

- [ ] **Step 7: Build the site and verify the bib form renders**

Run: `bundle exec jekyll build`
Expected: `done in N seconds.` with no Liquid errors.

Run: `test -f _site/forms/hilo-bib.html && echo EXISTS`
Expected: `EXISTS`

Run: `grep -c 'class="bib"' _site/forms/hilo-bib.html`
Expected: a number equal to the roster size printed in Task 1 Step 6 (≈280).

Run: `grep -o 'class="roster-col"' _site/forms/hilo-bib.html | wc -l`
Expected: `2` (two side-by-side roster columns; note the exact-string match avoids also counting the `roster-cols` container).

Run: `grep -c 'Pacer In?' _site/forms/hilo-bib.html`
Expected: `3` (two roster columns + New Runners table all keep the pacer header).

Run: `grep -c 'New Runners' _site/forms/hilo-bib.html`
Expected: `1`

- [ ] **Step 8: Commit**

```bash
git add _data/races.yml css/forms.css _layouts/form.html _includes/forms/roster-table.html _includes/forms/bib-roster.html forms/hilo-bib.html
git commit -m "Add print form layout and HL100 bib tracking form

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>"
```

---

## Task 3: Time-based arrival-log form page

**Files:**
- Create: `_includes/forms/time-log.html`
- Create: `forms/hilo-time.html`

**Interfaces:**
- Consumes: `_layouts/form.html` (Task 2) — the layout already includes `forms/time-log.html` when `form_type == 'time'`.
- Produces: `/comms/forms/hilo-time.html` built page.

- [ ] **Step 1: Add the time-log include**

Create `_includes/forms/time-log.html` (a blank 4-column grid — two Time IN / Bib pairs across, tall rows for handwriting, flows across ~2 pages):

```html
<table class="time-log">
  <thead>
    <tr>
      <th>Time IN</th>
      <th>Bib Number</th>
      <th>Time IN</th>
      <th>Bib Number</th>
    </tr>
  </thead>
  <tbody>
    {% for i in (1..48) %}
    <tr>
      <td></td>
      <td></td>
      <td></td>
      <td></td>
    </tr>
    {% endfor %}
  </tbody>
</table>
```

- [ ] **Step 2: Add the time form page**

Create `forms/hilo-time.html`:

```html
---
layout: form
race: hilo
form_type: time
title: High Lonesome 100 — Time Runner Tracking Form
---
```

- [ ] **Step 3: Build and verify the time form renders**

Run: `bundle exec jekyll build`
Expected: `done in N seconds.` with no Liquid errors.

Run: `test -f _site/forms/hilo-time.html && echo EXISTS`
Expected: `EXISTS`

Run: `grep -c 'Direction:' _site/forms/hilo-time.html`
Expected: `1` (direction line shows for time forms only)

Run: `grep -c 'Direction:' _site/forms/hilo-bib.html`
Expected: `0` (bib form has no direction line)

Run: `grep -o '<tr>' _site/forms/hilo-time.html | wc -l`
Expected: `49` (48 body rows + 1 header row)

- [ ] **Step 4: Commit**

```bash
git add _includes/forms/time-log.html forms/hilo-time.html
git commit -m "Add HL100 time-based tracking form

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>"
```

---

## Task 4: Index links and documentation

**Files:**
- Modify: `index.markdown`
- Modify: `CLAUDE.md`

**Interfaces:**
- Consumes: `/comms/forms/hilo-bib.html`, `/comms/forms/hilo-time.html` (Tasks 2–3).

- [ ] **Step 1: Add form links to the index**

In `index.markdown`, immediately after the High Lonesome 100 aid-station list (the line `- [Finish Line](manuals/hilo/finish)`) and before the `## Sawatch Ascent` heading, insert:

```markdown

### Runner Tracking Forms

Printable forms for tracking runners at any aid station. Print, then write in the aid station name.

- [Bib-Based Tracking Form](forms/hilo-bib.html) — pre-printed roster sorted by bib number
- [Time-Based Tracking Form](forms/hilo-time.html) — blank log for recording arrivals in order
```

- [ ] **Step 2: Build and verify the links land in the index**

Run: `bundle exec jekyll build`
Expected: `done in N seconds.`

Run: `grep -c 'forms/hilo-bib.html' _site/index.html`
Expected: `1`

Run: `grep -c 'forms/hilo-time.html' _site/index.html`
Expected: `1`

- [ ] **Step 3: Document the workflow in CLAUDE.md**

In `CLAUDE.md`, add this section immediately before the `## Layout chain` heading:

```markdown
## Runner tracking forms

Printable runner-tracking forms are generated per race from a registration CSV.

- **`scripts/build-roster.rb`** converts an HL100-style registration CSV
  (`Status, Bib, First Name, …`) into `_data/rosters/<race>.yml`. Only
  `Status == "Active"` rows with a non-blank bib are kept; the form shows first
  name only. Regenerate after registration changes:
  `ruby scripts/build-roster.rb <path-to-csv> <race-slug>`
- **`_data/races.yml`** holds each race's display name and year for the form header.
- **`_layouts/form.html`** is a standalone, print-optimized layout (not the
  `manual`/`markdown-body` chain). Form pages under `forms/` set `layout: form`,
  `race:`, and `form_type:` (`bib` or `time`). Bib forms render the roster from
  `_data/rosters/<race>.yml`; all print styling is in `css/forms.css`.
- Add a new race's forms by generating its roster, adding a `_data/races.yml`
  entry, creating `forms/<race>-bib.html` and `forms/<race>-time.html`, and
  linking them from `index.markdown`.
```

- [ ] **Step 4: Commit**

```bash
git add index.markdown CLAUDE.md
git commit -m "Link runner tracking forms from index and document workflow

Co-Authored-By: Claude Opus 4.8 <noreply@anthropic.com>"
```

---

## Final manual verification (for the site owner)

Automated greps confirm content and structure, but print fidelity needs a human eye:

- [ ] Run `bundle exec jekyll serve` and open `http://localhost:4000/comms/forms/hilo-bib.html`.
- [ ] Cmd/Ctrl-P → print preview. Confirm: two roster columns per page, column headers repeat on every page, no row split across a page break, pacer checkboxes present, "New Runners" section at the end, Aid Station write-in line in the header.
- [ ] Open `http://localhost:4000/comms/forms/hilo-time.html`, print-preview, confirm the Direction line and the blank grid across ~2 pages.
- [ ] If the two-column flex layout paginates awkwardly in your browser, the fallback is to drop `.roster-cols { display: flex }` to a single full-width column (more pages, but bulletproof).
