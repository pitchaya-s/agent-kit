---
name: solid-principles
description: Use when designing or refactoring modules, classes, interfaces, or dependency boundaries; reviewing code for coupling and cohesion; or deciding whether an abstraction improves maintainability. Apply SOLID pragmatically to observed design pressure without speculative layers or unrelated refactors.
---

# SOLID Principles

Use SOLID as a set of design diagnostics, not a requirement to add abstractions. Prefer the smallest design that makes current responsibilities, contracts, and change boundaries clear.

## Workflow

1. Understand the current behavior, callers, tests, and the change being requested.
2. Identify concrete design pressure: mixed responsibilities, repeated modification of stable code, broken subtype expectations, oversized interfaces, or hard-wired volatile dependencies.
3. Apply only the principle that addresses that pressure.
4. Make the smallest coherent change. Preserve behavior unless the task explicitly changes it.
5. Run the relevant tests, type checks, linters, or focused verification available in the repository.
6. Stop when the code is easier to change and understand. If a SOLID-inspired change adds more indirection than value, do not make it.

## Principles

### Single Responsibility Principle

A unit should have one coherent reason to change.

- Group behavior that changes for the same reason.
- Separate unrelated policy, persistence, transport, formatting, or orchestration when they evolve independently.
- Do not interpret SRP as “one method per class” or split cohesive code into tiny wrappers.

### Open/Closed Principle

Stable policy should not require edits for every new variation.

- Prefer an extension point when variation is already real and recurring.
- Replace repeated type/flag branching with polymorphism, composition, registration, or data when that makes the supported variants clearer.
- Do not invent plugin systems, factories, or generic hooks for hypothetical future requirements.

### Liskov Substitution Principle

A subtype must preserve the observable contract of the abstraction it implements.

- Preserve accepted inputs, promised outputs, invariants, and expected failure behavior.
- Do not strengthen preconditions or weaken postconditions in a subtype.
- If callers need subtype checks or special-case handling, reconsider the hierarchy or contract.

### Interface Segregation Principle

Consumers should depend only on capabilities they actually need.

- Prefer small, role-focused interfaces at real consumer boundaries.
- Split an interface when consumers routinely ignore methods or implementations must provide meaningless stubs.
- Do not create an interface for every class; concrete dependencies are fine when no useful boundary exists.

### Dependency Inversion Principle

High-level policy should not be coupled directly to volatile implementation details.

- Put abstractions at meaningful boundaries such as storage, external services, clocks, randomness, or platform-specific behavior when substitution is useful.
- Prefer dependency injection over hidden construction when callers need control of a dependency.
- Keep stable, simple dependencies concrete when abstraction would only add ceremony.

## Design Checks

Before introducing an abstraction, ask:

- What concrete change becomes easier because this boundary exists?
- Is the variation present now, or merely imagined?
- Can the contract be named in terms of behavior rather than implementation?
- Is duplication currently cheaper and clearer than the proposed abstraction?
- Does the change reduce coupling without scattering the logic across more files?

Prefer composition over inheritance when behavior needs to vary independently. Prefer explicit code over clever generalization. Follow existing repository conventions unless they are the source of the design problem being fixed.

## Review Guidance

When reviewing code, point to a concrete design pressure rather than naming a SOLID principle alone. Explain the consequence, identify the relevant principle, and propose the smallest useful change. Do not recommend broad rewrites for stylistic purity.
