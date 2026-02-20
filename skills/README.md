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
| `.cursor/skills/` | Project-level (Cursor) |
| `.agent/skills/` | Project-level (Antigravity) |
| `.claude/skills/` | Project-level (Claude) |
| `~/.cursor/skills/` | Global |

Copy or symlink any skill folder from here into one of those locations.