# Go doc-comment conventions

Use this reference when reviewing or writing Go documentation. It condenses the official guidance at `https://go.dev/doc/comment`; when internet access is available and the task depends on an edge case not covered here, consult the official page.

## Core rules

- Doc comments sit immediately before top-level package, `const`, `func`, `type`, and `var` declarations.
- Exported names should have doc comments.
- Comments should be useful to callers and render well in `go doc`, `pkg.go.dev`, and tooling based on `go/doc`.
- Write complete sentences.

## Packages and commands

- Every package should have a package comment introducing the package.
- For ordinary packages, the first sentence conventionally starts with `Package <name>`.
- Keep a multi-file package's package comment in one source file rather than duplicating it.
- For commands (`package main`), describe what the program does; the first sentence normally starts with the program name.

## Types

- Explain what an instance represents or provides.
- State stronger-than-default concurrency guarantees when they exist.
- Explain the zero value when its meaning or usability is important and not obvious.
- For structs with exported fields, explain those fields either in the type comment or with per-field comments.
- Prefer comments that name the declared type naturally in a complete sentence.

## Functions and methods

- Explain what a function returns or, for side-effecting functions, what it does.
- Refer to named parameters/results directly in prose; special formatting is unnecessary.
- “reports whether” is idiomatic for many boolean-returning functions.
- Explain multiple return values when callers need to understand their relationship.
- Document caller-relevant special cases, error behavior, blocking, concurrency, cancellation, or mutation semantics when applicable.
- Do not describe internal algorithms unless an implementation property is a public contract, such as an important complexity guarantee.

## Constants and variables

- Related declarations may share a useful group comment.
- Individual entries may use short end-of-line comments when that is clearer.
- Ungrouped exported constants and variables generally warrant full declaration comments.
- Typed constants displayed naturally with their type may be adequately explained by the type comment plus concise per-value comments.

## Syntax and formatting

Go doc comments support lightweight structure such as paragraphs, headings, links, lists, and indented preformatted blocks. Prefer simple source-readable comments. Let `gofmt` canonicalize formatting.

Use Go documentation links where useful, for example `[Type]` or `[package.Type]`, when the referenced symbol is resolvable and the link improves navigation.

## Quality check

Before accepting a comment, ask:

- Does it tell a caller something they need to know?
- Is it accurate for the implementation and tests?
- Does it state observable behavior rather than implementation trivia?
- Does it cover surprising edge cases or guarantees?
- Would it remain useful if the implementation were refactored without changing behavior?
- Is it more informative than merely restating the symbol name?
