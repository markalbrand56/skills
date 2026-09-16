---
name: go-documentation
description: Review, write, and improve documentation comments in Go codebases. Use for Go repositories, packages, or .go files when asked to audit missing or weak documentation, document exported packages/types/structs/interfaces/functions/methods/constants/variables/fields, align comments with official Go doc-comment conventions, or fix documentation without changing runtime behavior. Supports review-only and fix modes and validates edits with the repository's existing Go tooling.
---

# Go Documentation

## Goal

Improve Go documentation so exported APIs are useful to callers, idiomatic for Go tooling, and consistent with the code's actual behavior. Do not change runtime behavior while performing documentation work.

Before writing or judging doc comments, read `references/go-doc-comments.md`.

## Choose a mode

Infer the mode from the request.

- **Review mode**: inspect and report documentation issues without modifying files. Use when the user asks to audit, review, inspect, list, or report.
- **Fix mode**: inspect, add, and improve doc comments in place. Use when the user asks to document, fix, update, improve, or bring documentation into compliance.
- If the user explicitly specifies a mode, follow it.

## Determine scope

Respect the narrowest scope supplied by the user: file, package/directory, module, or repository.

When scope is a repository or module:

1. Locate `go.mod` files and identify module boundaries.
2. Respect repository instructions such as `AGENTS.md`, `CONTRIBUTING.md`, Makefiles, Taskfiles, and CI configuration.
3. Ignore generated Go files and vendored dependencies unless the user explicitly asks to include them.
4. Prefer production `.go` files. Include test files only when their exported test helpers or examples are part of the requested scope.

## Inspect before documenting

For every symbol that needs documentation, understand its caller-facing contract before writing.

Inspect, as needed:

- declaration and implementation;
- related types and interfaces;
- constructors and factory functions;
- call sites when intent is not obvious;
- tests when they clarify edge cases, invariants, errors, or lifecycle;
- package-level context.

Do not invent guarantees that cannot be established from the code.

## Review targets

Prioritize public API documentation:

- package comments;
- exported types, including structs and interfaces;
- exported functions and methods;
- exported constants and variables;
- exported struct fields when their meaning is not already clearly explained by the type comment;
- concurrency, zero-value, lifecycle, ownership, blocking, side-effect, error, and mutation semantics when relevant to callers.

Do not add comments to unexported identifiers merely to increase comment coverage. Add internal comments only when the request includes internal documentation and the comment explains non-obvious intent or constraints.

## Write useful comments

Follow these rules:

1. Describe the API contract, not a paraphrase of the identifier or implementation.
2. Start declaration comments with the declared name when idiomatic Go conventions call for it.
3. Use complete sentences and normal prose.
4. Explain what a function returns or what side effect it performs.
5. For boolean-returning functions, prefer “reports whether” when natural.
6. Document special cases that callers need to handle.
7. Document non-default concurrency guarantees. Do not restate Go's default assumptions unnecessarily.
8. Document a useful or surprising zero value for a type when it matters.
9. For interfaces, explain the behavioral contract and expectations of implementations/callers rather than restating method names.
10. For structs, explain the meaning and invariants of exported fields where needed.
11. Document errors when callers can meaningfully branch on them, including sentinel errors or conditions detectable with `errors.Is`/`errors.As`.
12. Mention ownership, mutation, aliasing, resource lifetime, blocking, cancellation, and goroutine behavior when these are part of the observable contract.
13. Avoid implementation details unless they are themselves part of the caller-visible contract, such as meaningful complexity guarantees.
14. Avoid filler comments whose only purpose is satisfying a linter.
15. Preserve established terminology and domain vocabulary in the repository.

## Avoid mechanical comments

Reject or improve comments like:

```go
// UserService is a user service.
type UserService struct { ... }
```

Prefer comments that communicate responsibility or contract, for example:

```go
// UserService coordinates user lookup and mutation through the configured store.
type UserService struct { ... }
```

Do not use that example text blindly; derive wording from the actual code.

## Package comments

Ensure each package has one useful package comment when appropriate. For library packages, begin the first sentence with `Package <name>` and describe the package's purpose and important usage constraints. Avoid duplicating package comments across multiple files.

For `package main`, describe the command's behavior rather than pretending it is a reusable library package.

## Preserve behavior and minimize diffs

In fix mode:

- change comments only unless a formatting tool necessarily adjusts whitespace;
- do not rename identifiers, change signatures, reorder declarations, refactor code, or alter logic;
- do not add dependencies solely for documentation;
- preserve existing valid comments when they are already clear and accurate;
- keep diffs focused on the requested scope.

## Validate

After fix-mode edits:

1. Run `gofmt` on changed Go files.
2. Use the repository's documented validation commands when present.
3. Otherwise, from the relevant module root, prefer:

```bash
go test ./...
go vet ./...
```

4. Run `golangci-lint` only when the repository already configures or documents it, unless the user explicitly asks for it.
5. If a command cannot run because of environment, dependency, network, or unrelated pre-existing failures, report that clearly instead of attempting unrelated fixes.

## Report results

In **review mode**, summarize:

- scope inspected;
- missing documentation;
- misleading or low-value documentation;
- important caller-facing contracts that should be documented;
- highest-priority files or symbols.

Include file paths and symbol names so findings are actionable.

In **fix mode**, summarize:

- files changed;
- notable documentation decisions;
- validation commands run and their outcomes;
- any unresolved ambiguity where code did not establish a safe contract to document.

Do not claim full repository coverage unless the entire requested scope was actually inspected.
