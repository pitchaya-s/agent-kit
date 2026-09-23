---
name: simplicity-principles
description: Use when designing an implementation, choosing abstractions, reducing overengineering, or deciding whether to generalize. Keeps solutions as simple as the current requirements allow without sacrificing correctness, compatibility, security, or measured performance.
---

# Simplicity Principles

Treat complexity as a cost that must earn its place.

Simple does not mean "fewest lines." Prefer designs with fewer concepts, states, indirections, assumptions, and moving parts while still making the required behavior obvious.

## Workflow

1. Establish the real requirement.
   - Read the task, current callers, tests, and nearby conventions.
   - Separate behavior required now from hypothetical future behavior.
   - Do not design for imagined consumers, variants, or scale without evidence.

2. Start with the least powerful mechanism that solves the problem.
   Prefer, in order:
   - direct code;
   - a small local helper;
   - a focused reusable abstraction;
   - a configurable subsystem;
   - a framework or plugin mechanism.

   Move down the list only when the simpler option creates a concrete current problem.

3. Make every abstraction pay rent.
   For each new class, interface, layer, callback, flag, generic, registry, factory, cache, queue, configuration option, or dependency, ask:
   - What current requirement needs this?
   - What concrete duplication, coupling, or change pressure does it remove?
   - Who consumes this abstraction today?
   - Would deleting it make the implementation harder to understand or change?

   If the answer is weak or speculative, remove it.

4. Prefer local clarity over premature reuse.
   - Reuse an existing repository pattern when it already fits.
   - Do not force superficially similar cases behind one abstraction.
   - Two small concrete implementations can be simpler than one generic implementation with modes, flags, and exceptions.
   - Generalize when the shared concept is stable enough to name, not merely because code looks similar.

5. Reduce accidental complexity.
   Look especially for:
   - pass-through wrappers that add no policy;
   - factories with only one meaningful implementation;
   - interfaces with one consumer and no useful boundary;
   - configuration for values that never vary;
   - boolean flags that hide multiple behaviors in one function;
   - duplicated sources of truth;
   - nested control flow that can become guard clauses or clearer data flow;
   - defensive branches for states callers cannot produce;
   - custom infrastructure where the language or existing library already solves the problem;
   - caching, concurrency, batching, async, retry, or distributed machinery without a demonstrated need.

6. Keep necessary complexity visible.
   Do not "simplify" by hiding important behavior behind magic, metaprogramming, implicit global state, surprising defaults, or overly compressed expressions. Explicit code is often simpler than clever code.

7. Verify the simpler design.
   Run the smallest relevant checks available. Simplicity never overrides correctness, security, compatibility, data integrity, or measured performance requirements.

8. Stop when the requirement is satisfied.
   Do not continue cleaning unrelated code or preparing for hypothetical future work.

## Decision Rules

### YAGNI

A plausible future requirement is not a current requirement.

Add flexibility when there is evidence such as:
- an existing second consumer;
- repeated real variation;
- a documented requirement;
- a known compatibility boundary;
- measured performance pressure;
- an external interface that genuinely needs substitution.

Do not add hooks merely because they might be useful later.

### DRY

Do not remove duplication mechanically.

Ask whether duplicated code represents the same concept and is expected to change together. If not, keeping duplication may preserve independence and clarity.

Prefer a small amount of obvious duplication over an abstraction that requires flags, branching, or knowledge of unrelated callers.

### KISS

Choose the design that a maintainer can understand with the fewest new concepts.

When two designs satisfy the same requirements, prefer the one with:
- fewer states;
- fewer layers;
- fewer dependencies;
- fewer hidden side effects;
- fewer configuration paths;
- fewer special cases.

### Abstraction Threshold

Do not introduce an abstraction solely because:
- a function is long;
- two snippets look similar;
- an interface feels architecturally cleaner;
- a pattern might be useful someday;
- a design pattern has a name.

Introduce one when it creates a clearer boundary around real change pressure.

## Anti-Patterns

Avoid:
- speculative generality;
- architecture astronauts;
- one-use abstractions with no meaningful boundary;
- "clean" layers that only forward calls;
- generic APIs that are harder to use than the concrete operations they replace;
- premature performance machinery;
- option explosions;
- broad rewrites justified only by elegance;
- shortening code at the cost of readability.

## Output Behavior

When proposing a design, explain the simplest viable approach first. Mention a more elaborate design only when current requirements justify it.

When simplifying existing code, state what complexity is being removed and why the simpler version still satisfies the same observable requirements.
