# concise-tldr

An [output style](https://code.claude.com/docs/en/output-styles) for terse, scannable replies — built for the person who kicks off work, goes and does something else, and comes back to read what happened.

```shell
/plugin install concise-tldr@benbentwos-claude-marketplace
```

## What it does

Every status, progress, or completion update comes back as exactly three labeled bullets:

- **What changed** — the delta since the last update
- **Where we're at** — built? verified? blocked? shipped?
- **What's next** — the immediate next action, or "nothing — done"

A fourth bullet, **Lessons learned**, is appended only when the work surfaced something non-obvious worth carrying forward — a gotcha that cost real time, a trap the next session would hit. It's skipped when there's nothing genuinely new, so it doesn't decay into ritual.

Everything else follows from the same goal: lead with the outcome in one line, no narration between tool calls, detail only on request or at a real decision point.

The one rule that keeps it usable: **full sentences, never cryptic fragments.** Exact SHAs, file paths, build verdicts, and error text stay in. A terse update that forces a follow-up question saved nothing.

## Enabling it

Installing the plugin makes the style available; it does not switch you to it. Run `/config`, select **Output style**, and pick **Concise TLDR**. It takes effect after `/clear` or on your next session.

To set it without the menu, add this to a settings file:

```json
{
  "outputStyle": "Concise TLDR"
}
```

## Notes

- **`keep-coding-instructions: true`** is set, so Claude Code's built-in software-engineering instructions stay in the system prompt. This style changes how Claude *communicates*, not how it works. (Custom output styles drop those instructions by default — worth knowing if you fork this file.)
- **`force-for-plugin` is deliberately not set.** The style is opt-in via `/config`; enabling the plugin will not override an output style you already chose.
- Output styles apply to the main conversation only. Subagents run their own system prompt, so they aren't affected.

## Customizing

The whole plugin is one Markdown file: [`output-styles/concise-tldr.md`](output-styles/concise-tldr.md). Copy it to `~/.claude/output-styles/` (user scope) or `.claude/output-styles/` (project scope, shareable via the repo) and edit freely — the three-bullet shape is the load-bearing part; the rest is tuning.
