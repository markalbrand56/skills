# Types, APIs, and Trust Boundaries

## `any` and generic maps

Search for `any`, `interface{}`, `map[string]any`, and equivalent patterns.
Do not flag them automatically. Ask whether the data is genuinely dynamic.

If an external JSON/event/document has a known shape, prefer decoding it into a
concrete type at the boundary. Avoid carrying untyped values deep into the
application and repeatedly recovering their type.

## Conversion helpers

Be suspicious of generic helpers such as:

- `ToString`, `AsString`, `GetString`
- `ToMap`, `AsMap`
- `ValueOrDefault`
- `SafeCast`
- generic normalization functions accepting `any`

Trace the value to its origin. The best fix is often stronger typing upstream.

## Pointers and optionality

Pointers communicate meaningful absence, identity, mutation, or API semantics.
They should not be used merely because zero values feel inconvenient.

For every pointer field ask:

- Is nil a valid state?
- Does the distinction between absent and zero matter?
- Is this a partial update/patch API?
- Does serialization require omission semantics?

## Interfaces

Prefer consumer-owned, narrow interfaces when abstraction is genuinely useful.
Concrete types are often simpler when there is one implementation and no
consumer-driven contract.

Good reasons include:

- multiple meaningful implementations
- substitution at a real boundary
- plugin behavior
- a small consumer-owned contract
- isolating an expensive/external dependency in tests

Do not create `Foo`/`FooImpl` pairs as a default architecture.

## Generics

Generics are appropriate for genuinely reusable algorithms/data structures
where type parameters improve correctness or eliminate meaningful duplication.

Do not create generic helpers merely because two functions share a few lines.
Concrete domain code is often clearer.

## Reflection

Reflection is legitimate in serializers, generic infrastructure, tooling, and
framework code. It is suspicious in ordinary business logic when it merely
avoids explicit typed code.

## Function signatures

Prefer narrow parameters over giant config/options/metadata objects when a
function needs only a few values. But use structs when the values form a
coherent domain object or when the API benefits from named grouping.

Do not create an options struct for a single required argument.

## Return values

A return struct should represent a meaningful object or coherent group of
values. Do not create `ExistsResult{Exists bool}` merely to avoid returning a
bool.

## Boundary validation

Validate uncertainty at boundaries:

- HTTP input
- path/query parameters
- webhooks
- queue messages
- configuration/environment
- external APIs
- user input
- decoded untrusted data
- schemaless persistence

Once data has been validated and represented by trustworthy internal types,
avoid re-validating every layer unless the invariant can actually be violated.

## Ownership and copying

Do not make defensive copies of slices/maps unless mutation or ownership makes
it necessary. Conversely, do not expose mutable internal state when callers
could mutate it and violate invariants.

## API compatibility

For public or cross-package APIs, check:

- zero-value behavior
- nil semantics
- error contracts
- backwards compatibility
- JSON/serialization tags
- exported identifiers
- context placement
- ownership of returned mutable values
