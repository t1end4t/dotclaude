#!/usr/bin/env bash
# Remind once per morning if today's daily log hasn't started.
# Hooked to UserPromptSubmit — sends desktop notification when due.

DATE=$(date +%Y-%m-%d)
HOUR=$(date +%-H)
VAULT="$HOME/codebases/second-brain"
DAILY_FILE="${VAULT}/0-Daily/${DATE}.md"

if [ "$HOUR" -lt 12 ] && [ ! -f "$DAILY_FILE" ]; then
  export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"
  notify-send --urgency=normal "Morning Review" "No daily log for ${DATE}.\nRun: /second-brain:daily morning"
elif [ "$HOUR" -lt 12 ] && [ -f "$DAILY_FILE" ]; then
  STATUS=$(grep '^status:' "$DAILY_FILE" | head -1 | sed 's/status:[[:space:]]*//')
  if [ "$STATUS" = "morning" ]; then
    export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"
    notify-send --urgency=low "Set Objectives" "Morning context done but no objectives set.\nRun: /second-brain:daily objectives"
  fi
fi
