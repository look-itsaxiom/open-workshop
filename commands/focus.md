---
name: focus
description: Focus on a specific project, loading its context for deeper work
argument-hint: "<project-name>"
---

Focus the workshop on a specific project for deeper work.

Steps:
1. Read `~/.open-workshop/projects/_manifest.yaml` to verify the project exists and its current state
2. If the project is on the backlog, ask if the user wants to reheat it first
3. Read `~/.open-workshop/projects/$1/context/last-briefing.md` for cached context
4. Read `~/.open-workshop/projects/$1/profile.yaml` for project details (path, tech stack)
5. Read `~/.open-workshop/projects/$1/milestones.yaml` for current goals
6. Read `~/.open-workshop/projects/$1/ledger.yaml` summary for accounting snapshot
7. If the project repo path is accessible, optionally scan for recent changes (git log)
8. Present a focused project view:
   - Full status and context
   - Current milestones with progress
   - Available departments and what they could work on
   - Accounting summary
9. Ask what the user wants to work on within this project
