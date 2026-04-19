<h1 align="center">hook-sounds</h1>

<p align="center"><img src="docs/hero.gif" alt="hook-sounds live event tap: SessionStart, Notification, Stop, SessionEnd hooks firing with per-event sound filenames and waveform indicators" width="900"></p>
<p align="center"><sub>🔊 Sound on. This GIF can't convey the audio — that's the whole point.</sub></p>

<p align="center">
  <a href="LICENSE"><img src="https://img.shields.io/badge/license-MIT-blue.svg" alt="License"></a>
  <a href=".claude-plugin/plugin.json"><img src="https://img.shields.io/github/package-json/v/codyhxyz/hook-sounds?filename=.claude-plugin%2Fplugin.json&label=version" alt="Version"></a>
  <a href="https://claude.com/product/claude-code"><img src="https://img.shields.io/badge/built_for-Claude%20Code-d97706" alt="Built for Claude Code"></a>
  <a href="https://support.apple.com/en-us/HT201260"><img src="https://img.shields.io/badge/platform-macOS-999999" alt="macOS"></a>
</p>

<p align="center"><b>Play a random sound file when Claude Code fires a hook. You supply the audio.</b></p>

Claude Code fires five hook events over a session's lifetime: `SessionStart`, `UserPromptSubmit`, `Stop`, `Notification`, `SessionEnd`. This plugin wires four of them to a 30-line shell script that picks a random file from a directory and plays it with `afplay`. That's it. Ships no audio.

## Before and after

Before: you hand-wrote hook entries in `~/.claude/settings.json`, bundled your sounds loose under `~/.claude/sounds/`, rolled a bash `RANDOM` picker per event, and couldn't share the rig with a teammate without walking them through the whole thing.

After: `/plugin install hook-sounds`. Drop audio files into `~/.claude/plugins/hook-sounds/sounds/<event>/`. They play. One command to mute. `settings.json` untouched.

## What's in the box

- Four hooks wired by default: `SessionStart`, `Stop`, `Notification`, `SessionEnd`. `UserPromptSubmit` is supported but unwired because it fires every time you hit enter and gets old fast.
- Random picker per event. Drop one file or thirty, the script fans out across whatever's in the dir.
- Your sounds live in `$CLAUDE_PLUGIN_DATA/sounds/<event>/` and survive plugin updates. Bundled defaults under `sounds/default/<event>/` are the fallback (empty by default).
- Two mute paths: the plugin-scoped `toggle-mute.sh`, and the legacy `~/.claude/sounds/muted` flag that my previous setup already used. Both are honored.

## Install

From the single-plugin marketplace:

```
/plugin marketplace add codyhxyz/hook-sounds
/plugin install hook-sounds@hook-sounds
```

Local smoke test:

```bash
git clone https://github.com/codyhxyz/hook-sounds
claude --plugin-dir ./hook-sounds
```

## Usage

### 1. Drop sounds in

On macOS, after install:

```bash
mkdir -p ~/.claude/plugins/hook-sounds/sounds/stop
cp ~/Downloads/my-done-sting.mp3 ~/.claude/plugins/hook-sounds/sounds/stop/
```

Supported formats: `.mp3`, `.ogg`, `.wav`, `.m4a`, `.aiff`, `.caf`.

Repeat for the events you want to wire:

| Directory | Fires on | Vibe |
|---|---|---|
| `sounds/session-start/` | `SessionStart` | "hello" |
| `sounds/stop/` | `Stop` | "done" |
| `sounds/notification/` | `Notification` | "hey" |
| `sounds/session-end/` | `SessionEnd` | "goodbye" |
| `sounds/user-prompt-submit/` | `UserPromptSubmit` (opt-in, see below) | "got it" |

If a directory is empty, the event is silent. No error.

### 2. Mute / unmute

```bash
bash ~/.claude/plugins/cache/hook-sounds/scripts/toggle-mute.sh
```

Or use the user-global flag if you run multiple sound rigs:

```bash
touch ~/.claude/sounds/muted   # mutes everything
rm ~/.claude/sounds/muted      # unmutes
```

### 3. Tweak volume

```bash
export HOOK_SOUNDS_VOLUME=0.3   # afplay scale 0.0–1.0, default 0.5
```

Put it in your shell rc file to make it permanent.

### 4. Opt into `UserPromptSubmit`

Prompt-submit sounds are off by default. If you want them, add this to your `~/.claude/settings.json`:

