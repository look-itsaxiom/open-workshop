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

R&D is the workshop's stem cell department. It researches, evaluates, and builds the capabilities your workshop needs.

## Core Operations

### Evaluate a Tool or Technique

1. Research the tool using WebSearch and WebFetch
2. Assess: What does it do? What are the alternatives? Cost? Complexity?
3. If relevant to a department, update that department's `tools.yaml`
4. Document findings in the department's `knowledge.md`

### Research Best Practices for a Domain

1. Identify what the user needs (e.g., "how should we handle testing?")
2. Research current best practices
3. Summarize findings with actionable recommendations
4. Store in the relevant department's `knowledge.md`

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
5. **Write `tools.yaml`**: Tool catalog with:
   ```yaml
   tools:
     - name: <tool-name>
       purpose: "<what it's for>"
       install: "<how to install>"
       notes: "<usage tips>"
   ```
6. **Confirm with the user**: Present what was created and how to use it

### Update Department Knowledge

1. Read the existing `knowledge.md` for the department
2. Add new findings, patterns, or lessons learned
3. Update `tools.yaml` if new tools were discovered
4. Prefer updating existing entries over creating new sections

## Knowledge Management Principles

- **Update, don't duplicate**: If a topic already has documentation, update the existing doc
- **Be specific**: "Use vitest with --reporter=verbose for CI" beats "use a test runner"
- **Include the why**: Don't just list tools — explain when and why to use them
- **Departments are additive**: Tool catalogs expand capabilities, never restrict them
- **Knowledge persists**: Everything written to `~/.open-workshop/departments/` survives across sessions

## R&D Seed Knowledge

The R&D department ships with basic knowledge about:
- How to evaluate tools (criteria, comparison frameworks)
- How to create departments (directory structure, knowledge base format)
- How to document findings (update existing docs, be specific, include rationale)

Users can expand this by asking R&D to research any domain they're interested in.
