---
name: department-dispatch
description: >
  Dispatch work to department specialists or external tools. This skill
  triggers whenever work needs to be executed — engineering tasks, research,
  art generation, or any delegatable work. Use when the user requests work
  on a project, says "do this", "build", "fix", "implement", "research",
  "generate", or any task that should be dispatched to a specialist.
  Also use when the user says "send this to engineering", "dispatch to R&D",
  "spawn a teammate", "delegate this task", or "get someone working on this".
---

# Department Dispatch

## Dispatch Flow

Every work request follows this flow:

### 1. Check for Matching Skills

Before dispatching, check if `~/.open-workshop/skills/` exists and scan for auto-triggering skills that match the task. These are R&D-compiled capabilities.

- If the skills directory doesn't exist or is empty, skip this step and proceed to department dispatch.
- If one skill clearly matches, use it and tell the user.
- If multiple skills match and intent is ambiguous, ask: "I found skills for X and Y. Which applies here?"
- If complementary skills match (e.g., generation + post-processing), compose them.
- If no skills match, proceed with department dispatch.

### 2. Identify the Department

Read `~/.open-workshop/departments/` to discover available departments. Each has:
- `knowledge.md` — persistent lessons and patterns
- `tools.yaml` — catalog of specialized tools (additive, never restrictive)

### 3. Recommend Execution Mode

Read `~/.open-workshop/config.yaml` for `default_dispatch_mode` and `preferred_terminal`.

| Signal | Recommendation |
|--------|---------------|
| Single focused task | Sub-agent |
| 2+ independent tasks, no shared state | Agent teams |
| User wants to observe, long-running, interactive | New terminal |
| Config has a non-smart default set | Start with that |

If `default_dispatch_mode` is `smart`, pick the best mode and present it:
"I'll dispatch this as a **sub-agent**. Or would you prefer **agent teams** / **new terminal**?"

If the user has a non-smart default, use it but suggest an alternative when the task shape is a poor fit:
"Your default is sub-agents, but this has 3 independent tasks — agent teams might be faster. Want to switch?"

### 4. Execute

#### Sub-Agent Mode

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

LEARNED SKILLS:
- Check ~/.open-workshop/skills/ for compiled R&D skills relevant to your task
- These contain actionable instructions from prior research

TASK:
[Specific task description]

WHEN DONE:
1. Update ~/.open-workshop/projects/[name]/status.md with what you accomplished
2. Update ~/.open-workshop/projects/[name]/context/last-briefing.md
3. Log your work in ~/.open-workshop/projects/[name]/ledger.yaml
```

If external engines are configured, add:

```
EXTERNAL ENGINES (save tokens):
Check ~/.open-workshop/engines.yaml for available engines and their strengths.
Always cd to the project root first. Always review output before committing.
```

#### Agent Teams Mode

Verify `CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS` is set to `1`. If not, guide setup:

```json
// Add to ~/.claude/settings.json:
{
  "env": {
    "CLAUDE_CODE_EXPERIMENTAL_AGENT_TEAMS": "1"
  }
}
```

Use TeamCreate, then spawn teammates with the same prompt structure plus team coordination. Use TaskCreate for multiple tasks.

#### New Terminal Mode

1. Read `preferred_terminal` from config. If null, detect and ask:
   - Check for `wt.exe` (Windows Terminal)
   - Check for VS Code (`code` command)
   - Check for other terminals
   - Ask: "Which terminal should I use? (I can save your preference)"
   - If user wants to save: write `preferred_terminal: <choice>` to config.yaml

2. Open the terminal at the project's repo path:
   - **Windows Terminal**: `wt.exe -w 0 nt -d "<project-path>"`
   - **VS Code**: `code "<project-path>" --new-window`
   - **cmd**: `start cmd /k "cd /d <project-path>"`

3. Ask if they want Claude launched in that terminal:
   - If yes: append `&& claude` (or equivalent) to the terminal command
   - Optionally pass task context: `claude --prompt "<task summary>"`

## Multiple Departments

If work requires multiple departments:
- Spawn each department separately
- Ensure they work on different files to avoid conflicts
- The lead coordinates handoffs

## Lightweight Tasks (Skip Dispatch)

For quick tasks that don't justify a specialist:
- Simple file reads or status checks
- Quick edits to workshop state files
- Questions answerable from existing context

Handle directly without dispatching.

## When Specialists Finish

1. Read the status update in `~/.open-workshop/projects/[name]/status.md`
2. Check the ledger entry in `~/.open-workshop/projects/[name]/ledger.yaml`
3. Present a summary to the user
4. Ask: continue with more work, or switch focus?
