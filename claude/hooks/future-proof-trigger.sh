#!/usr/bin/env bash
# future-proof — Claude Code UserPromptSubmit hook.
# When the user's prompt looks like the start of a major build (new product, v2, rewrite,
# feature from scratch), inject a reminder so the future-proof skill runs before code is
# written. Silent otherwise. Never blocks the prompt.
#
# Only the "prompt" field is inspected — not cwd, transcript_path or other metadata — and
# keywords must match as whole words.

exec python3 -c '
import json, re, sys

try:
    prompt = json.load(sys.stdin).get("prompt", "")
except Exception:
    sys.exit(0)

PATTERN = r"""\b(
    from\ scratch | brand[- ]new | greenfield | mvp | v2 | version\ 2 | pivot\ the |
    new\ (product|app|service|tool|platform|agent|feature|saas) |
    build\ (a|an|me\ a)\ (new\ )?(product|app|service|tool|platform|agent|saas) |
    rewrite\ (the|our|this)\ (app|product|service|backend|frontend|platform|system|codebase) |
    re-?architect | re-?platform |
    nouvelle\ fonctionnalit\w* | nouveau\ (produit|projet|service|outil) | refonte |
    de\ z[eé]ro | nueva\ funcionalidad | desde\ cero | neues\ (feature|produkt)
)\b"""

if re.search(PATTERN, prompt, re.IGNORECASE | re.VERBOSE):
    print("[future-proof] This prompt may start a major product evolution or a feature "
          "built from scratch. If it does, run the future-proof skill at the planning "
          "step, before writing code: delegate the 10x / Bitter Lesson evaluation to a "
          "subagent and present the verdict in the user\x27s language. If it is a small "
          "change, ignore this note.")
'
