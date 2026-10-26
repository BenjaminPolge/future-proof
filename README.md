# future-proof

**A skill for Claude Code and Codex that asks one question before you build: *will this
still matter when the models are 10x better, in a year?***

> "If you were just pushing yourself and just really imagining all of this being roughly
> 10 times better [...] you would build in a different way."
> — Tibo Sottiaux, OpenAI, on [Lenny's Podcast](https://x.com/lennysan/status/2107131339355181240)
> (October 2026)

Most products are designed around the limits of the model they were prototyped with: a
router because the model picks the wrong tool, a JSON repair step because it breaks the
schema, a small model everywhere because the big one is expensive, a chat UI because nobody
thought an agent would be the customer. Those limits move every few months. The code built
around them does not.

Coding agents make this worse. They build exactly what you ask for, quickly, and never ask
whether the plan is anchored on today's model. This skill makes them ask.

```
Future-proof check — Customer-support agent (9-node graph)

Outlook      3 months  6 months  12 months
Score /10       7         5          3

Criteria (12-month view)
🔴 Rides model gains        — A better model makes 5 of the 9 nodes unnecessary.
🔴 Scaffolding exposure     — Intent classifier, JSON repair and self-critique loop
                              compensate for the mini model's errors.
🟠 Agent-ready              — Customers' own agents will contact support; there is no API.
🔴 Cost & latency bet       — "GPT-mini everywhere" exists because the big model is expensive.
⚪ Modality fusion          — n/a
🟠 Persistent-agent overlap — Simple FAQ answers will be handled by the customer's assistant.
🟢 Durable moat             — Order data and refund authority stay here.

Verdict: the value lives in order data and refund authority, not in the graph.

Revised plan
- Keep: order lookup, refund policy tool, human escalation.
- Drop: intent classifier, JSON repair, self-critique loop, tone rewriter.
- Change: one frontier model + 3 tools, exposed as an MCP server.
- First step: 50 eval cases from real tickets, run on the single-agent version.
```

It does not tell you not to build. It tells you which of your bets expire, and proposes the
version that doesn't.

## Self-test: we ran it on itself

The first real run of the skill was on this repository. It scored itself **7 / 5 / 3** at 3,
6 and 12 months:

- 🔴 **Scaffolding exposure** — the keyword trigger hook is a hand-written intent router,
  exactly what criterion 2 flags. It also grepped the whole hook payload, so a project path
  containing "v2" fired it on every message.
- 🔴 **Persistent-agent overlap** — the whole trigger apparatus boils down to a preference
  ("before building, apply the 10x test") that a persistent agent will store in one line of
  memory.
- 🔴 **Durable moat** — a rubric in Markdown, under Apache 2.0, is copyable in a minute.
- 🟢 What survives: the rubric itself and the independent reviewer subagent.

We took the revised plan: the hook now reads only the prompt and matches whole words, the
Codex section shrank to a pointer, the verdict gained a JSON block and an autonomous mode,
and an [`evals/`](evals/) folder now tracks when the scaffolding can be deleted. A skill
built on the Bitter Lesson should expect to be eaten by it. This one is designed to be
useful for the next six to twelve months, and to tell you when it no longer is.

---

## The idea

Two ideas are combined into one rubric.

**Tibo Sottiaux's 10x heuristic.** In an October 2026 interview on Lenny's Podcast, recorded
at OpenAI DevDay, OpenAI's Tibo Sottiaux argued that builders should imagine everything being
roughly ten times better within a year, and build accordingly. What people do not price in
enough, in his view: most actions on the internet will soon be taken by agents; models will
become much cheaper and faster; modalities will merge; and the hand-configured agent loops and
graphs of today are a temporary phase before persistent agents that learn your goals.

**Rich Sutton's [Bitter Lesson](http://www.incompleteideas.net/IncIdeas/BitterLesson.html).**
General methods that leverage computation win in the long run, by a large margin.
Hand-crafted structure helps in the short term, plateaus, then gets overtaken by the next
general method.

Put together, they give a practical test for any plan: which parts get *better* when the
model improves, and which parts only exist *because* the model is not good enough yet?

## What it does

- **Guard mode (automatic).** When you start a new product, a feature from scratch, a
  rewrite, a v2 or a significant AI component, the agent runs the check at the planning
  step, before writing code, without asking first.
- **Diagnose mode (on demand).** Ask *"is this future-proof?"*, *"will this still matter in
  a year?"* or *"run the 10x test on…"* to get a quick read on a repo, a spec, a roadmap item
  or a product idea.
- **Delegates to a subagent.** The evaluation runs in a separate reviewer agent so the
  verdict is not anchored on the plan the main agent is about to execute.
- **Scores 3, 6 and 12 months** on a 0–10 scale, with a traffic light for each of seven
  criteria.
- **Proposes a revised plan** when the 12-month score is below 7, and waits for you to pick
  before writing code.
- **Answers in your language.** The rubric is in English; the verdict comes back in the
  language you write in.
- **Works without a human.** Each verdict ends with a JSON block (scores, traffic lights,
  `revised_plan_required`). In headless runs (`claude -p`, `codex exec`, CI, delegated
  agents) the agent logs the verdict to `FUTURE_PROOF.md` and follows the revised plan
  instead of waiting for an answer — unless that would change the scope the task asked for.

## The seven criteria

| # | Criterion | The question |
|---|---|---|
| 1 | Rides model gains | Does a better model make it better, or make it unnecessary? |
| 2 | Scaffolding exposure | How much of the value compensates for today's model (chains, graphs, routers, parsers, retries)? |
| 3 | Agent-ready | Can an agent use it — API, MCP, structured data — or does it assume a human clicking? |
| 4 | Cost & latency bet | Does the design depend on today's prices and speeds? |
| 5 | Modality fusion | Is the value in glue between STT, OCR, vision and TTS that a native model will absorb? |
| 6 | Persistent-agent overlap | Does it rebuild memory, goals or tasks that a general assistant will own? |
| 7 | Durable moat | What survives a 10x model: data, distribution, trust, regulation, integration, taste? |

Questions, red flags and good signs for each are in
[`references/rubric.md`](claude/skills/future-proof/references/rubric.md).

## What it does not do

- It does not predict the future. It applies a deliberately aggressive assumption to expose
  fragile bets.
- It does not argue against shipping. Something obsolete in a year can still be worth
  building this quarter — as long as you know it.
- It does not block. It informs, proposes, and lets you decide.
- It does not fire on bug fixes, refactors, dependency bumps, tests or docs. See
  [`examples/03-when-the-skill-stays-silent.md`](examples/03-when-the-skill-stays-silent.md).

---

## Automatic installation with Claude Code or Codex

Paste this into Claude Code or Codex:

```
Install the skill from https://github.com/BenjaminPolge/future-proof. Clone it, read
install.sh before running it, then run it with --hook if I use Claude Code. Verify that
the skill, the reviewer agent and (for Codex) the AGENTS.md section are in place.
Do not modify my other configuration.
```

## Manual installation

```bash
git clone https://github.com/BenjaminPolge/future-proof.git
cd future-proof
./install.sh          # skill + reviewer agent for Claude Code, skill + AGENTS.md for Codex
./install.sh --hook   # same, plus the optional Claude Code trigger hook
```

The script installs into whichever of `~/.claude` and `~/.codex` exists. Restart your agent
afterwards.

What goes where:

| File | Claude Code | Codex |
|---|---|---|
| `claude/skills/future-proof/` | `~/.claude/skills/future-proof/` | `~/.codex/skills/future-proof/` |
| `claude/agents/future-proof-reviewer.md` | `~/.claude/agents/` | — |
| `codex/AGENTS.md` (6-line pointer) | — | appended to `~/.codex/AGENTS.md` between markers |
| `claude/hooks/future-proof-trigger.sh` (optional) | `~/.claude/hooks/` + `UserPromptSubmit` entry in `settings.json` | — |

**Why a hook?** Claude Code already loads the skill when the request matches its
description. The hook makes guard mode more reliable: when your prompt contains whole words
like *from scratch*, *v2*, *rewrite the backend* or *new product* (in English, French,
Spanish or German), it adds a short reminder to the agent's context. It reads only your
prompt — not the project path or other metadata — never blocks, and stays silent otherwise.
The installer backs up `settings.json` before touching it.

**Why AGENTS.md for Codex?** Codex reads `AGENTS.md` on every turn, which is what makes the
guard automatic there. The section is a six-line pointer to the installed `SKILL.md`, so
there is a single source of truth and nothing to keep in sync. For a project-level install,
adjust the path in the pointer.

For a single project instead of a global install, copy the skill folder to
`.claude/skills/` at the repository root, or append `codex/AGENTS.md` to the project's
`AGENTS.md`.

## Check that it works

Start a fresh session and try:

| Prompt | What you should see |
|---|---|
| *Let's build a customer-support agent from scratch with a 9-node LangGraph and GPT-mini everywhere.* | A verdict before any code, low 12-month score, revised plan, and a question asking which plan to follow |
| *Is this repo future-proof?* (in a repo with an API and an MCP server) | A short verdict, high scores, no revised plan |
| *Fais le test des 10x sur ce projet.* | The same verdict, in French |
| *Fix the off-by-one in the pagination.* | **Nothing** — the skill stays quiet |

Worked versions are in [`examples/`](examples/).

## Evals

The [`evals/`](evals/) folder exists to answer one question: **when can the scaffolding go?**

```bash
python3 evals/run_hook_evals.py     # 18 prompts: should the trigger hook fire or not? Free, instant.
python3 evals/run_plan_evals.py     # 6 plans with an expected 12-month score range. One headless
                                    # Claude Code run per plan.
```

- `triggers.jsonl` lists prompts with the expected behaviour of the hook and of the skill,
  including traps such as a bug fix in a folder named `shop-v2`, "pivot table" or "rewrite
  this error message".
- `plans.jsonl` lists plans that should clearly fail (a 9-node agent graph, an OCR→LLM→regex
  pipeline, a standalone memory app) or clearly pass (an agent-ready data API, agent payment
  rails, an eval platform).

Re-run both on every new model. When the skill triggers correctly without the hook, delete
the hook. When the scores drift, revisit the rubric.

## Update and uninstall

```bash
cd future-proof && git pull && ./install.sh      # update (add --hook if you use it)
./install.sh --uninstall                          # remove everything, including the hook
```

---

## Repository layout

```
future-proof/
├── claude/
│   ├── skills/future-proof/
│   │   ├── SKILL.md                 the skill, canonical version (Claude Code and Codex)
│   │   └── references/rubric.md     full rubric, read by the reviewer subagent
│   ├── agents/future-proof-reviewer.md   the reviewer subagent (Claude Code)
│   └── hooks/future-proof-trigger.sh     optional trigger hook (Claude Code)
├── codex/AGENTS.md                  six-line pointer for Codex's always-on instructions
├── evals/                           trigger cases, scored plans, and their runners
├── examples/                        guard mode, diagnose mode, and when it stays silent
├── install.sh
├── README.md
└── LICENSE
```

`SKILL.md` and `rubric.md` are the single source of truth; everything else points to them.

## Limits

- **The scores are judgements, not measurements.** A language model applies a rubric. Treat
  the output as an argument to weigh, not a number to optimize.
- **The 10x assumption is deliberately aggressive.** Progress may be slower in your domain.
  The point is to find the bets that only work if it is.
- **Keyword triggers are blunt.** The hook misses major builds phrased without its keywords
  (the skill description is the fallback) and can still fire on an ambiguous phrase; the
  skill is instructed to ignore small changes, but it can misjudge scale either way.
- **No vendor roadmaps.** The skill is told never to invent market data or model release
  plans. If you see some in a verdict, it is a bug.

## Credits

The framing comes from Tibo Sottiaux's interview on Lenny's Podcast (October 2026) and Rich
Sutton's *The Bitter Lesson* (2019). This project is not affiliated with or endorsed by
OpenAI, Lenny's Podcast or Rich Sutton.

## About

Built by Benjamin Polge, journalist covering AI and infrastructure at
[JDN (Journal du Net)](https://www.journaldunet.com/), to turn an idea heard on a podcast into
a habit for anyone building with coding agents.

## License

[Apache 2.0](LICENSE) — Copyright 2026 Benjamin Polge for JDN (Journal du Net)
