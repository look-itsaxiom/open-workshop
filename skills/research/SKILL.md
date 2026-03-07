---
name: research
description: >
  Research and Development operations: evaluate tools, research best
  practices, create new departments, and update department knowledge.
  This skill should be used when the user says "research", "evaluate",
  "investigate", "R&D", "create a department", "new department", "build
  a department", "I need a [X] department", "what tools exist for [X]",
  or when exploring a new domain for the workshop.
---

# Research & Development

R&D is the workshop's stem cell department. It researches, evaluates, and builds capabilities as auto-triggering skills.

## The Rule

Every R&D operation ends by compiling a skill into `~/.open-workshop/skills/`. Research that does not produce a skill is incomplete.

## Core Operations

### Evaluate a Tool or Technique

1. Research the tool using WebSearch and WebFetch
2. Assess: What does it do? What are the alternatives? Cost? Complexity?
3. Document findings in `~/.open-workshop/departments/research-and-development/findings/YYYY-MM-DD-<topic>.md`
4. If relevant to a department, update that department's `tools.yaml`
5. **Compile the skill** (see below)

### Research Best Practices for a Domain

1. Identify what the user needs (e.g., "how should we handle testing?")
2. Research current best practices
3. Document findings in `~/.open-workshop/departments/research-and-development/findings/YYYY-MM-DD-<topic>.md`
4. Summarize actionable recommendations
5. **Compile the skill** (see below)

### Create a New Department

When the user needs a new specialist area:

1. **Understand the domain**: Ask what kind of work this department will do
2. **Research**: What tools, practices, and knowledge does this domain need?
3. **Create the department directory**:
   ```
   ~/.open-workshop/departments/<department-name>/
   ├── knowledge.md
   └── tools.yaml
   ```
4. **Write `knowledge.md`**: Initial knowledge base with:
   - What this department does
   - Key practices and patterns
   - Common pitfalls to avoid
   - Links to relevant documentation
5. **Write `tools.yaml`**: Tool catalog with specialized tools
6. **Compile the skill** — create a skill for the department's core capability
7. **Confirm with the user**: Present what was created and how to use it

### Update Department Knowledge

1. Read the existing `knowledge.md` for the department
2. Add new findings, patterns, or lessons learned
3. Update `tools.yaml` if new tools were discovered
4. **Update or create skills** in `~/.open-workshop/skills/` if the new knowledge is actionable

## Compile the Skill

This step is mandatory. Every finding becomes a skill.

### 1. Choose a skill name

Use kebab-case. Name it for what it does, not what you researched.
- Good: `comfyui-sprite-generation`, `godot-scene-patterns`
- Bad: `2026-03-07-research`, `comfyui-findings`

### 2. Check for existing skills

```bash
ls ~/.open-workshop/skills/ 2>/dev/null
```

If the directory doesn't exist, create it: `mkdir -p ~/.open-workshop/skills/`

If a related skill already exists, update it instead of creating a new one.

### 3. Write the SKILL.md

Create `~/.open-workshop/skills/<skill-name>/SKILL.md`:

```yaml
---
name: <Clear Action Name>
description: >
  <What it does>. <What tools/technologies it involves>.
  Use when <specific trigger phrases the user would say>.
  Use when <task characteristics that match>.
  Do NOT use when <disambiguation from similar skills>.
---
```

Then write actionable instructions — "how to do X," not "X exists."

Reference the original finding for deep context:
```markdown
For full research details, see:
~/.open-workshop/departments/research-and-development/findings/YYYY-MM-DD-<topic>.md
```

### 4. Verify

- Does the description contain specific trigger phrases?
- Does it disambiguate from similar skills with "Do NOT use when"?
- Are the instructions actionable (commands, file paths, steps)?
- Does it avoid duplicating another skill?

## Knowledge Management Principles

- **Skills over documents**: Knowledge that can be acted on becomes a skill
- **Update, don't duplicate**: If a skill exists for this domain, update it
- **Be specific**: "Use vitest with --reporter=verbose for CI" beats "use a test runner"
- **Include the why**: Don't just list tools — explain when and why to use them
- **Departments are additive**: Tool catalogs expand capabilities, never restrict them
