#!/usr/bin/env bash
# Open Workshop — SessionStart Hook
# Detects first run (no config) or normal run (inject dashboard context)

PLUGIN_ROOT="$(cd "$(dirname "$0")/../.." && pwd)"
DATA_HOME="$HOME/.open-workshop"
CONFIG="$DATA_HOME/config.yaml"
MANIFEST="$DATA_HOME/projects/_manifest.yaml"
LOCAL_PLUGIN="$DATA_HOME/.claude-plugin/plugin.json"

TMPFILE=$(mktemp)
trap "rm -f $TMPFILE" EXIT

# ── First-Run Detection ──────────────────────────────────────────────
if [ ! -f "$CONFIG" ]; then
  cat > "$TMPFILE" << 'FIRSTRUN'
This is the user's first time using Open Workshop. The plugin data directory (~/.open-workshop/) has not been created yet.

**REQUIRED:** Invoke the setup-wizard skill to guide the user through first-run setup. Do not show the dashboard — there is nothing to show yet.

After setup completes, show the empty dashboard and prompt the user to onboard or create their first project.
FIRSTRUN

  CONTEXT=$(cat "$TMPFILE" | node -e "let d='';process.stdin.on('data',c=>d+=c);process.stdin.on('end',()=>console.log(JSON.stringify(d)))" 2>/dev/null)

  cat << HOOKEOF
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": $CONTEXT
  }
}
HOOKEOF
  exit 0
fi

# ── Normal Run — Build Dashboard Context ─────────────────────────────
# Read workshop name from config
WORKSHOP_NAME=$(grep 'workshop_name:' "$CONFIG" 2>/dev/null | sed 's/workshop_name:[[:space:]]*//' | sed 's/^"//' | sed 's/"$//')
if [ -z "$WORKSHOP_NAME" ]; then
  WORKSHOP_NAME="Open Workshop"
fi

# ── Local Plugin Health Check ────────────────────────────────────────
if [ ! -f "$LOCAL_PLUGIN" ]; then
  cat >> "$TMPFILE" << 'HEAL'

LOCAL PLUGIN MISSING: The learned-capabilities plugin at ~/.open-workshop/.claude-plugin/plugin.json does not exist. Run the setup wizard to create it, or create it manually:
  mkdir -p ~/.open-workshop/.claude-plugin
  Then create plugin.json and marketplace.json per the setup-wizard skill.

HEAL
elif grep -q 'local_plugin_installed:.*false' "$CONFIG" 2>/dev/null || ! grep -q 'local_plugin_installed' "$CONFIG" 2>/dev/null; then
  cat >> "$TMPFILE" << 'HEAL'

LOCAL PLUGIN NOT REGISTERED: The local plugin exists but is not registered with Claude Code. Ask the user to run:
  /plugin marketplace add ~/.open-workshop
  /plugin install open-workshop-local@open-workshop-local-marketplace
Then set local_plugin_installed: true in ~/.open-workshop/config.yaml.

HEAL
fi

cat >> "$TMPFILE" << HEADER
You are the $WORKSHOP_NAME lead. Use the workshop-dashboard skill to present the project dashboard to the user.

Open Workshop plugin root: $PLUGIN_ROOT
Open Workshop data home: $DATA_HOME
HEADER

echo "" >> "$TMPFILE"

# Read config
if [ -f "$CONFIG" ]; then
  echo "=== WORKSHOP CONFIG ===" >> "$TMPFILE"
  cat "$CONFIG" >> "$TMPFILE"
  echo "" >> "$TMPFILE"
fi

# Read manifest and active project statuses
if [ -f "$MANIFEST" ]; then
  echo "=== PROJECT MANIFEST ===" >> "$TMPFILE"
  cat "$MANIFEST" >> "$TMPFILE"
  echo "" >> "$TMPFILE"

  IN_ACTIVE=false
  while IFS= read -r line; do
    if [[ "$line" == "active:"* ]]; then
      IN_ACTIVE=true
      continue
    fi
    if [[ "$line" =~ ^[a-z] ]] && [ "$IN_ACTIVE" = true ]; then
      IN_ACTIVE=false
      continue
    fi
    if [ "$IN_ACTIVE" = true ]; then
      PROJECT_NAME=$(echo "$line" | sed -n 's/^[[:space:]]*-[[:space:]]*//p')
      if [ -n "$PROJECT_NAME" ]; then
        STATUS_FILE="$DATA_HOME/projects/$PROJECT_NAME/status.md"
        LEDGER_FILE="$DATA_HOME/projects/$PROJECT_NAME/ledger.yaml"

        if [ -f "$STATUS_FILE" ]; then
          echo "=== STATUS: $PROJECT_NAME ===" >> "$TMPFILE"
          cat "$STATUS_FILE" >> "$TMPFILE"
          echo "" >> "$TMPFILE"
        fi

        if [ -f "$LEDGER_FILE" ]; then
          echo "=== LEDGER SUMMARY: $PROJECT_NAME ===" >> "$TMPFILE"
          sed -n '/^summary:/,$ p' "$LEDGER_FILE" >> "$TMPFILE"
          echo "" >> "$TMPFILE"
        fi
      fi
    fi
  done < "$MANIFEST"
fi

# Escape for JSON
CONTEXT=$(cat "$TMPFILE" | node -e "let d='';process.stdin.on('data',c=>d+=c);process.stdin.on('end',()=>console.log(JSON.stringify(d)))" 2>/dev/null)

# Fallback: python3
if [ -z "$CONTEXT" ]; then
  CONTEXT=$(cat "$TMPFILE" | python3 -c "import sys,json; print(json.dumps(sys.stdin.read()))" 2>/dev/null)
fi

# Last resort: basic escaping
if [ -z "$CONTEXT" ]; then
  CONTEXT=$(cat "$TMPFILE" | sed 's/\\/\\\\/g; s/"/\\"/g; s/\t/\\t/g' | awk '{printf "%s\\n", $0}')
  CONTEXT="\"$CONTEXT\""
fi

cat << HOOKEOF
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": $CONTEXT
  }
}
HOOKEOF
