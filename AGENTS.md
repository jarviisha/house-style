# AGENTS.md

This repo holds jarviisha's house style: a Claude Code plugin with one skill
(`skills/house-style/SKILL.md`) and a script that applies GitHub merge
settings (`scripts/apply-github-settings.sh`).

## House style

This repo follows its own rules. Claude: use the house-style skill.

- Squash merge only. PR title = commit title: `type(scope): summary`.
- PR body is plain text: short paragraphs and `-` bullets, no `##` headings,
  no emoji, no "Generated with" line. It becomes the squash commit body.
- Branches: `type/short-slug`.
- Releases: tag vX.Y.Z, release title = tag, body = CHANGELOG section.
- Everything in English.

When a rule changes, change it in `SKILL.md`, the summary in `README.md`, and
the plugin version in both `.claude-plugin/*.json`.
