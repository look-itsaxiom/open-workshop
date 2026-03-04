---
name: engine-dispatch
description: >
  Dispatch tasks to external AI engines to save Claude Code tokens. The
  workshop can offload coding, research, or analysis to any configured
  AI CLI. Use when someone says "dispatch externally", "use codex", "use
  gemini", "offload this task", "external dispatch", "save tokens", or
  when a task is suitable for external execution.
---

# Engine Dispatch

Offload sub-tasks to external AI CLIs to conserve Claude Code tokens. You (the calling agent) stay in charge — external tools are workers, not decision-makers. Always review their output before committing.

## Reading Engine Configuration

Read `~/.open-workshop/engines.yaml` for available engines:

```yaml
engines:
  - name: codex
    command: "codex exec --full-auto"
    strengths: ["unit tests", "bug fixes", "refactors", "type additions"]
    cost: "Included with ChatGPT Plus"
    notes: "Precise. Needs specific prompts with exact file paths."
  - name: gemini
    command: "gemini -p"
    strengths: ["research", "analysis", "boilerplate", "large context"]
    cost: "Free (1000 req/day)"
    notes: "1M token context. Good for broad exploratory tasks."
```

## Engine Selection

Match the task to engine strengths:

| Task Profile | Best Engine Trait | Why |
|-------------|-------------------|-----|
| Write/fix code precisely | "tests", "bug fixes", "refactors" | Code quality matters |
| Analyze codebase | "research", "large context" | Needs broad understanding |
| Generate boilerplate | "boilerplate" | Speed over precision |
| Research a topic | "research" | Breadth over depth |
| Quick questions | Lowest cost engine | Not worth expensive tokens |
| Complex reasoning | **Keep in Claude** | Don't dispatch |

**Rule of thumb:** If the task needs precision and code quality, pick the engine tagged for that. If it needs speed, volume, or large context, pick the cheapest engine that handles it.

## When NOT to Dispatch

Keep the task in Claude when it:
- Requires complex multi-system reasoning or architectural decisions
- Needs coordination between agents or deep project context
- Is security-sensitive
- Requires MCP servers or Claude Code-specific tools

## Dispatch Protocol

### 1. Scope the Task
Write a clear, specific prompt with:
- Exact files to read or modify
- Expected output format
- Framework/tooling constraints
- Reference files for style/patterns

### 2. Set Working Directory
Always `cd` to the project root before dispatching.

### 3. Run the Command
Use the Bash tool with the engine's command template. For long-running tasks, use `run_in_background: true`.

### 4. Review the Output (MANDATORY)
Never blindly commit external output.

For generated code:
- Read every file that was created or modified
- Check for correctness, style consistency, and security issues
- Run the project's test suite

For analysis/research:
- Verify claims against the codebase
- Check for hallucinated file paths or function names

### 5. Integrate or Iterate
- Output is good → keep it, continue your work
- Small issues → fix them yourself (faster than re-dispatching)
- Major issues → re-dispatch with a more specific prompt
- Fundamentally wrong → discard and do it in Claude

## Writing Good Prompts for External Engines

Most external engines need **specific, scoped instructions**. Vague prompts produce poor results.

**Bad:** `"Improve the tests"`

**Good:** `"Write unit tests for the calculateDamage function in src/engine/combat.ts. Cover: base damage, critical hits, type effectiveness. Use vitest. Follow patterns in src/test/match.test.ts."`

Always tell external engines:
1. Exactly which files to read or modify
2. What framework/tools to use
3. What patterns to follow (reference an existing file)
4. What the expected output looks like

## Telling Teammates About External Engines

When dispatching department work, include this in the spawn prompt if engines are configured:

```
EXTERNAL ENGINES (save tokens):
You can offload sub-tasks to external AI tools.
Check ~/.open-workshop/engines.yaml for available engines and their strengths.
Always cd to the project root first. Always review output before committing.
Use your judgment: complex reasoning stays in Claude, grunt work goes external.
```

## Troubleshooting

| Problem | Solution |
|---------|----------|
| Engine command not found | Install the CLI tool per its documentation |
| Auth error | Run the engine interactively once to authenticate |
| Rate limited | Switch to a different engine for that task |
| Poor output quality | Make the prompt more specific |
| Wrong files modified | Review diffs before committing; use `git checkout -- file` to revert |
