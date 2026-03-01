# Open Workshop — Marketing Site (GitHub Pages)

## Goal
A single-page marketing site hosted via GitHub Pages that explains what Open Workshop is, shows how it works, and makes installation a copy-paste.

## Requirements
- Static site (HTML/CSS/JS, no build step needed — or lightweight like Astro/11ty)
- Hosted at `https://look-itsaxiom.github.io/open-workshop/` via GitHub Pages
- Mobile-responsive
- Dark theme (developer audience)

## Sections

### Hero
- Name + tagline: "A self-organizing AI workshop that grows with you"
- One-liner: what it does in plain English
- Install command (copy-to-clipboard)

### The Problem
- Claude Code sessions start cold
- Re-explaining context wastes tokens
- Juggling multiple projects is chaotic

### How It Works
- Visual: Dashboard → Departments → Engine Offloading → Accounting
- 4 cards or steps showing the workflow
- Maybe a terminal-style screenshot/mockup of the dashboard

### Features Grid
- Project lifecycle (active/backlog/archive)
- Department dispatch (sub-agents or agent teams)
- Engine offloading (Codex, Gemini, anything)
- ROI tracking (automatic + milestone-linked)
- Self-growing departments (R&D stem cell)
- First-run wizard

### Installation
- Step-by-step with copy-paste commands
- First run explanation

### Origin Story
- Brief: "Extracted from Dream Factory, a personal studio managing 5+ projects"
- Link to Dream Factory repo

### Footer
- GitHub link
- MIT license
- "Built with Claude Code" badge

## Tech Approach
Keep it simple — a single `index.html` in a `docs/` folder (GitHub Pages source) or use the `gh-pages` branch. CSS-only animations, no framework bloat. The audience is developers; they'll appreciate clean, fast, no-nonsense.

## Deployment
1. Build the page
2. Enable GitHub Pages in repo settings (source: `docs/` folder or `gh-pages` branch)
3. Verify at `https://look-itsaxiom.github.io/open-workshop/`
