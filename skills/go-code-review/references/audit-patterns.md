# High-Signal Audit Patterns

Use these searches as leads. **Never treat a match as a finding without
context.** Prefer the repository's own search tools; these are examples for a
plain shell.

## Type and abstraction leads

```text
any
interface{}
map[string]any
map[string]interface{}
reflect.
Factory
Builder
Manager
Processor
Helper
Utils
Mapper
Converter
Validator
Options
Params
DTO
Entity
Model
```

## Failure handling leads

```text
if err != nil
_ =
errors.New(
fmt.Errorf(
err.Error()
strings.Contains(err.Error()
recover(
panic(
```

Inspect whether each occurrence has the correct semantics. `if err != nil`
and `errors.Is` are normal Go and are not suspicious by themselves.

## Boundary/context leads

```text
context.Background()
context.TODO()
json.Unmarshal
json.NewDecoder
os.Getenv
http.Handler
http.Request
```

Trace whether external uncertainty is narrowed at the boundary and whether
request context is preserved.

## Concurrency/resource leads

```text
go func
make(chan
close(
select {
sync.Mutex
sync.RWMutex
sync.WaitGroup
sync.Pool
time.NewTicker
time.NewTimer
```

For each concurrency construct, establish ownership, cancellation, cleanup,
and possible blocking/races.

## Simplification leads

Search for names and shapes suggesting:

- one-line forwarding functions
- one-caller extraction helpers
- duplicate DTO/domain structs
- generic conversion utilities
- repeated defensive validation
- large interfaces with one implementation
- factories with no runtime selection
- option structs with one required field
- utility packages with unrelated functions
- nested control flow that could use early returns
- defensive copies without an ownership reason

## Git/diff leads

When reviewing a change, inspect:

```text
git diff --stat
git diff
git status
```

Use the project's preferred commands when different. The purpose is to
understand the actual change, not to require Git specifically.

## Verification leads

```text
go test ./...
go vet ./...
staticcheck ./...
go test -race ./...
gofmt -l .
```

Run only commands appropriate to the project and environment. Never report a
command as executed if it was not executed.
