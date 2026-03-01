---
name: setup-wizard
description: >
  Guide first-run setup for Open Workshop. Creates the data directory,
  config, and seed department. This skill should be used when the
  SessionStart hook detects no config at ~/.open-workshop/config.yaml,
  or when the user says "setup", "configure workshop", "reset workshop",
  or "run setup again".
---

# Setup Wizard

## When to Use

- Triggered automatically on first run (SessionStart hook detects missing config)
- When user wants to reconfigure: "reset workshop", "run setup again"

## The Process

Ask questions **one at a time**. For each question, explain **why** you're asking and **how** the answer will be used.

### Question 1: Workshop Name

> **Why I'm asking:** This name appears in your dashboard header every session. It's cosmetic — pick something that motivates you, or just keep the default.

- Default: "My Workshop"
- Stored as `workshop_name` in config.yaml

### Question 2: Active Project Limit

> **Why I'm asking:** Active projects appear on your dashboard at session start. Each one adds context tokens. More projects = broader awareness but higher token cost per session. You can always change this later in `~/.open-workshop/config.yaml`.

- Default: 5
- Range: 1-10
- Stored as `active_project_limit` in config.yaml

### Question 3: Execution Mode

> **Why I'm asking:** When the workshop dispatches work to a department, it can use two different approaches:
> - **Sub-agents** (recommended): Uses Claude's built-in Agent tool. Cheap, reliable, one agent at a time. Good for most work.
> - **Agent Teams**: Spawns multiple agents that coordinate via shared task lists. ~7x more expensive but enables true parallel work. Requires experimental feature flag.
>
> Most users should start with sub-agents. You can switch anytime.

- Options: "sub-agents" (default), "agent-teams"
- If agent-teams: check for `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS=1` and guide setup if missing
- Stored as `execution_mode` in config.yaml

### Question 4: External Engines (Optional)

> **Why I'm asking:** If you have other AI CLIs installed (like OpenAI's Codex or Google's Gemini CLI), the workshop can offload tasks to them to save your Claude Code tokens. This is completely optional — you can set it up later too.

- Auto-detect: run `which codex` and `which gemini` (and any other common AI CLIs)
- For each detected engine, confirm the user wants to enable it
- Allow user to add custom engines (name + command)
- Allow user to skip entirely
- Stored in `~/.open-workshop/engines.yaml`

## What to Create

After all questions are answered, create these files:

### `~/.open-workshop/config.yaml`

```yaml
# Open Workshop configuration
workshop_name: "<answer>"
active_project_limit: <answer>
execution_mode: <answer>  # sub-agents or agent-teams
default_teammate_model: sonnet
```

### `~/.open-workshop/projects/_manifest.yaml`

```yaml
# Open Workshop — Project Registry
active: []
backlog: []
archived: []
```

### `~/.open-workshop/departments/research-and-development/`

Copy from the plugin's seed directory:
- `${CLAUDE_PLUGIN_ROOT}/seed/departments/research-and-development/knowledge.md` → `~/.open-workshop/departments/research-and-development/knowledge.md`
- `${CLAUDE_PLUGIN_ROOT}/seed/departments/research-and-development/tools.yaml` → `~/.open-workshop/departments/research-and-development/tools.yaml`

### `~/.open-workshop/engines.yaml`

If engines were detected/configured:

```yaml
engines:
  - name: <engine-name>
    command: "<command template>"
    strengths: [<tags>]
    cost: "<cost description>"
    notes: "<usage notes>"
```

If no engines configured:

```yaml
# External AI engines for task offloading
# Add engines here to let the workshop dispatch work to other AI CLIs.
# Example:
#   engines:
#     - name: gemini
#       command: "gemini -p"
#       strengths: ["research", "analysis", "large context"]
#       cost: "Free (1000 req/day)"
#       notes: "1M token context window"
engines: []
```

## Post-Setup Guidance

After creating all files, tell the user:

```
Your workshop is ready! Here's how to get started:

- `/onboard <path>` — Bring an existing project into the workshop
- `/new-project` — Start a new project from scratch
- Your R&D department is ready — ask it to research tools, evaluate
  approaches, or build new departments for your work

The workshop grows with you. R&D is your only department right now.
When you need specialists (engineering, design, testing...), R&D can
research and create them.
```

Then present the (empty) dashboard using the workshop-dashboard skill.
