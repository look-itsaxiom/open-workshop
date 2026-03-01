# Open Workshop

A Claude Code plugin that turns a single session into a self-organizing AI workshop.

You manage projects. It manages everything else — departments, dispatch, accounting, and the context to make every session productive from the first prompt.

## The Problem

You're juggling multiple projects. Each session starts cold — you re-explain context, re-discover what's blocked, re-orient on priorities. You waste tokens on setup instead of shipping.

## The Solution

Open Workshop gives you a persistent, self-growing studio:

- **Dashboard at startup** — every session opens with your project status, blockers, and next steps
- **Project lifecycle** — track projects from idea to archive with milestones and context that survives across sessions
- **Department dispatch** — spawn specialized agents (engineering, design, R&D) with relevant knowledge and tools
- **Engine offloading** — route tasks to Codex, Gemini, or any external AI CLI when Claude isn't the right tool
- **Cost tracking** — automatic token accounting + milestone-linked ROI so you know what you're getting for your spend
- **Self-growing** — ships with only R&D. You build the departments you actually need.

## Quick Start

### Install

```bash
# Add the marketplace
claude /plugin marketplace add https://raw.githubusercontent.com/look-itsaxiom/open-workshop/main/marketplace.json

# Install the plugin
claude /plugin install open-workshop
```

### First Run

Start a Claude Code session. The plugin detects it's your first time and walks you through setup — no config files to write by hand.

### Commands

| Command | What it does |
|---------|-------------|
| `/status` | Show your workshop dashboard |
| `/focus <project>` | Deep-dive into a specific project |
| `/new-project` | Start a new project from scratch |
| `/onboard <path>` | Bring an existing repo into the workshop |

## How It Works

### Projects

Projects go through a lifecycle: **active** → **backlog** → **archived**. Active projects appear on your dashboard every session. When you shelve a project, it writes a comprehensive briefing so you can pick it back up months later without losing context.

### Departments

Departments are specialist contexts — a knowledge base and a tool catalog that get injected when you dispatch work. R&D is the only department that ships. It's the stem cell: ask it to research a domain, and it'll create a new department for you.

```
"I need an engineering department"
→ R&D researches tools and practices
→ Creates ~/.open-workshop/departments/engineering/
→ Engineering is now available for dispatch
```

### Engine Offloading

Not every task needs Claude. Configure external AI CLIs in `~/.open-workshop/engines.yaml` and the workshop will route appropriate work to them:

```yaml
engines:
  - name: gemini
    command: "gemini -p"
    strengths: ["research", "analysis", "large context"]
    cost: "Free (1000 req/day)"
```

### Accounting

Every piece of work links to a milestone with before/after progress. The `SubagentStop` hook automatically tracks token costs. Together, they answer: "For every dollar spent, how much closer did this project get to shipping?"

## Data

All your data lives in `~/.open-workshop/`. The plugin itself is stateless — reinstall it, update it, whatever. Your projects, departments, and cost history are untouched.

```
~/.open-workshop/
├── config.yaml              # workshop settings
├── projects/                # project tracking data
│   ├── _manifest.yaml       # active/backlog/archived lists
│   └── <project>/           # per-project status, milestones, ledger
├── departments/             # your custom departments
├── engines.yaml             # external AI engine configs
└── cost-log.jsonl           # automatic cost tracking
```

## Origin

Open Workshop was extracted from [Dream Factory](https://github.com/look-itsaxiom/dream-factory), a personal multi-agent software studio that manages 5+ creative projects from a single terminal. The patterns that made Dream Factory productive — persistent context, department dispatch, engine offloading, milestone-linked accounting — were generalized into this distributable plugin.

## License

MIT
