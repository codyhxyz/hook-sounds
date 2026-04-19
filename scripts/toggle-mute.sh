#!/bin/bash
# hook-sounds: flip the plugin-scoped mute flag.
# Does NOT touch the user-global $HOME/.claude/sounds/muted — that one is managed by the user.

set -u

plugin_data="${CLAUDE_PLUGIN_DATA:-$HOME/.claude/plugins/hook-sounds}"
mkdir -p "$plugin_data"
flag="$plugin_data/muted"

if [ -f "$flag" ]; then
  rm -f "$flag"
  echo "hook-sounds: unmuted"
else
  : > "$flag"
  echo "hook-sounds: muted (delete $flag or re-run to unmute)"
fi
