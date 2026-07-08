# Decision Log Template

The decision log is a Markdown file named
`implementation-notes-<YYYY-MM-DD-HHmmss>.md`, placed in the repository's docs
home (see doc-location discovery in the skill). Seed it at build start with the
structure below.

    # Implementation Notes — <one-line build description>

    **Started:** <YYYY-MM-DD HH:mm:ss>
    **Plan/spec:** <relative path to plan or spec, or "none">

    ## Assumptions carried in

    <Bulleted list seeded from the plan/spec's "Assumptions carried in" section,
    if one exists. Otherwise: "None recorded.">

    ## Decisions

    <Notable non-trivial choices made while executing the plan that were NOT
    forced deviations. Optional; add entries as they occur.>

    ## Deviations

    <One entry per off-plan surprise handled autonomously. Append, never
    rewrite. Each entry:>

    ### <YYYY-MM-DD HH:mm:ss> — <short title>

    - **Surfaced:** <what came up that the plan did not cover>
    - **Chosen:** <the conservative, non-destructive option taken>
    - **Why:** <why this is the conservative/reversible choice>
    - **Revisit:** <what the user may want to review later, if anything>
