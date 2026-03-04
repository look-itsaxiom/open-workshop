# Open Workshop — Codex Edition

This directory provides a Codex-compatible version of the Open Workshop plugin.
It keeps the **same data model** in `~/.open-workshop/` so workshop state is
shared across Claude and Codex.

## What’s Included

- `skills/` — Codex skills mirroring the Claude plugin behavior
- `.agents/skills/` — Same skills, placed where Codex auto-discovers them
- `seed/` — R&D seed department assets used by the setup wizard
- `hooks/` — Original hook scripts (manual use in Codex)
- `scripts/` — Helper scripts to approximate Claude hook behavior

## How To Use In Codex

1. Start Codex in the `codex/` directory (so `.agents/skills` and `AGENTS.md`
   are auto-loaded).
2. Run the setup wizard if `~/.open-workshop/config.yaml` does not exist:
   - Invoke the `setup-wizard` skill.
3. Use skills directly:
   - `workshop-dashboard` for a session overview
   - `project-lifecycle` for new/onboard/cool/reheat/archive
   - `department-dispatch` for specialist work
   - `engine-dispatch` to offload to external AI CLIs
   - `accounting` to log spend and progress
   - `research` to create new departments

## Manual Hooks (Optional)

Codex doesn’t support Claude-style hooks. If you want the same behavior:

- Session start dashboard:
  - `pwsh codex/scripts/session-start.ps1` (Windows)
  - `bash codex/scripts/session-start.sh` (macOS/Linux)
  - Then ask Codex to run `workshop-dashboard`.

- Cost tracking (after sub-agent work):
  - `pwsh codex/scripts/track-cost.ps1 -TranscriptPath <path>`
  - `bash codex/scripts/track-cost.sh <path>`

## Shared Data Location

All state lives at `~/.open-workshop/` and is compatible across Claude and Codex.

```
~/.open-workshop/
├── config.yaml
├── projects/
│   ├── _manifest.yaml
│   └── <project>/
├── departments/
├── engines.yaml
└── cost-log.jsonl
```
