---
name: workshop-dashboard
description: >
  Display the workshop dashboard showing active project status,
  backlog summary, and accounting snapshots. This skill should be used
  when starting a session, when the user says "show dashboard", "project
  status", "what are we working on", "workshop overview", "show me my
  projects", or when returning from focused work on a single project.
---

# Workshop Dashboard

## When to Use

- At session start (triggered by SessionStart hook context)
- When user asks for status across projects
- When returning from focused work on a specific project

## How to Display

### Reading Project Data

1. Read `~/.open-workshop/config.yaml` for `active_project_limit` and `workshop_name`
2. Read `~/.open-workshop/projects/_manifest.yaml` for the project list
3. For each **active** project, read `~/.open-workshop/projects/<name>/status.md`
4. For each **active** project with a ledger, read the `summary` section of `~/.open-workshop/projects/<name>/ledger.yaml`

Do NOT read backlog project details unless the user asks. Do NOT read project repos on startup.

### Dashboard Format

Present using this structure:

```
═══════════════════════════════════════════════════
  [WORKSHOP NAME] — Dashboard
═══════════════════════════════════════════════════

ACTIVE PROJECTS (N/limit)
───────────────────────────────────────────────────
◆ Project Name
  Description from profile
  Status: [current state summary]
  Last: [last completed work]
  Next: [what's needed next]
  Blockers: [any blockers, or "None"]
  Progress: [overall %] | Spend: [$X.XX est.]
───────────────────────────────────────────────────
◆ Another Project
  ...

BACKLOG (N projects)
───────────────────────────────────────────────────
  · project-name (last touched: YYYY-MM-DD)
  · another-project (last touched: YYYY-MM-DD)

═══════════════════════════════════════════════════
What are we working on today?
═══════════════════════════════════════════════════
```

If there are no active projects, show:

```
═══════════════════════════════════════════════════
  [WORKSHOP NAME] — Dashboard
═══════════════════════════════════════════════════

No active projects yet.

Get started:
  /onboard <path>  — Bring in an existing project
  /new-project      — Start something new

═══════════════════════════════════════════════════
```

### Key Principles

- **Lightweight on startup** — only read status.md and ledger summary, never deep-dive into repos
- **Token-conscious** — backlog projects get one line each
- **Actionable** — highlight blockers and next actions prominently
- **Invite direction** — always end with a prompt for what to work on
