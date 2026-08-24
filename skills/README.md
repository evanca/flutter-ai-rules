# Skills

Each subdirectory is a self-contained **Agent Skill** — a portable package of knowledge that AI agents (Cursor, Antigravity, etc.) can discover and apply automatically when relevant.

## Standard

Skills follow the open [Agent Skills](https://agentskills.io) standard. Each skill folder contains a `SKILL.md` file with YAML frontmatter and instructions. Optional subdirectories (`scripts/`, `references/`, `assets/`) can hold supporting resources.

```
skills/
└── my-skill/
    ├── SKILL.md          # required
    ├── scripts/          # optional — executable helpers
    ├── references/       # optional — extra docs, loaded on demand
    └── assets/           # optional — templates, config files
```

## Where to place skills

| Location | Scope |
|---|---|
| `.claude/skills/` | Project (Claude Code) |
| `.codex/skills/` | Project (Codex) |
| `.agents/skills/` | Project (Antigravity, Codex — `.agent/skills/` still works) |
| `.cursor/skills/` | Project (Cursor) |
| `.windsurf/skills/` | Project (Windsurf) |
| `~/.claude/skills/` | Global (Claude Code) |
| `~/.codex/skills/` | Global (Codex) |
| `~/.gemini/config/skills/` | Global (Antigravity) |
| `~/.cursor/skills/` | Global (Cursor) |

Copy or symlink any skill folder from here into one of those locations.

## Installing the whole set as a plugin

The repository root doubles as a plugin, so `skills/` can be installed and updated in one step:

- **Claude Code** — `.claude-plugin/marketplace.json` and `.claude-plugin/plugin.json`; add with `/plugin marketplace add evanca/flutter-ai-rules`.
- **Codex** — `.codex-plugin/plugin.json`, listed in `.agents/plugins/marketplace.json`.
- **Cursor** — `.cursor-plugin/marketplace.json` and `.cursor-plugin/plugin.json`; import the repo URL as a team marketplace, or run `/add-plugin` in Cursor.
- **Antigravity** — `plugin.json` at the repository root; install a clone with `agy plugin install <path>`.
- **Windsurf / Devin** — no manifest; Cascade scans `.agents/skills/` and `~/.agents/skills/` directly.
- **GitHub Copilot** — no `SKILL.md` support; use [`rules/`](../rules) or [`combined/`](../combined) as `.github/copilot-instructions.md` or `.github/instructions/*.instructions.md`.

See the [main README](../README.md#install-as-a-plugin) for the commands.