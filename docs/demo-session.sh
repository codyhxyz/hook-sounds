#!/usr/bin/env bash
# Deterministic simulated session for the hook-sounds hero GIF.
# Driven by docs/demo.tape via `vhs docs/demo.tape`.
# No audio is actually played during this run — the output is purely visual.

set -e

CYAN=$'\033[36m'
AMBER=$'\033[38;5;214m'
GREEN=$'\033[32m'
MAGENTA=$'\033[35m'
GREY=$'\033[90m'
DIM=$'\033[2m'
BOLD=$'\033[1m'
RESET=$'\033[0m'

event() {
  local ts="$1"
  local color="$2"
  local hook="$3"
  local file="$4"
  local wave="$5"
  printf "%s[%s]%s %s%-14s%s %s%s%s %s%-16s%s %s%s%s\n" \
    "${GREY}" "${ts}" "${RESET}" \
    "${color}${BOLD}" "${hook}" "${RESET}" \
    "${AMBER}" "🔊" "${RESET}" \
    "${color}" "${file}" "${RESET}" \
    "${DIM}" "${wave}" "${RESET}"
  sleep 0.45
}

printf "%s\n" "${BOLD}hook-sounds${RESET} ${DIM}· live event tap · 4 hooks wired${RESET}"
printf "%s\n" "${DIM}# sounds are audible — this GIF is silent${RESET}"
echo
sleep 0.8

event "14:22:01" "${MAGENTA}" "SessionStart"   "hello-01.mp3"   "▁▂▅▇▆▃▁"
event "14:22:04" "${GREY}"    "UserPrompt"     "(unwired)"      "·  ·  ·"
event "14:22:18" "${CYAN}"    "Notification"   "ping-02.mp3"    "▁▂▄▆▄▂▁"
sleep 0.4
event "14:22:31" "${GREEN}"   "Stop"           "done-04.mp3"    "▂▄▆█▆▄▂"
event "14:22:46" "${CYAN}"    "Notification"   "ping-01.mp3"    "▁▃▅▃▁"
event "14:23:02" "${GREEN}"   "Stop"           "done-11.mp3"    "▂▅▇▅▂"
sleep 0.3
event "14:23:19" "${CYAN}"    "Notification"   "ping-03.mp3"    "▁▂▄▆▄▂▁"
event "14:23:33" "${GREEN}"   "Stop"           "done-07.mp3"    "▃▆█▆▃"
event "14:23:41" "${MAGENTA}" "SessionEnd"     "goodbye-01.mp3" "▇▅▃▂▁"

echo
printf "%s\n" "${DIM}picker: ~/.claude/plugins/hook-sounds/sounds/<event>/  →  afplay${RESET}"
printf "%s\n" "${DIM}volume: HOOK_SOUNDS_VOLUME=0.5   mute: touch ~/.claude/sounds/muted${RESET}"
echo
sleep 0.8
printf "%s\n" "${BOLD}${AMBER}ears on. stop staring at the screen.${RESET}"
sleep 2
