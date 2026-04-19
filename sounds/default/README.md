# Bundled default sounds

Drop audio files into the subdirectories below. `play-random.sh` picks one at random per event.

| Directory | Fires on | Suggested character |
|---|---|---|
| `session-start/` | Hook event `SessionStart` | "hello" — you opened Claude Code |
| `stop/` | Hook event `Stop` | "done" — Claude finished its turn |
| `notification/` | Hook event `Notification` | "hey" — Claude needs input |
| `session-end/` | Hook event `SessionEnd` | "goodbye" — session closing |
| `user-prompt-submit/` | Hook event `UserPromptSubmit` (not wired in default `hooks.json`) | "got it" — every time you hit enter |

Supported formats: `.mp3`, `.ogg`, `.wav`, `.m4a`, `.aiff`, `.caf`.

**To keep your own sounds across plugin updates**, drop them in `$CLAUDE_PLUGIN_DATA/sounds/<event>/` instead — that location takes precedence over these bundled defaults and won't be overwritten when the plugin updates. On macOS that resolves to `~/.claude/plugins/hook-sounds/sounds/<event>/`.

## Sourcing sounds

Some CC0 sources worth a look if you don't have audio to drop in:

- [Kenney.nl audio packs](https://kenney.nl/assets?q=audio) — full CC0, game-oriented creature / UI / impact stings.
- [freesound.org](https://freesound.org/) — filter by "CC0" license explicitly. Quality varies; curate carefully.
- [OpenGameArt.org](https://opengameart.org/art-search-advanced?field_art_type_tid%5B%5D=13) — audio section, filter by CC0.

Avoid ripping audio from commercial games — it's copyright-infringing even when it's easy to find.
