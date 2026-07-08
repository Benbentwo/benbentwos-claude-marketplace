---
description: Interview me one question at a time about ambiguity, prioritizing architecture-changing questions
argument-hint: "[topic or feature to clarify]"
allowed-tools: Read, Write, Edit, Glob, Grep
---

# Clarifying Interview

Run a disciplined architectural-triage interview to make the current idea
decision-complete before building.

Apply the doctrine in the `clarifying-interview` skill exactly:
one question per message, ranked by architectural leverage, multiple-choice with
a named recommendation, tracking knowns vs. unknowns, terminating into the plan.

## Steps

1. Determine the subject:
   - If `$ARGUMENTS` is provided, interview about that topic/feature.
   - If `$ARGUMENTS` is empty, infer the subject from the current conversation
     (what the user is designing or planning). If it is unclear, ask a single
     question: "What are we designing that you'd like me to interview you about?"
2. Restate the goal in one sentence to confirm shared understanding.
3. Ask the single highest-architectural-leverage question. Offer A/B/C options
   and your recommendation with one line of reasoning. Then wait.
4. After each answer: reflect it back, update the knowns/unknowns split, and ask
   the next-highest-leverage question — one at a time.
5. Stop once the remaining unknowns would not change the architecture.
6. Write the outcome into the relevant plan/spec: a **Decisions** section and an
   **Assumptions carried in** section.
