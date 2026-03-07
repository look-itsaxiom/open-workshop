# Research & Development — Knowledge Base

## What R&D Does

R&D is the workshop's bootstrap department. It:
- Evaluates tools, libraries, and techniques
- Researches best practices for any domain
- Creates new departments when the workshop needs specialists
- Documents findings so future sessions don't re-discover them

## How to Evaluate a Tool

1. **What does it do?** One-sentence purpose
2. **What are the alternatives?** At least 2-3 options
3. **Cost?** Free, freemium, paid, self-hosted?
4. **Complexity?** Setup time, learning curve, maintenance burden
5. **Fit?** Does it solve our actual problem or is it over-engineered?
6. **Verdict:** Use it, skip it, or revisit later

## How to Create a Department

When the workshop needs a new specialist area:

1. Create the directory: `~/.open-workshop/departments/<name>/`
2. Write `knowledge.md` with:
   - What the department does
   - Key practices and patterns for that domain
   - Common pitfalls to avoid
   - Links to relevant documentation
3. Write `tools.yaml` with specialized tools:
   ```yaml
   tools:
     - name: tool-name
       purpose: "What it does"
       install: "How to install"
       notes: "Usage tips"
   ```

## How to Document Findings

- **Update existing docs** rather than creating new ones
- **Be specific**: include exact commands, file paths, version numbers
- **Include the "why"**: don't just list facts — explain the reasoning
- **Date your findings**: tools and best practices evolve

## How to Compile Skills from Findings

Every research finding becomes a skill at `~/.open-workshop/skills/<name>/SKILL.md`.

### Skill Description Template

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

### Good Descriptions

- Include specific trigger words users would say
- List the tools and technologies involved
- Add "Do NOT use when" to disambiguate from similar skills
- Be specific: "Generate pixel art sprites using ComfyUI FLUX Schnell" not "make images"

### Good Instructions

- Actionable: commands, file paths, step-by-step
- Reference the original finding for deep context
- Include what to do, not just what exists

### Before Creating a Skill

1. Check `~/.open-workshop/skills/` for existing skills in the same domain
2. If one exists, update it instead of creating a duplicate
3. Name skills for what they do, not when they were researched

## Conventions

- Tool catalogs (`tools.yaml`) are additive — they expand capabilities, never restrict them
- Knowledge bases (`knowledge.md`) are living documents — keep them current
- Departments are personal — each workshop grows the departments it needs
