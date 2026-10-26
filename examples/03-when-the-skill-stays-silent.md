# When the skill stays silent

The guard runs only on initiatives that change what the product *is*. None of these prompts
should trigger it:

| Prompt | Why it stays silent |
|---|---|
| *Fix the off-by-one in the pagination of `/orders`.* | Bug fix |
| *Rename `userId` to `accountId` across the codebase.* | Mechanical refactor |
| *Bump React to 19 and fix the warnings.* | Dependency update |
| *Add tests for the invoice module.* | Tests |
| *Change the button colour on the pricing page.* | Cosmetic change |
| *Write the README for this repo.* | Docs |

If the agent produces a future-proof verdict for any of these, the trigger is too broad.
Tighten the "When to run" section of `SKILL.md`, or remove the optional hook.

The hook in `claude/hooks/` matches keywords such as "from scratch", "v2" or "rewrite". It
only *reminds* the agent; the skill itself decides whether the change is major. A prompt like
*"rewrite this error message"* may fire the hook, and the agent should still stay silent.
