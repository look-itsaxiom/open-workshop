---
name: accounting
description: >
  Track project ROI by logging token spend and milestone progress. This
  skill should be used when completing tasks (to log work), when the user
  asks "how much have we spent", "show ROI", "project economics", "which
  project is most efficient", "what's the spend", or when comparing spend
  across projects. Also teaches teammates how to self-report work.
---

# Accounting — Progress & Spend Tracking

## Purpose

Track the relationship between AI compute spend and project progress. Answers:
"For every dollar spent, how much closer did the project get to shipping?"

## Ledger Format

Each project has a `ledger.yaml` at `~/.open-workshop/projects/<name>/ledger.yaml`:

```yaml
entries:
  - date: YYYY-MM-DD
    department: <department-name>
    task: "<what was done — one line>"
    milestone_impact:
      - milestone: "<milestone name from milestones.yaml>"
        progress_before: <0-100>
        progress_after: <0-100>
    estimated_tokens: <number or null>
    model: <model-id or null>
    estimated_cost_usd: <number or null>
    notes: "<optional context>"

summary:
  total_estimated_spend: <sum of all estimated_cost_usd>
  overall_progress: <weighted average across milestones>
  roi_ratio: <overall_progress / total_estimated_spend>
```

## For Teammates: How to Log Work

When you complete a task:

1. Read the current `ledger.yaml` for the project
2. Read `milestones.yaml` to find the relevant milestone
3. Append a new entry under `entries:` with:
   - Today's date
   - Your department name
   - A one-line task description
   - The milestone this impacts and your honest assessment of progress change
   - Token estimate if you can reasonably guess (otherwise null)
   - Model you're running as (otherwise null)
4. Update the `summary` section:
   - Recalculate `total_estimated_spend` (sum all non-null estimated_cost_usd)
   - Recalculate `overall_progress` (weighted average of milestone progress)
   - Recalculate `roi_ratio` (overall_progress / total_estimated_spend, or null if spend is 0)

## For the Lead: How to Read Accounting

### Per-Project View
Read `~/.open-workshop/projects/<name>/ledger.yaml` summary section for quick stats.

### Cross-Project Comparison
Read summary sections from all active project ledgers. Compare:
- **ROI ratio** — higher is better (more progress per dollar)
- **Progress trend** — is the project accelerating or stalling?
- **Spend rate** — how fast is budget being consumed?

### Making Prioritization Decisions
When the user asks "what should we work on?", accounting data can inform:
- Projects with high ROI ratio — keep investing
- Projects with declining ROI — may need a different approach or backlog
- Projects near milestone completion — push to finish for quick wins

## Cost Estimation Guide

Rough token-to-USD estimates (subject to change):

| Model | Input (per 1M tokens) | Output (per 1M tokens) |
|-------|-----------------------|------------------------|
| claude-opus-4-6 | $15.00 | $75.00 |
| claude-sonnet-4-6 | $3.00 | $15.00 |
| claude-haiku-4-5 | $0.80 | $4.00 |

For a typical task using Sonnet: ~50K input + ~15K output ≈ $0.37

## Automatic Cost Tracking

The `SubagentStop` hook automatically parses subagent/teammate transcripts and logs token usage to `~/.open-workshop/cost-log.jsonl`. This provides the raw cost data. The ledger entries add the "what was accomplished" context that makes the spend meaningful.
