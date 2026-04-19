#!/bin/bash
# hook-sounds: play a random audio file for the given Claude Code hook event.
# Usage: play-random.sh <event-name>
#   event-name ∈ {session-start, stop, notification, session-end, user-prompt-submit}
#
# Resolution order for the source directory:
#   1. $CLAUDE_PLUGIN_DATA/sounds/<event>/   (user override, survives updates)
#   2. $CLAUDE_PLUGIN_ROOT/sounds/default/<event>/  (bundled defaults)
#
# Honors two mute flags (either one silences all events):
#   - $CLAUDE_PLUGIN_DATA/muted              (plugin-scoped, toggle via toggle-mute.sh)
#   - $HOME/.claude/sounds/muted             (user-global, shared with other sound setups)
#
# Volume: $HOOK_SOUNDS_VOLUME (default 0.5, afplay scale 0.0–1.0).
# macOS only — exits silently when afplay is unavailable.

set -u

event="${1:-}"
[ -z "$event" ] && exit 0

command -v afplay >/dev/null 2>&1 || exit 0

plugin_data="${CLAUDE_PLUGIN_DATA:-$HOME/.claude/plugins/hook-sounds}"

if [ -f "$plugin_data/muted" ] || [ -f "$HOME/.claude/sounds/muted" ]; then
  exit 0
fi

for dir in "$plugin_data/sounds/$event" "${CLAUDE_PLUGIN_ROOT:-}/sounds/default/$event"; do
  [ -n "$dir" ] && [ -d "$dir" ] || continue

  files=()
  while IFS= read -r -d '' f; do
    files+=("$f")
  done < <(find "$dir" -maxdepth 1 -type f \( \
    -iname '*.mp3' -o -iname '*.ogg' -o -iname '*.wav' -o -iname '*.m4a' -o -iname '*.aiff' -o -iname '*.caf' \
  \) -print0)

  [ ${#files[@]} -eq 0 ] && continue

  pick="${files[RANDOM % ${#files[@]}]}"
  afplay -v "${HOOK_SOUNDS_VOLUME:-0.5}" "$pick" >/dev/null 2>&1 &
  exit 0
done

exit 0
