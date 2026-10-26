#!/usr/bin/env bash
# future-proof — Claude Code UserPromptSubmit hook.
# When the prompt looks like the start of a major build (new product, v2, rewrite,
# feature from scratch), inject a reminder so the future-proof skill runs before code
# is written. Silent otherwise. Never blocks the prompt.

input="$(cat)"

pattern='(from scratch|brand[- ]new|new (product|app|service|tool|platform|agent|feature)|build (a|an|me a|the) |v2|version 2|rewrite|re-?architect|re-?platform|migrate (to|the)|pivot|greenfield|mvp|start a (new )?project|nouvelle fonctionnalit|nouveau (produit|projet|service|outil)|refonte|r[ée][ée]criture|de z[ée]ro|nueva funcionalidad|desde cero|neues (feature|produkt))'

if printf '%s' "$input" | grep -Eiq "$pattern"; then
  cat <<'EOF'
[future-proof] This prompt may start a major product evolution or a feature built from scratch. If it does, run the future-proof skill at the planning step, before writing code: delegate the 10x / Bitter Lesson evaluation to a subagent and present the verdict in the user's language. If it is a small change, ignore this note.
EOF
fi

exit 0
