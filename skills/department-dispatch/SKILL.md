---
name: department-dispatch
description: >
  Dispatch work to department specialists. This skill should be used
  when the user says "send this to engineering", "dispatch to R&D",
  "spawn a teammate", "have engineering work on this", "delegate this
  task", "get someone working on this", or when the lead needs to fan
  out work to a department.
---

# Department Dispatch

## How It Works

The workshop dispatches work to department specialists using the execution mode configured in `~/.open-workshop/config.yaml`:

- **sub-agents** (default): Uses the Agent tool. One agent per dispatch, cheap and reliable.
- **agent-teams**: Uses TeamCreate for multi-agent coordination. ~7x more expensive but enables parallel work with shared task lists.

## Before Dispatching

### 1. Identify the Department

Read `~/.open-workshop/departments/` to discover available departments. Each has:
- `knowledge.md` — persistent lessons and patterns
- `tools.yaml` — catalog of specialized tools (additive, never restrictive)

### 2. Check Execution Mode

Read `~/.open-workshop/config.yaml` for `execution_mode`.

## Sub-Agent Mode (Default)

Use the Agent tool with `subagent_type: "general-purpose"` and a detailed prompt:

```
You are a [department name] specialist for this workshop.

PROJECT CONTEXT:
- Project: [name]
- Workshop data: ~/.open-workshop/projects/[name]/
- Project repo: [absolute path from profile.yaml]

YOUR DEPARTMENT:
- Read your knowledge base at: ~/.open-workshop/departments/[dept]/knowledge.md
- Read your tool catalog at: ~/.open-workshop/departments/[dept]/tools.yaml

TASK:
[Specific task description]

WHEN DONE:
1. Update ~/.open-workshop/projects/[name]/status.md with what you accomplished
2. Update ~/.open-workshop/projects/[name]/context/last-briefing.md
3. Log your work in ~/.open-workshop/projects/[name]/ledger.yaml:
   - date, department, task description
   - milestone_impact (which milestone, progress before/after)
   - Estimate your token usage if possible
```

If external engines are configured, add this to the prompt:

```
EXTERNAL ENGINES (save tokens):
You can offload sub-tasks to external AI tools. Check ~/.open-workshop/engines.yaml
for available engines and their strengths. Always review output before committing.
```

## Agent Teams Mode

### Prerequisites

Verify `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` is set to `1` in the environment or `~/.claude/settings.json`. If not found, guide the user:

```json
// Add to ~/.claude/settings.json:
{
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  }
}
```

### Spawning

Use TeamCreate to create a team, then spawn teammates with the Agent tool (including `team_name` and `name` parameters). Each teammate gets the same prompt structure as sub-agent mode, plus team coordination instructions.

### Task Assignment

For multiple tasks, use TaskCreate to build a shared task list. Teammates claim tasks via TaskUpdate.

For a single focused task, include it directly in the spawn prompt.

## Multiple Departments

If work requires multiple departments:
- Spawn each department separately
- Ensure they work on different files to avoid conflicts
- The lead coordinates handoffs

## Lightweight Tasks (Skip Dispatch)

For quick tasks that don't justify a full specialist:
- Simple file reads or status checks
- Quick edits to workshop state files
- Questions answerable from existing context

Use the Agent tool directly with a focused prompt.

## When Specialists Finish

1. Read the status update in `~/.open-workshop/projects/[name]/status.md`
2. Check the ledger entry in `~/.open-workshop/projects/[name]/ledger.yaml`
3. Present a summary to the user
4. Ask: continue with more work, or switch focus?
