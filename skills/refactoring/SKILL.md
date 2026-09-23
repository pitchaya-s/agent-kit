---
name: refactoring
description: Use when restructuring existing code without intentionally changing its observable behavior. Guides safe, incremental refactors with a green baseline, explicit invariants, small reversible steps, and verification after each meaningful transformation.
---

# Refactoring

Refactoring changes the internal structure of code while preserving its observable behavior.

Do not mix refactoring with feature work unless the structural change is required to make the feature safely. When behavior must change, identify that change explicitly rather than hiding it inside the refactor.

## Workflow

1. Define the refactoring goal.
   State the concrete problem being improved, such as:
   - duplicated logic;
   - tangled responsibilities;
   - difficult-to-test boundaries;
   - confusing control flow;
   - an unstable dependency boundary;
   - repeated change across the same files;
   - names or structure that obscure the domain.

   "Make it cleaner" is not a sufficient goal.

2. Establish the behavior to preserve.
   Inspect:
   - current callers;
   - public APIs;
   - tests;
   - error behavior;
   - side effects;
   - ordering;
   - persistence or serialization formats;
   - performance-sensitive contracts when relevant.

   Write down important invariants mentally or explicitly before editing.

3. Get a trustworthy baseline.
   Run the narrowest relevant tests or checks before making substantial changes when practical.

   If the baseline is already failing, distinguish pre-existing failures from refactor regressions. Do not claim the refactor caused or fixed failures without evidence.

4. Improve observability before risky restructuring.
   If important behavior is not covered, add focused characterization or regression tests when practical. Test externally meaningful behavior rather than internal implementation details.

5. Refactor in small, behavior-preserving steps.
   Prefer transformations such as:
   - rename;
   - extract or inline function;
   - move function or responsibility;
   - simplify conditional;
   - introduce a small value/object boundary;
   - replace temporary state with clearer data flow;
   - consolidate duplicated logic;
   - separate pure logic from side effects.

   Each step should be easy to reason about and, ideally, easy to revert.

6. Keep the code working throughout the sequence.
   After each meaningful step:
   - run the relevant focused tests;
   - inspect the diff;
   - confirm no accidental API or behavior change;
   - continue only from a known-good state.

7. Separate structural changes from semantic changes.
   If a behavior change becomes necessary:
   - stop treating that edit as pure refactoring;
   - identify the changed contract;
   - update tests intentionally;
   - keep the semantic change as isolated as practical.

8. Remove temporary scaffolding.
   Delete transitional adapters, duplicate paths, dead helpers, and migration code introduced only to enable the refactor once they are no longer needed.

9. Run broader verification at the end.
   Use the repository's relevant tests, type checks, lint, build, or integration checks according to the risk and scope of the change.

10. Stop when the stated structural problem is solved.
    Do not expand the task into unrelated cleanup.

## Refactoring Heuristics

### Preserve Contracts

Treat these as behavior unless the task explicitly says otherwise:
- return values and errors;
- mutation and side effects;
- call ordering when observable;
- public names and signatures;
- serialization shape;
- persistence semantics;
- concurrency guarantees;
- compatibility expectations.

Internal elegance does not justify silently changing a contract.

### Prefer Seams Over Rewrites

When code is difficult to change, first create a seam:
- isolate side effects;
- extract pure logic;
- wrap an external dependency;
- split orchestration from policy.

Then refactor behind that boundary. Avoid full rewrites unless incremental change is clearly less safe or more expensive.

### Keep Steps Mechanically Understandable

A good intermediate refactor should be describable in one sentence:
- "extract this calculation";
- "move this responsibility";
- "rename this concept";
- "replace this branch with a lookup";
- "separate I/O from transformation."

If a step simultaneously changes architecture, behavior, naming, and data flow, split it.

### Prefer Deletion

After consolidating or moving behavior, delete obsolete paths promptly. A refactor that leaves both old and new structures active increases complexity instead of reducing it.

### Respect Repository Shape

Prefer existing conventions, abstractions, and dependency direction unless they are the source of the problem. Do not impose a new architecture merely because another style is theoretically cleaner.

## Stop Conditions

Stop or reconsider when:
- tests no longer distinguish intended behavior from regressions;
- the refactor requires speculative abstractions;
- scope expands into unrelated modules;
- the new structure adds more indirection than it removes;
- you cannot state which observable behavior is being preserved;
- a rewrite is being justified mainly by dislike of the existing style.

## Output Behavior

Before a non-trivial refactor, identify the structural problem and the behavior that must remain stable.

Afterward, summarize:
- what structural complexity changed;
- whether observable behavior intentionally changed;
- what verification was run;
- any behavior that could not be verified.
