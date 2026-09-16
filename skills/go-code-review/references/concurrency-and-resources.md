# Concurrency, Context, and Resource Lifecycle

## Goroutines

For every new goroutine ask:

- Who owns it?
- When does it stop?
- What happens if the caller returns?
- How is cancellation propagated?
- How are errors reported?
- What happens during shutdown?
- Can it leak?
- Can it race with another goroutine?

A goroutine added merely to make synchronous work "non-blocking" is suspicious.

## Channels

Prefer direct function calls for simple synchronous workflows. Channels are
valuable when they represent real coordination, streaming, ownership, or
backpressure.

Audit:

- send on closed channel
- receive from channels that may never close
- blocked sends/receives
- unbounded buffering
- unclear channel ownership
- goroutine leaks caused by missing cancellation
- select statements that omit cancellation where it matters

## Shared state

Look for:

- unsynchronized mutable maps
- races between reads and writes
- locks with inconsistent ownership
- lock ordering hazards
- holding locks during slow external calls
- copying mutex-containing structs
- accidental copies of synchronization primitives

Use the race detector when practical; static reasoning alone cannot prove the
absence of all races.

## Wait groups and structured concurrency

Check that goroutine lifecycle is explicit and that `WaitGroup` counters are
balanced. Prefer structured ownership and cancellation over detached work.

## Timeouts and retries

External I/O should have a deliberate timeout/cancellation policy. Retries
should consider:

- idempotency
- backoff
- maximum attempts
- context cancellation
- duplicate side effects
- downstream overload

Do not add retries as a generic reliability fix without understanding the
operation's semantics.

## Resource lifecycle

Inspect every acquired resource:

- files
- response bodies
- database rows
- transactions
- connections
- locks
- timers/tickers
- goroutines

Check ownership, cleanup, error paths, and shutdown behavior. `defer` is often
appropriate for local resource cleanup, but do not mechanically add it when
ownership or timing makes that incorrect.

## Performance

Be skeptical of:

- `sync.Pool`
- custom buffer pools
- unsafe conversions
- lock-free structures
- elaborate caches
- worker pools
- speculative batching
- defensive copies

Require evidence such as profiling, allocation data, workload characteristics,
or a documented constraint. Correctness and clarity come first.
