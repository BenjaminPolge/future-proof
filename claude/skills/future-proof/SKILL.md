---
name: future-proof
description: Stress-test a product, feature or project against the models of 6 to 12 months from now — roughly 10x better, cheaper and faster than today. Use automatically, before any code is written, whenever a major product evolution, a rewrite, a v2, a new product or a feature built from scratch is being planned or started. Also use on demand for a quick relevance check of an existing project, feature or roadmap item ("will this still matter in a year?", "is this future-proof?", "10x test", "bitter lesson check"). Delegates the evaluation to a subagent and returns scores at 3, 6 and 12 months, a traffic light per criterion and, when the 12-month outlook is weak, a revised plan.
---

# Future-Proof

> "If you were just pushing yourself and just really imagining all of this being roughly
> 10 times better [...] you would build in a different way."
> — Tibo Sottiaux, OpenAI, on Lenny's Podcast (October 2026)

Most products are designed around the limits of the model they were prototyped with. Those
limits move every few months. This skill asks one question before the work starts: **will
what we are about to build still be worth having when the models are roughly 10x better —
in a year?**

It combines two ideas:

- **Tibo Sottiaux's 10x heuristic.** Build as if models will be about 10 times better within
  a year. Most actions on the internet will be taken by agents; models will become far
  cheaper and faster; modalities will merge; the hand-wired loops and graphs of today are a
  temporary phase before persistent agents that learn your goals.
- **Rich Sutton's Bitter Lesson.** General methods that scale with computation beat
  hand-crafted knowledge in the long run. Scaffolding that compensates for today's model
  weaknesses is overtaken by the next model.

**Language: always answer in the language the user is writing in.** The rubric and the
subagent prompt are in English; the verdict shown to the user is not, unless the user writes
in English.

---

## Two modes

### 1. Guard mode — automatic

Run it, without asking first, when the user starts or plans any of these:

- a new product, app, agent, service or tool;
- a feature built from scratch;
- a major evolution: rewrite, v2, re-architecture, migration to a new stack, new core
  workflow, pivot;
- a significant AI component (pipeline, agent loop, RAG system, orchestration graph, eval
  harness, fine-tuning project).

Do **not** run it for bug fixes, small refactors, copy changes, dependency bumps, config
edits, tests, docs, or any change that does not alter what the product *is*. When in doubt
about scale, ask yourself: "would a one-paragraph product brief for this change exist?" If
not, stay silent.

Run it **once per initiative**, at the planning step, before code is written. Do not re-run
it on every follow-up message of the same task. If the user has already run it or says to
skip it, skip it.

### 2. Diagnose mode — on demand

When the user asks for it — "is this future-proof?", "will this still matter in a year?",
"run the 10x test on…", "/future-proof" — evaluate the project, feature or idea they point
to: the current repository, a spec, a roadmap item, a pasted description, a URL to a product.
Same rubric, same output, shorter if the user asks for a quick read.

---

## Procedure

1. **Frame the subject in five lines or fewer**: what it is, who or what uses it, the core
   value it delivers, the main technical bet, and what is still undecided. Read the
   repository, the plan or the brief to do this. Do not ask the user for information you can
   find yourself; if something essential is missing, note it as an assumption.

2. **Delegate the evaluation to a subagent**, so the verdict is not anchored on the plan you
   are about to execute:
   - Claude Code: spawn the `future-proof-reviewer` agent if it is installed; otherwise a
     general-purpose agent.
   - Codex or any harness with subagents: spawn one with the same brief.
   - No subagent available: do the evaluation yourself in a separate, explicit pass, and
     argue against the plan before you argue for it.

   The brief contains: the five-line framing, the relevant file paths or excerpts, the path
   to `references/rubric.md` (or its content if the subagent cannot read files), the user's
   language, and the mode (guard or diagnose). Ask for the output format below and nothing
   else.

3. **Relay the verdict** in the user's language, using the format below. Do not soften it.

4. **Act on the verdict.**
   - 12-month score **7 or more**: show the verdict in a compact form and carry on with the
     work.
   - 12-month score **below 7**: present the revised plan next to the original and let the
     user choose before writing code. Do not start building either version until they do.
   - In diagnose mode, stop after the verdict.

---

## Output format

```
Future-proof check — <subject>

Outlook      3 months  6 months  12 months
Score /10       8         6          4

Criteria (12-month view)
🟢 Rides model gains        — <one line>
🟠 Scaffolding exposure     — <one line>
🔴 Agent-ready              — <one line>
🟢 Cost & latency bet       — <one line>
🟠 Modality fusion          — <one line>
🔴 Persistent-agent overlap — <one line>
🟢 Durable moat             — <one line>

Verdict: <three lines at most — what survives, what gets eaten, by what>

Revised plan (only if 12-month score < 7)
- Keep: …
- Drop or defer: …
- Change: …
- First step: …
```

Rules for the output:

- Scores are integers. A score is a judgement, not a measurement; say so if the user treats
  it as one.
- Each criterion line names the concrete part of the product it refers to. "Good
  architecture" is not a reason; "the hand-written intent router in `router.py`" is.
- Mark a criterion ⚪ *n/a* when it genuinely does not apply rather than forcing a colour.
- The revised plan keeps the user's goal and changes the bet. It must be buildable now,
  with today's models; "wait for GPT-7" is not a plan.
- Never invent market data, user numbers or model roadmaps. Model progress is assumed from
  the 10x heuristic, not from any vendor's private plan.

---

## The criteria (summary)

The full rubric, with questions, red flags and good signs for each criterion, is in
[`references/rubric.md`](references/rubric.md). Load it when you brief the subagent.

1. **Rides model gains** — does the product get better automatically when the model gets
   better, or does a better model make it redundant?
2. **Scaffolding exposure** — how much of the value is code that compensates for current
   model weaknesses (prompt chains, hand-wired graphs, retries, parsers, routers, guardrails
   for errors the next model will not make)?
3. **Agent-ready** — can an agent use it (API, MCP, structured data, programmatic auth), or
   does it assume a human clicking through a UI?
4. **Cost & latency bet** — does the design depend on today's prices and speeds (aggressive
   caching, small-model routing, batching, "too expensive to run on every item")?
5. **Modality fusion** — does it stitch separate text, speech, vision and OCR steps that a
   single native multimodal model will handle?
6. **Persistent-agent overlap** — does it rebuild memory, preferences, goals or task
   management that a general persistent agent (Dots, ChatGPT, Claude…) will own?
7. **Durable moat** — what survives a 10x model: proprietary data, distribution, trust,
   regulation, integration depth, taste, community, physical-world access?

---

## What this skill does not do

- It does not predict the future. It applies a deliberately aggressive assumption to expose
  bets that are fragile under that assumption.
- It does not argue against building. Plenty of things worth building today will be
  obsolete in a year; shipping them can still be the right call. The point is to know it.
- It does not block. It informs, proposes, and lets the user decide.
