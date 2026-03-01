# Open Workshop

A Claude Code plugin that turns a single session into a self-organizing AI workshop.

## What It Does

- **Project Portfolio** — Track multiple projects with status, milestones, and accounting
- **Department Dispatch** — Spawn specialized agents for engineering, design, R&D, or any domain you define
- **Engine Offloading** — Route tasks to Codex, Gemini, or any external AI CLI to save tokens
- **Cost Tracking** — Automatic token accounting + milestone-linked ROI analysis
- **Self-Growing** — Ships with only R&D. You build the departments you need.

## Installation

```bash
# Add the marketplace
claude /plugin marketplace add https://raw.githubusercontent.com/cskibeness/open-workshop/main/marketplace.json

# Install the plugin
claude /plugin install open-workshop
```

## First Run

Start a Claude Code session. The plugin detects it's your first time and walks you through setup:

1. Name your workshop
2. Set active project limit
3. Choose execution mode (sub-agents or agent teams)
4. Detect available external AI engines

## Usage

### Commands

| Command | Description |
|---------|-------------|
| `/status` | Show the workshop dashboard |
| `/focus <project>` | Deep-dive into a specific project |
| `/new-project [name]` | Create a new project from scratch |
| `/onboard <path>` | Bring an existing repo into the workshop |

### Key Concepts

**Projects** go through a lifecycle: active → backlog → archived. Active projects appear on your dashboard. Backlog projects are tracked but quiet.

**Departments** are specialist contexts with knowledge bases and tool catalogs. R&D ships built-in; it can research and create any department you need.

**Engines** are external AI CLIs that your workshop can delegate work to. Configure them in `~/.open-workshop/engines.yaml`.

**Accounting** tracks what you spend and what you ship. Every task links to a milestone with before/after progress, giving you ROI per project.

## Data Location

All your data lives in `~/.open-workshop/`. The plugin itself is stateless — you can reinstall it without losing anything.

```
~/.open-workshop/
├── config.yaml              # workshop settings
├── projects/                # project tracking data
├── departments/             # your custom departments
├── engines.yaml             # external AI engine configs
└── cost-log.jsonl           # automatic cost tracking
```

## License

MIT
