# Go Code Review Skill

A portable Agent Skill for deep, evidence-based Go code reviews.

## Design

- `SKILL.md` — portable workflow and review contract.
- `references/` — detailed review heuristics loaded as needed.
- `scripts/review-check.sh` — optional, agent-independent verification helper.

The skill is review-only by default and does not depend on Claude Code, Codex,
Cursor, MCP, a particular shell, or a particular model.

## Installation

Copy the directory into the skill directory supported by your agent, or keep
it in a project-local skills directory when the agent supports project skills.

Examples:

```text
.claude/skills/go-code-review/
.codex/skills/go-code-review/
```

The exact discovery directory is agent-specific; the skill contents are not.

## Suggested usage

- "Review this PR deeply for correctness and Go idioms."
- "Do a deep Go code review of this package."
- "Audit this service for concurrency, errors, and unnecessary abstraction."
- "Review this change and report only actionable findings."

## Philosophy

The skill combines normal Go engineering review with the supplied
"de-slop" philosophy: simplify unnecessary abstractions, strengthen types at
boundaries, preserve meaningful validation, and avoid AI-generated ceremony.
It intentionally treats those ideas as evidence-based heuristics rather than
absolute rules.
