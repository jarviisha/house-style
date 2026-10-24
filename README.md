# house-style

One shape for commits, PRs, branches, workflows, releases and docs across
jarviisha's and taoworklabs' repos. The rules live in
[`skills/house-style/SKILL.md`](skills/house-style/SKILL.md).

## Install the skill (Claude Code, once per machine)

```
claude plugin marketplace add jarviisha/house-style
claude plugin install house-style@house-style
```

Other agents (Codex and others) read the `## House style` section in each
repo's `AGENTS.md`, which links here.

## Apply GitHub settings

Squash merge only, PR title and body as the squash commit, and branches
deleted on merge.

```
scripts/apply-github-settings.sh --dry-run   # show what would change
scripts/apply-github-settings.sh             # apply to every repo in repos.txt
scripts/apply-github-settings.sh owner/repo  # apply to one repo
```

## Adopting in a repo

Add this to the repo's `AGENTS.md`, make `CLAUDE.md` contain only
`@AGENTS.md`, and rename workflows to `ci.yml` / `release.yml` / `deploy.yml`
where they fit:

```markdown
## House style

This repo follows jarviisha/house-style (https://github.com/jarviisha/house-style),
adopted on YYYY-MM-DD in #N. Claude: use the house-style skill.

- Squash merge only. PR title = commit title: `type(scope): summary`.
- PR body is plain text: short paragraphs and `-` bullets, no `##` headings,
  no emoji, no "Generated with" line. It becomes the squash commit body.
- Branches: `type/short-slug`.
- Workflows: ci.yml, release.yml, deploy.yml.
- Releases: tag vX.Y.Z, release title = tag, body = CHANGELOG section.
- Everything in English.

History before YYYY-MM-DD does not follow these rules. Do not copy the style
of older commits, PR bodies, branches or releases, and do not rewrite or
rename them.
```

Design and plan: [`docs/`](docs/).
