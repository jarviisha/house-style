---
name: house-style
description: jarviisha's conventions for commits, PR titles and bodies, branch names, workflow files, releases, CHANGELOG and AGENTS.md/CLAUDE.md. Use whenever writing a commit message, opening or editing a PR, naming a branch, cutting a release or tag, editing CHANGELOG.md, adding or renaming a GitHub Actions workflow, or editing AGENTS.md or CLAUDE.md in any jarviisha or taoworklabs repo.
---

# House style

One shape for every repo. Simple beats thorough. Everything written into a
repo is in English.

Ignore the style of history from before the repo adopted house style (the
date is in its `AGENTS.md`). Do not copy older commits, PR bodies, branch
names or releases, and do not rewrite or rename them.

## Commits and PRs

PRs are squash-merged. The PR title becomes the commit title, and GitHub
appends ` (#N)`. The PR body becomes the commit body, so it has to read well
both on the web and in `git log`.

Title: `type(scope): summary`
- `type`: `feat fix refactor perf docs test build ci chore style`
- `!` after the type or scope for a breaking change: `feat(api)!: …`
- `scope` is optional. Use a module or area name.
- The summary is short, lowercase after the colon, with no trailing period.
  Aim for under 72 characters.

PR body:
- Plain text. Short paragraphs and `-` bullets.
- No `##` headings, no tables, no emoji, no "Generated with" line, no
  horizontal rules.
- One idea per line. Don't hard-wrap in the middle of a sentence.
- Backticks for file names and commands are fine.
- Say what changed and why, plus anything a reader must do: a migration, a
  reset, a new env var. Link related PRs as `#N`.
- A `Co-authored-by:` trailer is fine.

Example:

```
Squash the 44 migrations into one baseline.

- 0001–0044 become 20261023000000_all_baseline.sql
- pg_dump of a fresh and an old database are identical
- existing dev databases need make reset-db

Builds on #130.
```

A commit made directly on main uses the same title form. Its body can be
as long as it needs, in plain text.

## Branches

- `type/short-slug`, with the same types as commits: `feat/console-shadcn`,
  `fix/feed-cursor`.
- No numbered branches (`001-…`). An issue number is optional.
- Branches that onehand creates (`onehand/issue-N-…`) are fine as they are.

## Workflows

Files in `.github/workflows/`:
- `ci.yml`: lint, test, build. Runs on PRs and pushes to main. Every repo
  has one.
- `release.yml`: runs on `v*` tags and creates the GitHub Release. Only in
  repos that release.
- `deploy.yml`: only in repos that deploy.
- Any other workflow is named for the one thing it does (`build.yml`,
  `ui.yml`).

## Releases

Check `git tag -l 'v*'` first.

**No tags yet:** there is no CHANGELOG upkeep, no `release.yml` and no
Release. `git log` on main is the history. Don't add `[Unreleased]` entries.
If a CHANGELOG already exists and is kept up to date, keep updating it.

**Tags exist:**
- SemVer tags `vX.Y.Z`. While on `0.x`, a breaking change bumps the minor
  version and anything else bumps the patch.
- `CHANGELOG.md` follows Keep a Changelog: `## [Unreleased]` at the top, then
  `## [X.Y.Z] - YYYY-MM-DD`, grouped under `### Added / Changed / Fixed /
  Removed`. Write for the people who use the software, not as a copy of the
  commits. Add to `[Unreleased]` in the same PR as the change.
- Release title = the tag (`v0.13.0`). Release body = that version's
  CHANGELOG section, which `release.yml` extracts. A repo may append fixed
  notes after it, such as install requirements.

Cutting a release:
1. Rename `## [Unreleased]` to `## [X.Y.Z] - YYYY-MM-DD` and add a fresh
   empty `## [Unreleased]` above it.
2. Commit `chore(release): vX.Y.Z`.
3. Run `git tag vX.Y.Z` and push the commit and the tag. `release.yml` does
   the rest.

First release: write `CHANGELOG.md` from `git log` up to now, starting at
`## [0.1.0]` (or whatever version fits), add `release.yml`, then cut the
release as above.

## AGENTS.md and CLAUDE.md

- `AGENTS.md` holds the instructions for every agent.
- `CLAUDE.md` contains only `@AGENTS.md`.
- `README.md` says what the repo is, how to run it, and links into `docs/`.
- Everything else goes in `docs/`: ADRs, designs, plans. Don't add loose
  `.md` files at the repo root.
- Ask before moving existing root files: other docs and tools may depend on
  where they are.
- `AGENTS.md` has a `## House style` section that points here.
