#!/usr/bin/env bash
# Open Workshop — Codex Edition (Session Start Helper)

DATA_HOME="$HOME/.open-workshop"
CONFIG="$DATA_HOME/config.yaml"
MANIFEST="$DATA_HOME/projects/_manifest.yaml"

if [ ! -f "$CONFIG" ]; then
  echo "Open Workshop: first run detected (missing config)."
  echo "Run the setup wizard skill: setup-wizard"
  exit 0
fi

echo "Open Workshop config found."
[ -f "$MANIFEST" ] && echo "Project manifest found."

echo "Ask Codex to show the dashboard via the workshop-dashboard skill."
