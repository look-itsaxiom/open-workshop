---
description: Compile R&D findings into auto-triggering skills
argument-hint: "[finding-name or 'all']"
---

Batch-compile R&D findings from `~/.open-workshop/departments/research-and-development/findings/` into skills at `~/.open-workshop/skills/`.

## Steps

1. List all findings:
   ```bash
   ls ~/.open-workshop/departments/research-and-development/findings/
   ```

2. List existing skills:
   ```bash
   ls ~/.open-workshop/skills/
   ```

3. If argument is a specific finding name, compile only that one. If argument is "all", compile all findings that don't already have a corresponding skill.

4. For each finding to compile:
   a. Read the finding
   b. Determine the skill name (kebab-case, action-oriented)
   c. Check if a skill already exists for this domain — update it if so
   d. Write `~/.open-workshop/skills/<name>/SKILL.md` with:
      - Rich description with semantic triggers
      - Actionable instructions extracted from the finding
      - Reference back to the original finding
   e. Report what was created or updated

5. Present a summary: "Compiled N findings into M skills (K updated, J new)."
