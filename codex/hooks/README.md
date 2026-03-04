# Hooks (Optional / Reference Only)

These hook scripts are carried over from the Claude plugin for parity.
Codex does not run Claude-style hooks automatically.

If you want equivalent behavior in Codex:

- Manually run `scripts/session-start.sh` to assemble dashboard context
- Manually run `scripts/track-cost.js` with a transcript JSONL file

Note: `hooks.json` references `CLAUDE_PLUGIN_ROOT` from the Claude plugin
runtime. In Codex, treat this folder as reference only.
