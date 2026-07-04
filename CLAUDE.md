# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

A Jekyll static site publishing **Communications / Runner Tracking manuals** for Freestone Endurance races (High Lonesome 100, Sawatch Ascent, Westline Winder). Each aid station gets its own manual, assembled from reusable content "parts" so shared instructions are written once and reused across manuals and races.

## Commands

```bash
bundle install                # install gems (first time / after Gemfile change)
bundle exec jekyll serve      # local dev server with live reload at http://localhost:4000/comms/
bundle exec jekyll build      # build static site into _site/ (gitignored)
```

There is no test/lint suite. Verify changes by running `jekyll serve` and viewing the affected manual. `baseurl` is `/comms`, so local URLs are prefixed with `/comms/`.

## Architecture: composed manuals

A manual is not written top to bottom — it's **declared in front matter and assembled by the `manual` layout**.

- **`manuals/<race>/<aid>.markdown`** — one file per aid station. Front matter drives assembly:
  - `race:` — selects the intro and timeline dataset. Must match a key in `_data/timeline.yaml`, an intro file `_includes/parts/intros/<race>.markdown`, and the layout logic. Current races: `hilo`, `sawatch-ascent`, `westline-winder`.
  - `aids:` — list of aid keys used to render the timeline. Each must exist under that race's `aids`/`course_record`/`cutoffs`/`last_runner` maps in `timeline.yaml`.
  - `parts:` — ordered list of shared content blocks to append. Each name maps to `_includes/parts/<name>.markdown`.
  - The manual's own body markdown (gear lists, aid-specific instructions) renders **between** the timeline and the parts.

- **`_layouts/manual.markdown`** is the assembly engine. For each manual it emits, in order: the title, the race intro (`parts/intros/<race>`), the timeline (`_includes/timeline.html`), the page body, then each item in `parts:`. Every included fragment is captured and passed through `markdownify` because Jekyll does not process markdown inside `{% include %}`.

- **`_includes/parts/*.markdown`** — reusable content (`protocols`, `starlink`, `ost-remote`, `discord`, `iphone-hotspot`, `jetpack`, etc.). Edit a part once and every manual listing it updates. This is the core DRY mechanism — prefer adding/editing a part over duplicating instructions in individual manuals.

- **`_data/timeline.yaml`** — per-race schedule data. `_includes/timeline.html` reads `site.data.timeline[page.race]` and renders each aid in `page.aids`. Note the rendering branches on aid count: **>2 aids** produces a nested/grouped list; **≤2 aids** produces a flat list. An aid uses `cutoffs[aid]` if present, otherwise falls back to `last_runner[aid]`.

- **`index.markdown`** — the landing page; manually maintained links to every manual. Adding a new manual means adding its link here too.

## Layout chain

`manual` → `manual-wrapper` (wraps content in `.markdown-body`) → `default` (HTML shell, github-markdown-css, footer). Site-wide chrome lives in `_layouts/default.html`; `css/style.css` holds custom overrides.

## Adding a new aid-station manual

1. Create `manuals/<race>/<aid>.markdown` with front matter (`layout: manual`, `race`, `title`, `aids`, `parts`) and the aid-specific body.
2. Ensure every key in `aids:` exists in `_data/timeline.yaml` under that race.
3. Ensure every name in `parts:` exists in `_includes/parts/`.
4. Add a link to the manual in `index.markdown`.

## Adding a new race

Create `_data/timeline.yaml` entry, an intro at `_includes/parts/intros/<race>.markdown`, the manual files under `manuals/<race>/`, and index links — all keyed by the same `<race>` slug.
