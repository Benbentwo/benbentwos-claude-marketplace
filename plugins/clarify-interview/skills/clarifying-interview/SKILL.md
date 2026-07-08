---
name: clarifying-interview
description: This skill should be used when the user is designing, planning, architecting, or scoping something new — e.g. "let's build X", "design X", "plan X", "how should I structure X", "I want to add X", or before entering plan mode. Runs a disciplined architectural-triage interview: one question at a time, prioritizing questions whose answer would change the architecture. Use before writing code or a spec, whenever requirements are ambiguous.
version: 0.1.0
---

# Clarifying Interview

Turn an ambiguous idea into a decision-complete plan by interviewing the user
**one question at a time**, prioritizing the questions whose answers would
change the architecture.

## When to use

Any time the user is designing, planning, or scoping work and the requirements
are not yet decision-complete. Prefer this the moment ambiguity would change
*what gets built*, not just how it looks.

This is a narrow, disciplined complement to broad brainstorming: its only job is
architectural-triage questioning. If a full design-doc lifecycle is wanted,
defer to that; this skill is the questioning engine.

## Doctrine

1. **One question per message.** Never batch. If a topic needs more, split it
   across turns.
2. **Rank by architectural leverage.** Before asking, sort candidate questions
   by how much the answer changes the architecture. Ask the fork-in-the-road
   questions first. Defer or drop cosmetic ones.
3. **Multiple-choice when possible.** Offer concrete options (A/B/C). They are
   easier to answer than open-ended prompts.
4. **Always name a recommendation.** Lead with the option you recommend and one
   line of reasoning, so the user can approve by default.
5. **Track knowns vs. unknowns.** Keep an explicit running split: what is now
   settled, what is still open.
6. **Terminate into the plan.** When the architecture-changing questions are
   resolved, stop interviewing and write the outcome into the plan/spec:
   - **Decisions** — what was settled and why.
   - **Assumptions carried in** — known-but-unresolved items the build should
     watch for. These are what the companion decision-maker plugin reads later.

## How to run the interview

- Open by restating the goal in one sentence to confirm shared understanding.
- Ask question 1 (highest architectural leverage). Wait for the answer.
- After each answer, briefly reflect it back, update the knowns/unknowns split,
  then ask the next-highest-leverage question.
- Stop when remaining unknowns would not change the architecture — do not drill
  into cosmetic detail. Interrupting up front is cheap; over-interviewing wastes
  the user's time.
- Close by writing Decisions + Assumptions into the plan/spec.

## What NOT to do

- Do not ask two questions in one message.
- Do not ask cosmetic questions before architectural ones.
- Do not continue interviewing once the architecture is settled.
- Do not silently assume — if an architecture-changing ambiguity remains, ask.
