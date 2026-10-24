# house-style Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Publish `jarviisha/house-style` (a Claude Code plugin with one skill and a settings script) and open one adoption PR in each of the 5 repos.

**Architecture:** One repo is both marketplace and plugin. The skill holds the conventions. Each target repo gets a short `## House style` section in `AGENTS.md` that points to it. Adoption work happens in fresh clones under `/tmp/house-style-adopt/`, never in the user's working copies.

**Tech Stack:** Markdown, bash, `gh`, GitHub Actions YAML.

**Spec:** `docs/specs/2026-10-23-house-style-design.md`

## Global Constraints

- Everything written into repos is in English: commits, PR titles and bodies, branches, CHANGELOG, AGENTS.md, the skill.
- Commit/PR title: `type(scope): summary`, types `feat fix refactor perf docs test build ci chore style`, `!` for breaking.
- PR body: plain text, short paragraphs and `-` bullets, no `##` headings, no tables, no emoji, no "Generated with" line, no hard wraps mid-sentence. `Co-authored-by:` trailer allowed.
- Branch: `chore/adopt-house-style`, from latest `origin/main`. PR title: `chore: adopt house style`.
- Never push to main, never force-push, never rewrite or rename old commits, tags, or releases.
- Do NOT run the settings script for real, change repo settings, delete branches, or move mmerp's root `.md` files. Each needs the user's yes first.
- Work only in `/tmp/house-style-adopt/<repo>` (fresh `gh repo clone`). `~/development/{darkvoid,codohue}` have unpushed or branch work; don't touch them.
- The `## House style` block is the spec's text verbatim. `#N` is this PR's number; fill it in with a follow-up commit on the same branch once the PR exists.

## Review Focus

- Renamed workflow: a stale reference to the old name (README badge, docs, Makefile, `workflow_run.workflows: [...]`) silently breaks something. Each rename task greps for the old file name and `name:`.
- `release.yml` CHANGELOG extraction for a tag with no matching section must fail the job, not publish an empty Release. Each release.yml task tests a missing version locally.
- CHANGELOG section extraction must stop at the next `## [` heading and not include the link-reference footer.
- `CLAUDE.md` → `@AGENTS.md`: Claude-only content dropped during the merge is lost guidance. The diff must show every removed line reappearing in `AGENTS.md`, or a PR-body note on why it was dropped as duplicate.
- The script run against a repo with an extra merge setting (darkvoid allows rebase) must turn it off, and a second run must change nothing.

---

### Task 1: house-style repo

**Files:**
- Create: `.claude-plugin/marketplace.json` (name `house-style`, owner jarviisha, one plugin `house-style`, `source: "./"`)
- Create: `.claude-plugin/plugin.json` (`{"name": "house-style", "description": …, "version": "0.1.0"}`)
- Create: `skills/house-style/SKILL.md`
- Create: `scripts/apply-github-settings.sh`
- Create: `repos.txt` (5 lines: `jarviisha/onehand`, `jarviisha/docdoc`, `jarviisha/darkvoid`, `jarviisha/codohue`, `taoworklabs/mmerp`)
- Create: `README.md`, `AGENTS.md` (the House style block, without the history paragraph), `CLAUDE.md` (`@AGENTS.md`)

**Interfaces:**
- Produces: skill name `house-style`. Install: `/plugin marketplace add jarviisha/house-style` then `/plugin install house-style@house-style`.
- Produces: `scripts/apply-github-settings.sh [--dry-run] [owner/repo ...]`. With no repos it reads `repos.txt`. It sets `allow_squash_merge=true allow_merge_commit=false allow_rebase_merge=false squash_merge_commit_title=PR_TITLE squash_merge_commit_message=PR_BODY delete_branch_on_merge=true` via `gh api -X PATCH repos/<r>`. `--dry-run` prints current vs. target per repo and changes nothing. Running it again changes nothing.

- [ ] **Step 1: Write SKILL.md.** Frontmatter `name: house-style`, a description that fires on: writing a commit, a PR title or body, naming a branch, cutting a release, editing CHANGELOG, adding or renaming a workflow, editing AGENTS.md/CLAUDE.md. The body has every rule in the spec's "Quy ước" section, in English, with the spec's example PR body. Release rules: check `git tag -l 'v*'`. No tag means none of the CHANGELOG or Release flow applies. Include the exact release steps and the first-release procedure. Add one line: "Ignore the style of history before the repo's house-style adoption date."
- [ ] **Step 2: Write the script.** Use `set -euo pipefail` and bash with `gh` only.
- [ ] **Step 3: Verify.** `shellcheck scripts/apply-github-settings.sh` is clean. `scripts/apply-github-settings.sh --dry-run` prints a diff for all 5 repos, matching the spec's survey table (docdoc shows `PR_BODY` unchanged, darkvoid shows 4 changes, …). `claude plugin validate .` passes, if that subcommand exists. Otherwise check that the JSON parses with `jq`.
- [ ] **Step 4: Commit and publish.** `git init -b main`, then one commit `feat: house style skill, plugin and settings script` that includes `docs/`. Run `gh repo create jarviisha/house-style --public --source . --push`.
- [ ] **Step 5: Install for the user.** Run `claude plugin marketplace add jarviisha/house-style && claude plugin install house-style@house-style` (user scope). Verify that `claude plugin list` shows it.

