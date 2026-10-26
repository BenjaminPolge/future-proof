#!/usr/bin/env python3
"""Run triggers.jsonl against the Claude Code hook and report mismatches.

Only the "hook" column is checked here. The "skill" column is the behaviour expected from
the agent itself; check it by hand or with run_plan_evals.py-style headless runs.
"""
import json
import pathlib
import subprocess
import sys

ROOT = pathlib.Path(__file__).resolve().parent
HOOK = ROOT.parent / "claude" / "hooks" / "future-proof-trigger.sh"

failures = 0
cases = [json.loads(line) for line in (ROOT / "triggers.jsonl").read_text().splitlines() if line.strip()]
for case in cases:
    payload = json.dumps({
        "hook_event_name": "UserPromptSubmit",
        "prompt": case["prompt"],
        "cwd": case["cwd"],
        "transcript_path": case["cwd"] + "/.claude/transcript.jsonl",
    })
    out = subprocess.run([str(HOOK)], input=payload, capture_output=True, text=True).stdout
    fired = "[future-proof]" in out
    ok = fired == case["hook"]
    failures += not ok
    print(f"{'PASS' if ok else 'FAIL'}  {case['id']:<20} expected={case['hook']!s:<5} got={fired}")

print(f"\n{len(cases) - failures}/{len(cases)} passed")
sys.exit(1 if failures else 0)
