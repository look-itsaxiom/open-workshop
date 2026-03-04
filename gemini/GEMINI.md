# Open Workshop — Gemini CLI Edition

This extension provides a Gemini-compatible version of the Open Workshop plugin.
It shares the **same data model** in `~/.open-workshop/` so workshop state is
persistent across Claude, Codex, and Gemini CLI.

## Core Capabilities

- **Project Portfolio Management**: Track project lifecycle (new, onboard, cool, reheat, archive).
- **Department Dispatch**: Work with specialized departments (R&D, accounting, etc.).
- **Engine Offloading**: Offload tasks to external AI CLIs via `engine-dispatch`.
- **ROI Tracking**: Log spend and progress to calculate project efficiency.
- **Workshop Dashboard**: Get a high-level overview of all active and backlog projects.

## Available Agent Skills

Use `activate_skill` for the following workflows:
- `workshop-dashboard`: Session overview.
- `project-lifecycle`: Manage project states.
- `department-dispatch`: Specialist work.
- `engine-dispatch`: Offload to external engines.
- `accounting`: Log spend and progress.
- `research`: Create/manage departments.
- `setup-wizard`: Initial configuration.

## Custom Commands

- `/dashboard`: Quick view of workshop status.
- `/new-project`: Start a new project.
- `/onboard`: Bring an existing project into the workshop.
- `/focus`: Set the current project context.

## Shared Data Location

All state lives at `~/.open-workshop/` and is compatible across all supported CLIs.

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
