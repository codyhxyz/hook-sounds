# hook-sounds — Claude Code plugin

This repo is a **Claude Code plugin**. The rules below apply to every session that opens anywhere in this tree. For the full end-to-end workflow (scaffold → build → test → host → submit), invoke the `create-claude-plugin` skill.

## What this plugin does

Wires four Claude Code hook events (`SessionStart`, `Stop`, `Notification`, `SessionEnd`) to a single random-audio-file picker script. No audio is bundled in-repo by design — users supply their own files via `$CLAUDE_PLUGIN_DATA/sounds/<event>/`. The plugin ships the wiring, not the noise.

## Directory invariants

- All component directories (`hooks/`, `scripts/`, `sounds/`) live at the **plugin root**.
- **Only** `plugin.json` and `marketplace.json` live inside `.claude-plugin/`. Never put components there — installation will silently fail.

## Path rules

- Every hook command and script reference uses `${CLAUDE_PLUGIN_ROOT}/...`.
- Never use absolute paths. Never use `..` traversal. Plugins are copied to `~/.claude/plugins/cache/` on install and both will break.
- User state (their dropped-in sounds, the mute flag) lives in `${CLAUDE_PLUGIN_DATA}` — never in `${CLAUDE_PLUGIN_ROOT}`, which is read-only across updates.

## Audio in the repo

`sounds/default/<event>/` ships with an Oddworld: Munch's Oddysee pack as of v0.2.0. Yes, it's ripped game audio. The author shipped it anyway — see README "Why this exists" for the reasoning. If Oddworld Inhabitants files a takedown, roll back to empty directories.

**Do NOT add more copyrighted packs on top of this one.** One self-aware liability is a judgment call; a second one is a pattern. Any new audio must be:

- Your own original work, OR
- CC0 / public-domain with clear attribution in the commit message, OR
- Kenney.nl / OpenGameArt CC0 pack with a link to the source

Also never commit:
- Sonniss GDC bundle files (license prohibits redistribution as a sound library)
- Sounds whose license you haven't read

Scan with `find sounds -type f \( -iname '*.mp3' -o -iname '*.ogg' -o -iname '*.wav' \)` before every commit if you've been experimenting locally.

## Script rules

- `play-random.sh` must stay macOS-first but silently no-op when `afplay` is unavailable — that's what lets Linux/Windows users install without errors.
- New event types: add the dir under `sounds/default/`, extend the `play-random.sh` docstring's event list, wire a hook entry in `hooks/hooks.json`. Don't forget the `sounds/default/README.md` table.
- The two mute flags (`$CLAUDE_PLUGIN_DATA/muted`, `$HOME/.claude/sounds/muted`) are both honored. Don't remove the legacy global one — the plugin author's prior rig uses it.

## Manifest rules

- `version` lives in `plugin.json` only. Setting it in `marketplace.json` is silently ignored.
- Bump `version` on every behavior change. Existing users won't see updates otherwise (plugins are cached).
- Keep `plugin.json` + `marketplace.json` in sync on `name`, `description`, `author`, `homepage`, `repository`, `license`, `keywords` — use `create-claude-plugin/scripts/sync-plugin.sh` to propagate.

## Always-run commands

Before claiming the plugin works:

```bash
claude plugin validate .
```

Before claiming it's ready to submit to the official marketplace:

```bash
/Users/codyhergenroeder/code/codyhxyz-plugins/create-claude-plugin/scripts/check-submission.sh .
```

For phase progress mid-development:

```bash
/Users/codyhergenroeder/code/codyhxyz-plugins/create-claude-plugin/scripts/check-submission.sh . --status
```

## Pointer

Full walkthrough, reference docs, templates, and submission handoff live in the `create-claude-plugin` skill. Invoke it on phrases like "what's left on this plugin", "plugin status", "ready to submit", "add a skill", or "publish this".
