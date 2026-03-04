#!/usr/bin/env bash
# Open Workshop — Codex Edition (Cost Tracker Wrapper)
# Usage: ./track-cost.sh /path/to/transcript.jsonl

TRANSCRIPT_PATH="$1"
if [ -z "$TRANSCRIPT_PATH" ]; then
  echo "Usage: $0 /path/to/transcript.jsonl"
  exit 1
fi

PAYLOAD=$(cat << EOF
{
  "hook_event_name": "SubagentStop",
  "transcript_path": "$TRANSCRIPT_PATH"
}
EOF
)

echo "$PAYLOAD" | node "$(dirname "$0")/../hooks/scripts/track-cost.js"
