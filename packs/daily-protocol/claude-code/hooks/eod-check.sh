#!/usr/bin/env bash
# Remind at end of day if today's EOD synthesis hasn't been completed.
# Hooked to Stop — sends desktop notification when due.

DATE=$(date +%Y-%m-%d)
HOUR=$(date +%-H)
VAULT="$HOME/codebases/second-brain"
DAILY_FILE="${VAULT}/0-Daily/${DATE}.md"

if [ "$HOUR" -ge 17 ]; then
  if [ ! -f "$DAILY_FILE" ]; then
    export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"
    notify-send --urgency=critical "EOD Synthesis" "No daily log for ${DATE}.\nRun: /second-brain:daily morning"
  else
    STATUS=$(grep '^status:' "$DAILY_FILE" | head -1 | sed 's/status:[[:space:]]*//')
    if [ "$STATUS" != "done" ] && [ "$STATUS" != "eod" ]; then
      export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"
      notify-send --urgency=critical "EOD Synthesis" "Daily log not complete (status: ${STATUS}).\nRun: /second-brain:daily eod"
    fi
  fi
fi
