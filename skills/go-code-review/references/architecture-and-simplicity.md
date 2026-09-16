# Architecture and Simplicity

The following heuristics are adapted from the supplied Go de-slop philosophy.
They are deliberately framed as investigations rather than rules to blindly
apply.

## Abstraction layers

Inspect chains such as handler → controller → service → manager → processor →
repository → store. Ask what policy each layer adds.

A layer that only forwards arguments or renames a call is a simplification
candidate. A layer that owns business rules, transaction policy, authorization,
or meaningful translation may be justified.

## Pass-through wrappers

A wrapper that only returns `dependency.Do(...)` is suspicious. Preserve it if
it establishes a meaningful API boundary, authorization, metrics, transaction,
policy, or compatibility contract.

## Helpers

Avoid one-caller helpers that merely access fields, perform trivial nil checks,
forward arguments, or wrap a standard-library call. Keep helpers when they:

- express a real domain concept
- reduce repeated meaningful logic
- isolate a complex algorithm
- provide a stable boundary

## Packages

Prefer packages around coherent domains/capabilities. Be suspicious of:

- `utils`
- `helpers`
- `common`
- `shared`
- `misc`
- `base`
- `core`

But do not rename or merge packages solely because their names are generic;
inspect ownership and dependency direction first.

## Factories, builders, options, DI

Investigate whether runtime selection or optional configuration is real.

Potentially unnecessary:

- factories with one implementation
- builders for a handful of required fields
- functional options for all-required constructor arguments
- service locators
- dependency-injection containers
- reflection-based wiring
- registries that merely hide explicit construction

Explicit construction such as `NewService(repo, logger)` is often preferable.

## DTOs, mappers, converters

Separate types can be justified when boundaries have different contracts or
lifecycles. Flag duplication only when two types are effectively identical and
create no meaningful boundary.

Do not collapse external API contracts into internal domain types merely to
remove a mapping step if the contracts evolve independently.

## Primitive wrappers

A custom type such as `ProjectID string` can prevent accidental mixing or add
behavior. A one-field struct wrapping a string with no invariant usually adds
ceremony without protection.

## Standard library

Before retaining a helper, check whether the standard library already provides
clear functionality (`strings`, `slices`, `maps`, `errors`, `strconv`, etc.).
Do not replace a domain-specific helper simply because a standard-library
function exists if the helper communicates important intent.

## Control flow

Prefer early returns and a visible happy path. Do not turn readable nested
logic into compressed boolean expressions or one-liners merely to reduce
lines.

Temporary variables are useful when they name a meaningful concept. Remove
variables that merely rename a value once.

## Formatting and regex

Avoid `fmt.Sprintf` when it adds no clarity. Avoid regex for simple string
operations. Do not micro-optimize formatting unless it solves a measured
problem.

## Tests

Apply simplicity principles to tests too:

- avoid enormous builders for simple fixtures
- avoid generic fixture frameworks for a few cases
- avoid mocks for pure logic
- prefer explicit table tests when they clarify behavior
- keep test setup understandable

## The de-slop test

For every suspicious construct ask:

1. Does this handle something that genuinely happens?
2. Is complexity caused by poor typing upstream?
3. Does this interface have a real consumer-driven purpose or multiple
   meaningful implementations?
4. Does this helper express a real concept?
5. Does this abstraction reduce total complexity?
6. Would plain Go be easier to understand?

If the answers consistently favor deletion/simplification, report it as a
refactoring opportunity rather than a correctness bug unless behavior is
actually affected.
