#!/usr/bin/env bash
# Install the future-proof skill for Claude Code and/or Codex.
#
#   ./install.sh            Claude Code + Codex (whichever is present)
#   ./install.sh --hook     also register the optional Claude Code UserPromptSubmit hook
#   ./install.sh --uninstall
set -euo pipefail

REPO="$(cd "$(dirname "$0")" && pwd)"
WITH_HOOK=0
UNINSTALL=0
for arg in "$@"; do
  case "$arg" in
    --hook) WITH_HOOK=1 ;;
    --uninstall) UNINSTALL=1 ;;
    *) echo "Unknown option: $arg" >&2; exit 1 ;;
  esac
done

CLAUDE_DIR="$HOME/.claude"
CODEX_DIR="$HOME/.codex"
HOOK_PATH="$CLAUDE_DIR/hooks/future-proof-trigger.sh"
START="<!-- future-proof:start -->"
END="<!-- future-proof:end -->"

strip_codex_section() {
  local f="$CODEX_DIR/AGENTS.md"
  [ -f "$f" ] || return 0
  python3 - "$f" "$START" "$END" <<'PY'
import re, sys
path, start, end = sys.argv[1:4]
text = open(path, encoding="utf-8").read()
text = re.sub(r"\n*" + re.escape(start) + r".*?" + re.escape(end) + r"\n?", "\n", text, flags=re.S)
open(path, "w", encoding="utf-8").write(text.rstrip("\n") + "\n")
PY
}

hook_settings() {  # $1 = add | remove
  python3 - "$CLAUDE_DIR/settings.json" "$HOOK_PATH" "$1" <<'PY'
import json, os, sys
path, hook, action = sys.argv[1:4]
data = json.load(open(path)) if os.path.exists(path) else {}
groups = data.setdefault("hooks", {}).setdefault("UserPromptSubmit", [])
groups[:] = [g for g in groups
             if not any(h.get("command") == hook for h in g.get("hooks", []))]
if action == "add":
    groups.append({"hooks": [{"type": "command", "command": hook}]})
if not groups:
    del data["hooks"]["UserPromptSubmit"]
json.dump(data, open(path, "w"), indent=2)
open(path, "a").write("\n")
PY
}

if [ "$UNINSTALL" = 1 ]; then
  rm -rf "$CLAUDE_DIR/skills/future-proof" "$CLAUDE_DIR/agents/future-proof-reviewer.md" \
         "$CODEX_DIR/skills/future-proof" "$HOOK_PATH"
  [ -f "$CLAUDE_DIR/settings.json" ] && hook_settings remove
  strip_codex_section
  echo "future-proof uninstalled."
  exit 0
fi

if [ -d "$CLAUDE_DIR" ]; then
  mkdir -p "$CLAUDE_DIR/skills" "$CLAUDE_DIR/agents"
  rm -rf "$CLAUDE_DIR/skills/future-proof"
  cp -R "$REPO/claude/skills/future-proof" "$CLAUDE_DIR/skills/"
  cp "$REPO/claude/agents/future-proof-reviewer.md" "$CLAUDE_DIR/agents/"
  echo "Claude Code: skill + reviewer agent installed."
  if [ "$WITH_HOOK" = 1 ]; then
    mkdir -p "$CLAUDE_DIR/hooks"
    cp "$REPO/claude/hooks/future-proof-trigger.sh" "$HOOK_PATH"
    chmod +x "$HOOK_PATH"
    [ -f "$CLAUDE_DIR/settings.json" ] && cp "$CLAUDE_DIR/settings.json" "$CLAUDE_DIR/settings.json.bak-future-proof"
    hook_settings add
    echo "Claude Code: UserPromptSubmit hook registered (backup: settings.json.bak-future-proof)."
  fi
fi

if [ -d "$CODEX_DIR" ]; then
  mkdir -p "$CODEX_DIR/skills"
  rm -rf "$CODEX_DIR/skills/future-proof"
  cp -R "$REPO/claude/skills/future-proof" "$CODEX_DIR/skills/"
  strip_codex_section
  { printf '\n%s\n' "$START"; cat "$REPO/codex/AGENTS.md"; printf '%s\n' "$END"; } >> "$CODEX_DIR/AGENTS.md"
  echo "Codex: skill installed, AGENTS.md section added."
fi

echo "Done. Restart Claude Code / Codex to load the skill."
