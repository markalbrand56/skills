# Testing, Security, and Observability

## Testing

Check whether tests cover behavior rather than implementation details.
Prioritize tests for:

- changed behavior
- boundary validation
- error paths
- authorization decisions
- transaction/consistency invariants
- concurrency-sensitive behavior
- retries/idempotency
- serialization contracts

For bugs, prefer a regression test that would fail before the fix.

Do not demand a test for every trivial getter or every line. Evaluate whether
missing coverage increases realistic regression risk.

## Mocks

Do not create interfaces solely because a mocking framework expects them.
Mock narrow expensive/external boundaries where isolation is valuable. Prefer
real behavior tests for pure logic and lightweight components when practical.

## Security boundaries

Look for:

- unvalidated external input
- authorization after side effects
- IDOR/resource ownership mistakes
- injection into SQL, shell, templates, or commands
- unsafe deserialization
- path traversal
- SSRF
- secrets in logs/errors
- weak crypto or homemade cryptography
- insecure defaults
- missing tenant/user scoping
- race conditions around authorization/state changes

Do not turn generic security checklists into speculative findings. Establish
an exploit path or concrete unsafe behavior.

## Logging

Logs should support diagnosis without leaking secrets or sensitive data.
Check:

- errors logged and returned twice
- missing request/correlation context where operationally needed
- high-volume noisy logs
- sensitive values in logs
- structured fields versus string concatenation
- misleading success logs before durable completion

## Metrics and tracing

Where observability is part of the existing architecture, verify that new
failure paths do not become invisible. Do not demand metrics/tracing for every
function.

## Configuration and secrets

Check whether configuration is validated at startup/boundary and whether
secret material is kept out of source, logs, errors, and test fixtures.
Avoid broad claims when repository evidence is insufficient.
