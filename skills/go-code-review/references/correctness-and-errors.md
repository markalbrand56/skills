# Correctness, Errors, and Failure Semantics

Use this reference for the correctness/error pass. Treat each item as a
question, not an automatic violation.

## Error propagation

- Check whether errors are returned, transformed, or intentionally ignored.
- Flag silent error-to-success conversion when the failure can affect the
  operation's correctness.
- A discarded error is acceptable only when ignoring it is intentional and
  the consequence is understood (for example, best-effort cache invalidation).
- Avoid redundant `result, err := ...; if err != nil { return ... }; return`
  when no behavior is added.
- When wrapping errors, require useful context. Avoid repeated layers of
  meaningless "failed to ..." messages.
- Prefer `errors.Is` and `errors.As` over string matching.
- Custom error types should exist because callers need structured behavior or
  data, not merely to classify every package.
- Check whether sentinel errors are stable enough for the API contract.

## Zero-value and absence semantics

Audit code that turns invalid or missing states into empty strings, zeroes,
false, empty collections, or nil. Ask whether absence is a valid domain state.

Do not recommend replacing a legitimate optional value with an error merely
for cleanliness.

## Panics and recovery

- Application/domain code should not use panic for ordinary validation or
  expected failures.
- `recover` should normally live at a deliberate process/request boundary,
  where it converts a panic into controlled behavior and logs/records enough
  context.
- Do not recommend adding panic recovery everywhere.

## Business-rule visibility

Meaningful rules should be recognizable in the code. Avoid generic calls such
as `validator.IsValid(x)` when the important rule is hidden and could be made
explicit.

## Transactions and persistence

For database or durable state changes, inspect:

- transaction boundaries
- commit/rollback paths
- partial failure behavior
- idempotency
- retries
- read-after-write assumptions
- unique constraints and conflict handling
- consistency between durable state and side effects

Do not assume a transaction is required simply because multiple operations are
near each other; establish the invariant first.

## Context and request lifetime

Context should normally be propagated through request-scoped I/O. Flag:

- `context.Background()` or `context.TODO()` inserted into request paths
- context replaced rather than propagated
- context stored in long-lived structs
- ignored cancellation around expensive/blocking work

Do not flag a deliberate application/root context merely because it is not a
request context.
