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
- When upgrading an existing workshop that lacks the local plugin (SessionStart hook detects missing `.claude-plugin/plugin.json`)

## Upgrade Detection

Before asking questions, check if this is an upgrade (existing config, missing local plugin):

```bash
# Existing workshop?
test -f ~/.open-workshop/config.yaml

# Missing local plugin?
test ! -f ~/.open-workshop/.claude-plugin/plugin.json
```

**If both are true**, this is an upgrade. Skip Questions 1-4 (answers already exist in config.yaml) and:

1. Tell the user: "Your workshop is being upgraded to support auto-triggering skills. I just need to ask a couple of new questions."
2. Ask only **Question 5** (Git Backing) and **Question 6** (Dispatch Preferences)
3. Add the new config fields (`default_dispatch_mode`, `preferred_terminal`, `local_plugin_installed`) to the existing `config.yaml` — don't overwrite it
4. Create the **Local Plugin Bootstrap** files (`.claude-plugin/plugin.json`, `.claude-plugin/marketplace.json`, `skills/` directory)
5. Run the plugin registration steps
6. If git backing was chosen and `~/.open-workshop/.git` doesn't exist, run `git init`
7. Tell the user: "Upgrade complete. Your workshop now supports R&D-compiled skills. Use `/compile-findings all` to convert your existing research into auto-triggering skills."

**If config doesn't exist**, proceed with the full setup below.

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

### Question 5: Git Backing (Optional)

> **Why I'm asking:** Version-controlling your workshop data (`~/.open-workshop/`) lets you track changes to projects, departments, and config over time. It also makes it easy to sync across machines. This is completely optional — you can always `git init` later.

- Ask: "Would you like to git-init your workshop data directory?"
- If yes: run `git init ~/.open-workshop` after all files are created
- Default: no
- No config entry needed (presence of `.git/` is self-documenting)

### Question 6: Dispatch Preferences

> **Why I'm asking:** When the workshop dispatches work, it picks a strategy for how to run it. You can set a default here so it doesn't ask every time.
> - **smart** (default): The workshop picks the best mode per task — sub-agent for simple work, agent-team for complex parallel work, terminal for quick shell tasks.
> - **sub-agents**: Always use a single sub-agent. Predictable and cheap.
> - **agent-teams**: Always use coordinated agent teams. Expensive but powerful.
> - **terminal**: Always shell out to an external AI CLI (requires engines configured in Question 4).

- Options: "smart" (default), "sub-agents", "agent-teams", "terminal"
- If "terminal" is selected and no engines were configured in Q4, warn the user and suggest configuring engines first or picking a different default
- Stored as `default_dispatch_mode` in config.yaml
- Also ask: "Do you have a preferred terminal emulator command?" (e.g., `wt` for Windows Terminal, `gnome-terminal`, or leave blank for default)
- Stored as `preferred_terminal` in config.yaml (empty string if none)

## What to Create

After all questions are answered, create these files:

### `~/.open-workshop/config.yaml`

```yaml
# Open Workshop configuration
workshop_name: "<answer>"
active_project_limit: <answer>
execution_mode: <answer>  # sub-agents or agent-teams
default_dispatch_mode: <answer>  # smart, sub-agents, agent-teams, or terminal
preferred_terminal: null          # null = ask on first use
default_teammate_model: sonnet
local_plugin_installed: false    # set to true after plugin registration
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

### Local Plugin Bootstrap

Create the following so that `~/.open-workshop/` itself acts as a Claude Code plugin, allowing R&D-generated skills to be auto-discovered:

#### `~/.open-workshop/.claude-plugin/plugin.json`

```json
{
  "name": "open-workshop-local",
  "description": "Learned capabilities from workshop R&D",
  "version": "0.1.0"
}
```

#### `~/.open-workshop/skills/` (empty directory)

Create this directory so R&D has a place to write generated skills. The local plugin will automatically discover any `SKILL.md` files placed here.

#### `~/.open-workshop/.claude-plugin/marketplace.json`

```json
{
  "name": "open-workshop-local-marketplace",
  "owner": {
    "name": "Open Workshop"
  },
  "plugins": [
    {
      "name": "open-workshop-local",
      "source": ".",
      "description": "Learned capabilities from workshop R&D"
    }
  ]
}
```

#### Register the local plugin

After all files are created, run these commands to register and install:

1. `/plugin marketplace add ~/.open-workshop`
2. `/plugin install open-workshop-local@open-workshop-local-marketplace`

After successful registration, set `local_plugin_installed: true` in config.yaml.

### Git Init (if requested)

If the user opted in at Question 5, run `git init ~/.open-workshop` now (after all files exist), then stage and commit:

```
cd ~/.open-workshop && git init && git add -A && git commit -m "workshop: initial setup"
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
