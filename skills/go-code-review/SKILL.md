---
name: go-code-review
description: >
  Perform deep, evidence-based reviews of Go codebases, pull requests, and
  changes. Use for correctness, security, concurrency, error handling,
  API design, testing, architecture, idiomatic Go, and unnecessary
  abstraction or AI-generated complexity. Review-only by default; never
  modify code unless explicitly asked.
---

# Go Code Review

## Mission

Review Go code as an experienced Go engineer would: understand intent first,
find real problems second, and recommend the smallest change that materially
improves correctness, safety, clarity, or maintainability.

The goal is **not** maximum findings, maximum line reduction, or stylistic
uniformity. Prefer boring, explicit, strongly typed, traceable Go.

Core principle:

> Validate and normalize uncertainty at system boundaries. Keep trusted
> internal code concrete, explicit, and easy to reason about.

This skill is portable. Do not assume a particular agent, CLI, IDE, MCP
server, shell, patch format, or tool is available. Use ordinary repository
inspection and standard Go commands when available.

## Operating modes

Default mode is **review-only**.

- Do not edit files.
- Do not create commits.
- Do not rewrite tests.
- Do not refactor automatically.
- Do not delete code merely because it looks unnecessary.

If the user explicitly asks for fixes, first produce or preserve the review
findings, then make changes, then run verification and report what changed.

## Non-negotiable review rules

1. **Evidence over pattern matching.** A suspicious pattern is a lead, not a
   finding. Trace its callers, implementations, data origin, and tests.
2. **Intent before simplification.** Do not remove validation, nil checks,
   interfaces, copies, wrappers, or concurrency without establishing why they
   exist and whether the state is genuinely possible.
3. **Correctness beats elegance.** A shorter implementation is not better if
   it weakens error handling, ownership, cancellation, validation, or API
   contracts.
4. **Boundary-first typing.** If internal code repeatedly handles `any`, maps,
   type assertions, or conversion helpers, trace the value back to its source.
   Prefer fixing the type at the boundary.
5. **No architecture by stereotype.** Do not report a layer, interface,
   factory, builder, DTO, repository, or option struct merely because its name
   sounds suspicious.
6. **No style masquerading as a defect.** Label subjective improvements as
   suggestions, not bugs.
7. **Do not optimize unmeasured performance.** Require evidence for pools,
   caching, lock-free structures, custom allocation, unsafe tricks, or complex
   concurrency.
8. **Preserve meaningful idiomatic Go.** `if err != nil`, map `ok` checks,
   explicit switches, simple constructors, and early returns are not problems
   by themselves.
9. **Prefer root-cause fixes.** If complexity exists because an upstream value
   is poorly typed, fix the source instead of adding downstream helpers.
10. **Keep the review proportional.** Deep does not mean indiscriminate.

## Phase 1 — Discover the repository

Before judging code, establish enough context to understand it.

Inspect, as applicable:

- repository layout
- `go.mod` and `go.work`
- Go version
- module boundaries
- `cmd/`, `internal/`, `pkg/`, and application entry points
- package dependencies and import direction
- tests, benchmarks, examples, test fixtures
- generated code
- build scripts / Makefiles / task runners
- CI configuration
- lint and static-analysis configuration
- project-local agent instructions such as `AGENTS.md`, `CLAUDE.md`, or
  equivalent guidance
- README/design documents when they explain intended behavior

Do not spend equal effort everywhere. Identify externally reachable,
state-changing, security-sensitive, concurrent, and persistence-heavy paths.

## Phase 2 — Determine review scope

If reviewing a diff/PR:

1. Read the complete diff.
2. Identify changed packages and their callers.
3. Inspect adjacent code needed to understand contracts.
4. Check tests covering changed behavior.
5. Trace changed data across boundaries.
6. Review deleted code too: removals can break contracts.

If reviewing a whole codebase:

1. Map major packages and entry points.
2. Identify high-risk flows.
3. Sample representative packages.
4. Search for high-signal patterns from the reference files.
5. Deep-review suspicious areas rather than mechanically auditing every match.

## Phase 3 — Review dimensions

Review in roughly this order:

1. Correctness and behavioral regressions
2. Security and trust boundaries
3. Concurrency, cancellation, and lifecycle
4. Error handling and failure semantics
5. Resource ownership and cleanup
6. Data/API contracts and type safety
7. Persistence and transactional behavior
8. Testing and observability
9. Architecture and dependency direction
10. Idiomatic Go and unnecessary complexity
11. Performance only where justified by evidence

