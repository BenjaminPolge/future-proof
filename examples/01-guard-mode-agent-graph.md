# Guard mode — a hand-wired customer-support agent

**Prompt**

```
Let's build a customer-support agent from scratch. LangGraph with 9 nodes: intent
classifier, FAQ retriever, order-lookup tool, refund policy checker, tone rewriter,
JSON repair step, self-critique loop, escalation router, and a reply node.
GPT-mini everywhere to keep costs down.
```

The prompt says "from scratch" and describes a new AI system, so the skill runs before any
code is written. The reviewer subagent returns:

```
Future-proof check — Customer-support agent (9-node graph)

Outlook      3 months  6 months  12 months
Score /10       7         5          3

Criteria (12-month view)
🔴 Rides model gains        — A better model makes 5 of the 9 nodes unnecessary instead of better.
🔴 Scaffolding exposure     — Intent classifier, JSON repair, self-critique loop and tone rewriter
                              compensate for the mini model's errors.
🟠 Agent-ready              — Customers' own agents will contact support; there is no API, only chat.
🔴 Cost & latency bet       — "GPT-mini everywhere" plus routing exists only because the large model
                              is expensive today.
⚪ Modality fusion          — n/a (text only).
🟠 Persistent-agent overlap — Simple FAQ answers will be handled by the customer's own assistant.
🟢 Durable moat             — Order data, refund policy and the right to issue refunds stay here.

Verdict: the value lives in order data and refund authority, not in the graph. A frontier model
with three tools replaces most of the orchestration within a year.

Revised plan
- Keep: order lookup, refund policy as a tool with hard limits, escalation to a human.
- Drop or defer: intent classifier, JSON repair, self-critique loop, tone rewriter.
- Change: one frontier model plus 3 tools; expose the same tools as an MCP server so
  customers' agents can resolve tickets directly.
- First step: write 50 eval cases from real tickets and run them on the single-agent version.
```

The 12-month score is below 7, so the agent shows both plans and waits for the user to pick.
