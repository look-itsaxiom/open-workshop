---
name: project-lifecycle
description: >
  Manage project lifecycle: create new projects, onboard existing repos,
  move projects between active and backlog (cool/reheat), refresh stale
  projects, and archive completed work. This skill should be used when
  the user says "new project", "add a project", "onboard", "bring in a
  repo", "cool", "shelve this", "put this on backlog", "reheat", "bring
  back", "refresh", "archive", or "I'm done with this project".
---

# Project Lifecycle Management

All project data lives in `~/.open-workshop/projects/`.

## Project States

| State | Meaning |
|-------|---------|
| active | On the hot list, gets dashboard attention |
| backlog | Tracked but not actively worked |
| archived | Done or abandoned, kept for reference |

## Creating a New Project

1. Ask the user about their concept (what, why, tech stack, goals)
2. Create the project directory structure:
   ```
   ~/.open-workshop/projects/<project-name>/
   ├── profile.yaml
   ├── status.md
   ├── milestones.yaml
   ├── ledger.yaml
   └── context/
       └── last-briefing.md
   ```
3. Write `profile.yaml` with:
   ```yaml
   name: <project-name>
   description: "<one-line description>"
   path: "<absolute path to project repo>"
   git_remote: <remote url or null>
   tech_stack: [<languages, frameworks, tools>]
   created: <YYYY-MM-DD>
   ```
4. Write initial `status.md` capturing the concept and initial state
5. Work with the user to define milestones in `milestones.yaml`
6. Initialize empty `ledger.yaml` with:
   ```yaml
   entries: []
   summary:
     total_estimated_spend: null
     overall_progress: 0
     roi_ratio: null
   ```
7. Write `context/last-briefing.md` summarizing the project creation
8. Add to `~/.open-workshop/projects/_manifest.yaml` under `active`
9. **Check active limit**: read `~/.open-workshop/config.yaml` `active_project_limit`. If adding this project exceeds the limit, inform the user and suggest either:
   - Moving an existing active project to backlog
   - Adding the new project to backlog instead

## Onboarding an Existing Project

1. Validate the path exists and is accessible
2. Read the project to understand it:
   - README.md or similar docs
   - CLAUDE.md if present
   - `git log --oneline -20` for recent history
   - `git remote -v` for remote info
   - File structure scan for tech stack detection
3. Generate `profile.yaml` from findings
4. Generate initial `status.md` summarizing what was found
5. Ask the user to define milestones (suggest some based on what was found)
6. Initialize `ledger.yaml` with a baseline entry (progress estimated from current state)
7. Write `context/last-briefing.md` with onboarding summary
8. Add to manifest (with active limit check)
9. Note any specialized tools the project uses and mention them as candidates for department creation via R&D

## Cooling a Project (active → backlog)

1. Write a comprehensive `context/last-briefing.md`:
   - What state is the project in?
   - What was last worked on?
   - What's blocking progress?
   - What should happen when this project is reheated?
2. Update `status.md` with cooling note and date
3. Move project from `active` to `backlog` in `_manifest.yaml`

## Reheating a Project (backlog → active)

1. Check active limit — if at capacity, suggest cooling another project first
2. Read `context/last-briefing.md` to understand where things left off
3. Optionally read the actual project repo for current state (git log, file changes since cooling)
4. Update `status.md` with reheat note
5. Move project from `backlog` to `active` in `_manifest.yaml`

## Refreshing a Project

1. Re-read the project repo (same analysis as onboarding step 2)
2. Update `profile.yaml` if tech stack changed
3. Update `status.md` with fresh analysis
4. Reconcile `milestones.yaml` — ask user about any that seem stale
5. Preserve all accounting history in `ledger.yaml`
6. Update `context/last-briefing.md`
7. Do NOT change the project's active/backlog state

## Archiving a Project

1. Write final `context/last-briefing.md` with archive reason
2. Update `status.md` with archive note
3. Move project from `active` or `backlog` to `archived` in `_manifest.yaml`
