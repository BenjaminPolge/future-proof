# Future-Proof

Condensed mirror of the `future-proof` skill, for Codex. The canonical version lives in
`claude/skills/future-proof/SKILL.md` of the future-proof repository; keep the two in sync.

## Rule

Before writing code for a **major product evolution** — a new product, a feature built from
scratch, a rewrite, a v2, a re-architecture, a pivot, a significant AI component — run the
future-proof check once, at the planning step, without asking first. Skip it for bug fixes,
small refactors, config, tests and docs. Also run it whenever the user asks "is this
future-proof?", "will this still matter in a year?" or "run the 10x test".

Always answer in the language the user is writing in.

## The check

Assume frontier models are roughly **10x better, cheaper and faster within a year**, and that
agents take most actions on the internet (Tibo Sottiaux, OpenAI). General methods that scale
with compute beat hand-crafted structure (Sutton, *The Bitter Lesson*).

Delegate to a subagent if available; otherwise run it as a separate pass that argues against
the plan first. If the `future-proof` skill is installed in `~/.codex/skills/`, read its
`references/rubric.md`. Score the subject at 3, 6 and 12 months (integers /10) and give a
traffic light (🟢 holds, 🟠 at risk, 🔴 breaks, ⚪ n/a) for each criterion:

1. **Rides model gains** — better model improves it, or makes it redundant?
2. **Scaffolding exposure** — value in chains, graphs, routers, parsers, retries that
   compensate for today's model?
3. **Agent-ready** — usable by agents (API, MCP, structured data), or human UI only?
4. **Cost & latency bet** — design depends on today's prices and speeds?
5. **Modality fusion** — glue between STT, OCR, vision, TTS a native model will absorb?
6. **Persistent-agent overlap** — rebuilds memory, goals or tasks a general agent will own?
7. **Durable moat** — data, distribution, trust, regulation, integration, taste?

Then a verdict of three lines at most. Every line names a concrete component.

## Act on it

- 12-month score ≥ 7: show the verdict compactly and continue.
- 12-month score < 7: present a revised plan (keep / drop or defer / change / first step),
  buildable with today's models, next to the original. Wait for the user to choose before
  writing code.
- Never invent market data or vendor roadmaps. Never block; inform and propose.
