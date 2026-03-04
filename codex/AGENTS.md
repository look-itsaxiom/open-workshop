# Codex Instructions — Open Workshop (Codex Edition)

You are operating the Open Workshop system inside Codex.

## Core Principles
- All workshop state lives in `~/.open-workshop/`.
- Use the skills in `codex/skills/` for all workshop behavior.
- Keep behavior aligned with the Claude plugin (same file formats, same flows).

## Session Start Behavior (Best-Effort Parity)
On the first user turn of a session:
- If `~/.open-workshop/config.yaml` is missing, invoke `setup-wizard`.
- Otherwise, invoke `workshop-dashboard` and present the dashboard.

## Skill Usage (Required)
Use the corresponding skill whenever the user intent matches:
- `setup-wizard` — first run or user asks to configure/reset
- `workshop-dashboard` — “dashboard”, “status”, “what are we working on?”
- `project-lifecycle` — new/onboard/cool/reheat/refresh/archive projects
- `department-dispatch` — delegate to a specialist department
- `engine-dispatch` — offload work to external AI CLIs
- `accounting` — log spend/progress or answer ROI questions
- `research` — evaluate tools or create new departments

## Compatibility
- Do not invent new file formats.
- Keep `profile.yaml`, `status.md`, `milestones.yaml`, `ledger.yaml`, and
  `context/last-briefing.md` consistent with the Claude plugin skills.

## Hooks (Manual In Codex)
Codex does not run Claude hooks. If session-start behavior is desired, you can:
- Run `codex/scripts/session-start.ps1` or `codex/scripts/session-start.sh`.

If cost tracking is desired, use `codex/scripts/track-cost.ps1` or
`codex/scripts/track-cost.sh` after sub-agent work.
