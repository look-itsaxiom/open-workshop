# Open Workshop

Open Workshop is a Claude Code plugin that turns a single session into a self-organizing AI workshop. It manages projects, dispatches work to departments, offloads tasks to external AI engines, and tracks ROI.

## How It Works

- **Plugin code** lives here (read-only after installation)
- **User data** lives at `~/.open-workshop/` (projects, departments, config, cost logs)
- **SessionStart hook** detects first run and injects dashboard context every session

## Conventions

### Data paths

All mutable state lives in `~/.open-workshop/`. The plugin directory is read-only. Never write to `${CLAUDE_PLUGIN_ROOT}` — always write to `~/.open-workshop/`.

### Departments are additive

Department tool catalogs (`~/.open-workshop/departments/<name>/tools.yaml`) are reference documents listing specialized tools. They are extensions, never restrictions. Teammates always retain full Claude Code capabilities.

### File format conventions

- YAML for structured data (config, manifests, profiles, milestones, ledgers, engine configs)
- Markdown for narrative data (status updates, knowledge bases, briefings, skills)

### R&D is the stem cell

Research & Development is the only department that ships with the plugin. All other departments are created by the user via R&D. This keeps the workshop personal and relevant to each user's work.