### Task 2: taoworklabs/mmerp

- [ ] Clone and branch.
- [ ] `git mv CLAUDE.md AGENTS.md`. Drop the "This file provides guidance to Claude Code" line, add the House style block, and create `CLAUDE.md` = `@AGENTS.md`. Grep repo-wide for references to `CLAUDE.md` (for example, in `.claude/` and docs) and point them at `AGENTS.md` where they mean the instructions file.
- [ ] Leave the workflows alone. `ui.yml` is path-filtered to `packages/ui/**`, and folding it into `ci.yml` would lose that filter. (Builder's call per spec: "nếu hợp lý". It isn't.)
- [ ] No CHANGELOG, because there are no tags.
- [ ] Commit `chore: adopt house style`, push, `gh pr create` with a plain-text body. Then fill in `#N` in a second commit and push.

### Task 3: jarviisha/docdoc

- [ ] Add the House style block to `AGENTS.md`. Create `CLAUDE.md` = `@AGENTS.md`.
- [ ] Keep `CHANGELOG.md`. It is actively maintained with `[Unreleased]`, so removing it would throw away written work. (Builder's call: the spec said ask first. Keeping it is the non-destructive default, and the PR body says so.)
- [ ] No `release.yml`, because there are no tags.
- [ ] Commit, push, PR, `#N`.

### Task 4: jarviisha/darkvoid

- [ ] Merge `CLAUDE.md` (161 lines) into `AGENTS.md` (67 lines), deduplicating. `CLAUDE.md` = `@AGENTS.md`. Add the House style block.
- [ ] `git mv .github/workflows/cd.yml .github/workflows/deploy.yml`. Keep `name:` and the trigger. It is deliberately manual `workflow_dispatch`, and the file's own comment explains why it must not fire on tags. Grep for `cd.yml` and `workflows/cd` and fix every hit.
- [ ] Add `CHANGELOG.md` (Keep a Changelog header, `## [Unreleased]`, `## [0.1.0]` with one line "First tagged version; changes before it are not listed.").
- [ ] Add `.github/workflows/release.yml`. On `push: tags: ['v*']`, with `contents: write`, it extracts the `## [X.Y.Z]` section (without the `v`) from `CHANGELOG.md` with awk, fails if the section is empty, then runs `gh release create "$TAG" --title "$TAG" --notes-file notes.md`. It does not build or deploy. Test the awk locally: on `0.1.0` it prints only the 0.1.0 body, and on `9.9.9` it exits non-zero.
- [ ] Commit, push, PR, `#N`.

### Task 5: jarviisha/onehand

- [ ] Check `AGENTS.md` (12 lines) and `CLAUDE.md`. Move the CLAUDE.md content into AGENTS.md and make `CLAUDE.md` = `@AGENTS.md`. Add the House style block.
- [ ] `release.yml`: change `--title "onehand $TAG"` to `--title "$TAG"`. Make `notes.md` the CHANGELOG section for the tag, followed by the existing pre-release/requirements text. Use the same awk and the same fail-on-empty check as Task 4. Keep `--prerelease`. (Builder's call: the requirements text says what CHANGELOG can't, so it stays.)
- [ ] Commit, push, PR, `#N`.

### Task 6: jarviisha/codohue

- [ ] `CLAUDE.md` is already `@AGENTS.md` plus a Claude Code section. Move that section into `AGENTS.md`, so that `CLAUDE.md` = `@AGENTS.md`. Add the House style block.
- [ ] Keep `build.yml`. It builds images on main pushes and on tags, so it is not a release-only job, and its name says what it does. `deploy.yml` already matches.
- [ ] CHANGELOG becomes the full changelog (user chose option a). Rewrite only the intro. It now covers all notable changes, server and wire/SDK, from the next release on. Entries are keyed by the server tag, `## [X.Y.Z] - YYYY-MM-DD`. When the wire/SDK modules move, the entry says so in its first line, e.g. "Wire and SDK: v0.8.0". Rename `## Unreleased` to `## [Unreleased]`. Older `## v0.7.0 — …` headings are wire versions; leave them untouched, and the intro says they are wire versions. Move what the Unreleased section already holds under an `### Added` group if it isn't already in one.
- [ ] Add `release.yml`, the same as Task 4's: on a tag it extracts `## [X.Y.Z]`, fails on empty, and runs `gh release create --title "$TAG"`. It does not touch images, which stay with `build.yml`. Old Releases stay untouched.
- [ ] Commit, push, PR, `#N`.

### Task 7: Report

- [ ] List the 5 PR URLs. Ask the user to approve the next steps: running `scripts/apply-github-settings.sh` for real, deleting merged stale branches (list them with `gh api repos/<r>/branches` cross-checked against merged PR head refs), and moving mmerp's root `.md` files.