Load the relevant reference file before doing a deep pass:

- `references/correctness-and-errors.md`
- `references/concurrency-and-resources.md`
- `references/types-apis-and-boundaries.md`
- `references/architecture-and-simplicity.md`
- `references/testing-security-observability.md`
- `references/audit-patterns.md`

## Phase 4 — Validate every finding

Before reporting a non-trivial finding, answer:

- What exact behavior is wrong or risky?
- Where is the relevant code?
- What input/state triggers it?
- Can that state actually occur?
- What callers depend on the current behavior?
- Is the behavior intentional or documented?
- Is there an existing test that constrains it?
- What is the smallest safe fix?
- What could the fix break?

For architectural findings additionally answer:

- Who owns the abstraction?
- Is there more than one meaningful implementation?
- Is the abstraction consumer-driven?
- Does the layer contain meaningful policy, or only forwarding?
- Does removing it reduce total complexity?

For simplification findings, require a **before → after concept**. If you
cannot explain what concept disappears, do not call it unnecessary complexity.

## Severity

Use these levels:

- **CRITICAL** — likely severe security issue, data loss/corruption, remote
  compromise, or catastrophic production failure.
- **HIGH** — concrete correctness/security/concurrency/reliability problem
  with significant production impact.
- **MEDIUM** — meaningful bug, contract problem, maintainability hazard, or
  operational risk that should normally be fixed.
- **LOW** — localized issue with limited impact, or a strong but non-urgent
  improvement.
- **SUGGESTION** — optional readability/design improvement; not a defect.

Never inflate severity to make a finding sound important.

## Finding format

Every finding should contain:

```text
### [SEVERITY] Short title
Location: path/to/file.go:line or symbol

Problem:
What is wrong, stated concretely.

Evidence:
What repository evidence proves the claim.

Impact:
What can happen and under what conditions.

Recommendation:
The smallest practical fix, without unnecessary redesign.

Confidence: HIGH | MEDIUM | LOW
```

Do not report a low-confidence suspicion as a confirmed bug. If evidence is
incomplete, say what remains unverified.

## Verification

Use project-native commands when they exist. Otherwise, prefer:

```bash
gofmt -l .
go test ./...
go vet ./...
```

Use `staticcheck ./...` when installed and appropriate. For concurrency,
consider `go test -race ./...` when the repository and test suite make it
reasonable.

For a focused change, prefer targeted tests first, then broader verification.
Do not claim a command passed unless it was actually run.

Record failures separately from code findings: a broken local dependency or
missing tool is not automatically a code defect.

## Review output

Use this structure:

```markdown
# Go Code Review

## Summary

Risk: LOW | MEDIUM | HIGH | CRITICAL
Findings: N

One short paragraph describing the overall state.

## Findings

[findings ordered by severity]

## Positive observations

Only mention concrete strengths that help establish confidence.

## Verification

- command — PASS/FAIL/SKIPPED
- command — PASS/FAIL/SKIPPED

## Review limits

Mention anything that could not be verified.
```

If there are no substantive findings, say so explicitly. Do not invent issues
to make the review look thorough.

## Anti-slop principles

The accompanying references distill a Go simplification philosophy:

- concrete types over generic maps when the shape is known
- interfaces because consumers need abstraction, not because Go projects
  "should have interfaces"
- meaningful helpers over one-line indirection
- explicit business rules over generic validators
- one useful layer over many forwarding layers
- standard library functionality over redundant utilities
- boundary validation over repeated defensive validation internally
- real optionality over pointer-everything
- simple constructors over ceremonial builders/options/factories when all
  arguments are required
- straightforward control flow over clever compression
- measured optimization over speculative optimization

These are **heuristics**, not laws. Read the references and verify context.

## What not to do

Do not:

- remove all interfaces
- remove all pointers
- replace every error with a sentinel
- eliminate all nil checks
- eliminate all validation
- replace every helper with inline code
- collapse packages solely to reduce package count
- replace every struct with primitives
- ban generics
- ban reflection
- ban goroutines/channels
- insist every function be shorter
- introduce a new abstraction while criticizing existing abstraction
- treat `any`, `reflect`, `Factory`, `Manager`, `DTO`, `Options`, etc. as proof
  of a defect

The test is always: **does the construct solve a real problem, and is its
complexity justified by that problem?**
