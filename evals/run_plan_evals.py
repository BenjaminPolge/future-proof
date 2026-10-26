#!/usr/bin/env python3
"""Score every plan in plans.jsonl with the installed skill, headless, and check the
12-month score falls in the expected range.

Requires Claude Code (`claude -p`) with the skill installed. Costs one agent run per plan.
Re-run it on every new model release: when the scores drift, the rubric needs a look.

    python3 evals/run_plan_evals.py            # all plans
    python3 evals/run_plan_evals.py cadastral-api
"""
import json
import pathlib
import re
import subprocess
import sys

ROOT = pathlib.Path(__file__).resolve().parent
PROMPT = (
    "Use the future-proof skill in diagnose mode on the plan below. This is an autonomous "
    "run: do not ask questions, do not write files, and end with the JSON block.\n\nPlan: {plan}"
)

wanted = set(sys.argv[1:])
cases = [json.loads(l) for l in (ROOT / "plans.jsonl").read_text().splitlines() if l.strip()]
cases = [c for c in cases if not wanted or c["id"] in wanted]

failures = 0
for case in cases:
    out = subprocess.run(["claude", "-p", PROMPT.format(plan=case["plan"])],
                         capture_output=True, text=True, timeout=900).stdout
    blocks = re.findall(r"```json\s*(\{.*?\})\s*```", out, re.S)
    if not blocks:
        failures += 1
        print(f"FAIL  {case['id']:<22} no JSON block in output")
        continue
    verdict = json.loads(blocks[-1])
    score = verdict["scores"]["12m"]
    ok = case["min_12m"] <= score <= case["max_12m"] and \
        verdict.get("revised_plan_required") == case["revised_plan_required"]
    failures += not ok
    print(f"{'PASS' if ok else 'FAIL'}  {case['id']:<22} 12m={score} "
          f"expected={case['min_12m']}-{case['max_12m']} "
          f"revised={verdict.get('revised_plan_required')}")

print(f"\n{len(cases) - failures}/{len(cases)} passed")
sys.exit(1 if failures else 0)
