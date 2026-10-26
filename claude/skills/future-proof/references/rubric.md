# Future-Proof rubric

Evaluate the subject as if it ships today and is judged in 3, 6 and 12 months, assuming
frontier models become **roughly 10x better within a year**: more capable at reasoning,
coding and tool use; far cheaper; far faster; natively multimodal; running as persistent
agents that act on the internet on people's behalf.

Be adversarial. Your job is to find the bets that break under that assumption, not to
reassure. Then be constructive: propose the version of the plan that survives.

Write the final verdict in the language specified in the brief.

---

## Sources of the frame

- **Tibo Sottiaux (OpenAI), Lenny's Podcast, October 2026.** Builders should imagine
  everything being roughly 10 times better in a year and build differently. What people do
  not price in enough: most internet actions will be taken by agents; models will get much
  cheaper and faster; modalities will merge; the era of hand-configured agent loops and
  graphs is ending, replaced by persistent agents that learn goals and preferences.
- **Rich Sutton, "The Bitter Lesson" (2019).** General methods that leverage computation
  are ultimately the most effective, by a large margin. Building in human knowledge and
  hand-crafted structure helps in the short term, plateaus, and is then overtaken.

---

## Scoring

For each horizon (3, 6, 12 months), give an integer from 0 to 10:

| Score | Meaning |
|---|---|
| 9–10 | Gets stronger as models improve. Core value is untouched by a 10x model. |
| 7–8  | Mostly holds. Some components will need rework; the core bet stands. |
| 5–6  | Mixed. A large part of the value is exposed; needs a strategic change. |
| 3–4  | Fragile. A better model or a general agent covers most of it. |
| 0–2  | Likely obsolete. The product exists mainly because of a current limitation. |

Scores normally decline or stay flat over time. A score that rises over time is allowed
only if the product genuinely benefits from better models (e.g. a platform whose value grows
with agent traffic); explain why.

For each criterion, give a traffic light for the 12-month view: 🟢 holds, 🟠 at risk,
🔴 breaks, ⚪ n/a.

---

## The seven criteria

### 1. Rides model gains

*Does a better model make this product better, or make it unnecessary?*

- Ask: if we swapped in a model 10x better tomorrow, would the product improve on its own,
  stay the same, or lose its reason to exist?
- 🔴 Red flags: the value proposition is "we make the model good at X" when X is a general
  capability (summarizing, coding, extraction, writing); thin wrapper on one prompt; the
  product's main feature is a workaround for a known model weakness.
- 🟢 Good signs: the model is a swappable engine; better models unlock new features rather
  than replace existing ones; evals exist so upgrades can be adopted quickly.

### 2. Scaffolding exposure (Bitter Lesson)

*How much of the work compensates for today's model?*

- Ask: which components exist only because the current model cannot do it reliably in one
  pass? Estimate the share of engineering effort they represent.
- 🔴 Red flags: hand-built orchestration graphs, multi-step prompt chains, intent routers,
  regex/JSON repair layers, elaborate retry and self-check loops, handcrafted rules or
  taxonomies standing in for model judgement, chunking strategies tuned to small contexts,
  fine-tuning to teach a skill frontier models are acquiring anyway.
- 🟢 Good signs: thin harness, model does the reasoning, scaffolding is isolated and easy to
  delete; investments go into data, evals and tools rather than control flow.
- Note: some scaffolding is legitimate — security boundaries, permissions, audit logs,
  compliance, determinism required by law. Those are not exposure.

### 3. Agent-ready

*Will agents be able to use it — and will they be the main users?*

- Ask: if most actions on this product were taken by an AI agent on someone's behalf, does
  it still work? Does it still make money?
- 🔴 Red flags: value delivered only through a human UI; no API or MCP server; auth that
  requires a human; business model based on ad impressions or human attention in a flow that
  agents will perform; anti-bot design on core actions; information locked in unstructured
  pages.
- 🟢 Good signs: clean API/MCP, structured outputs, idempotent actions, rate limits and
  pricing designed for agent traffic, a model where being chosen by an agent is a
  distribution channel.

### 4. Cost & latency bet

*Does the design depend on today's prices and speeds?*

- Ask: what decisions were made because inference is expensive or slow today? Do they still
  make sense at 10x cheaper and faster?
- 🔴 Red flags: product limited to "the important items" because running on everything is
  too expensive; complex small-model routing built only to save cost; async/batch UX
  designed around slow responses; a moat that is "we are cheaper than calling GPT".
- 🟢 Good signs: design would expand naturally with cheaper inference (run on everything,
  in real time, more often); cost optimizations are isolated and removable.

### 5. Modality fusion

*Does it stitch together modalities a single model will handle natively?*

- Ask: does the pipeline convert between modalities (speech→text→LLM→text→speech, image→OCR→
  text) because the model cannot handle them directly?
- 🔴 Red flags: core value in the glue between STT, LLM, TTS, OCR or vision models; text-only
  design for a problem that is naturally visual or vocal.
- 🟢 Good signs: modality-agnostic design; value lies in what is done with the content, not
  in converting it. ⚪ when the product has no multimodal dimension.

### 6. Persistent-agent overlap

*Is it rebuilding what a general persistent agent will own?*

- Ask: will the user's general assistant (ChatGPT, Claude, Gemini, Dots, OS-level agents)
  do this as part of knowing their goals, memory and context?
- 🔴 Red flags: standalone memory/preferences layer; to-do or task orchestration for
  personal goals; "assistant for X" where X is a generic knowledge-work task; a new app the
  user must remember to open for something an ambient agent could just do.
- 🟢 Good signs: product plugs into general agents (as a tool, a data source, an action)
  rather than competing with them; holds context the general agent cannot access.

### 7. Durable moat

*What survives a 10x model?*

- Ask: if a competitor had the same 10x model, what would they still lack?
- 🟢 Moats that hold: proprietary or continuously generated data; distribution and an
  existing audience; trust, brand and accountability; regulatory approval; deep integration
  in a workflow or in physical operations; network effects; human taste and editorial
  judgement; community.
- 🔴 Weak moats: prompt engineering; being early; a UX wrapper; a fine-tune on public data;
  "we integrated the model first".

---

## Revised plan

Produce it when the 12-month score is below 7. It must:

1. keep the user's underlying goal;
2. drop or defer the components that a 10x model makes redundant;
3. move investment toward what scores well on criteria 1, 3 and 7 (rides gains, agent-ready,
   durable moat);
4. be buildable now with today's models — use them where they are good enough, and design
   the rest so the next model slots in;
5. name the first concrete step.

Keep it to four to eight bullet points.

---

## Output

Return exactly the format requested in the brief: score table (3/6/12 months), seven
criterion lines with traffic lights, a verdict of three lines at most, and the revised plan
when required. Every line must refer to a concrete component of the subject. No preamble.
