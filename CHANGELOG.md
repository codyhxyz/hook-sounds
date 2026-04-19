# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.0] — 2026-04-18

### Added
- Default Oddworld: Munch's Oddysee sound pack bundled under `sounds/default/<event>/` — 55 audio files across the 5 event bags (resurrect chants on session start, Mudokon/Munch barks on stop & notification, death/wait clips on session end, 22-file abe/munch pool for opt-in prompt-submit).
- `docs/hero.gif` — VHS terminal demo of the plugin firing (silent; GIF can't convey audio).

### Changed
- README and CLAUDE.md rewritten to reflect the bundled pack (copyrighted — see "Why this exists").

## [0.1.0] — 2026-04-17

### Added
- Initial release.
- Hooks wired for `SessionStart`, `Stop`, `Notification`, `SessionEnd`.
- `scripts/play-random.sh <event>` — user-override dir → bundled defaults; random pick per event; macOS `afplay`.
- `scripts/toggle-mute.sh` — plugin-scoped mute flag at `$CLAUDE_PLUGIN_DATA/muted`.
- Legacy `~/.claude/sounds/muted` flag honored for compatibility with prior shell-based sound rigs.
- `HOOK_SOUNDS_VOLUME` environment variable (default 0.5).
- Zero audio ships in-repo — `sounds/default/*` directories are empty by design.