```json
{
  "hooks": {
    "UserPromptSubmit": [
      {
        "matcher": "",
        "hooks": [
          { "type": "command", "command": "~/.claude/plugins/cache/hook-sounds/scripts/play-random.sh user-prompt-submit" }
        ]
      }
    ]
  }
}
```

Fair warning: it fires on every submitted prompt, which is a lot.

## Examples

<details>
<summary><b>Scenario 1</b>: "I want a short sting every time Claude finishes responding"</summary>

<br>

Install the plugin, drop one or more `.mp3` files into `~/.claude/plugins/hook-sounds/sounds/stop/`:

```bash
/plugin install hook-sounds@hook-sounds
mkdir -p ~/.claude/plugins/hook-sounds/sounds/stop
cp ~/Downloads/ding.mp3 ~/Downloads/chime.mp3 ~/.claude/plugins/hook-sounds/sounds/stop/
```

Next time Claude finishes a turn, one of those two files plays at 50% volume. Drop 30 files in and it fans out across all of them. No `settings.json` changes needed.

</details>

<details>
<summary><b>Scenario 2</b>: "I had a working hook rig in ~/.claude/ and want to package it"</summary>

<br>

Old setup: hand-rolled `SessionStart`/`Stop`/`Notification`/`SessionEnd` entries in `~/.claude/settings.json`, sounds in `~/.claude/sounds/mytheme/`, a couple of `play_*.sh` scripts. Teammates couldn't use it without you walking them through.

New flow: install `hook-sounds`, drop your audio into the four event subdirs under `~/.claude/plugins/hook-sounds/sounds/`, delete your old hook entries from `settings.json`. The legacy `~/.claude/sounds/muted` mute flag still works, so you don't have to rewire muscle memory.

</details>

<details>
<summary><b>Scenario 3</b>: "I want different vibes per event but picked randomly within each"</summary>

<br>

That's the default model. Each event dir is its own bag:

```
~/.claude/plugins/hook-sounds/sounds/
├── session-start/   # 3 "hello" variants → one plays on launch
├── stop/            # 12 "done" stings → random per Claude turn
├── notification/    # 2 "hey" pings → random when Claude needs input
└── session-end/     # 1 "goodbye" → plays on quit
```

The picker looks in each event's dir independently. Empty dirs are silently skipped.

</details>

## How it works

`hooks/hooks.json` wires four event types to one script, `scripts/play-random.sh`, with the event name as its sole argument. The script:

1. Checks two mute flags: plugin-scoped `$CLAUDE_PLUGIN_DATA/muted` and user-global `~/.claude/sounds/muted`. Either one silences output.
2. Looks in `$CLAUDE_PLUGIN_DATA/sounds/<event>/` first (your override), then falls back to `$CLAUDE_PLUGIN_ROOT/sounds/default/<event>/` (bundled).
3. Picks a random file with `find` + bash `RANDOM` and plays it with `afplay` in the background.

No audio is bundled. `sounds/default/` ships empty directories. Override-first resolution means plugin updates don't overwrite your sounds.

## Sourcing sounds

Don't rip copyrighted audio from commercial games into a public directory. Some CC0 starting points:

- [Kenney.nl](https://kenney.nl/assets?q=audio): full CC0, game-oriented packs (creatures, UI, impact).
- [freesound.org](https://freesound.org/): filter explicitly to CC0. Quality varies a lot.
- [OpenGameArt.org](https://opengameart.org/): CC0 audio filter.
- Commission it. A handful of short creature/UI stings on Fiverr runs roughly $75–200.

## Why this exists

I had a working hook rig at `~/.claude/settings.json` with five hook entries, a `sounds/` folder, and a couple of `play_*.sh` scripts. It was great, except the sounds were ripped Oddworld audio, so I couldn't share it without shipping a copyright problem. This plugin is the wiring from that rig, published empty. If you want the same UX, you bring your own audio.

It is not a sound pack. Zero audio ships here.

## Platform

macOS only at v0.1.0 because `afplay` is the player. Linux/Windows support is a shell substitution away (`paplay`, `aplay`, `powershell -c (New-Object Media.SoundPlayer ...).Play()`). PRs welcome. The script no-ops gracefully if `afplay` is missing, so a non-mac install won't error out.

## Contributing

Issues and PRs welcome. If the script behaves unexpectedly with a valid audio file, that's a bug — include the file format and the event dir in the report.

## License

[MIT](LICENSE) © 2026 Cody Hergenroeder
