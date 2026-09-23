---
name: refactoring
description: Use when restructuring existing code while preserving intended observable behavior. Optimize for the cleanest coherent design, not the smallest diff. Large architectural changes, file moves, module splits/merges, and rewrites are acceptable when behavior remains stable and the result is materially simpler or clearer.
---

# Refactoring

Refactoring changes structure without intentionally changing intended observable behavior.

The goal is not to minimize churn. The goal is to leave the codebase in the cleanest coherent design that still behaves the same.

A large refactor is acceptable when the current structure is the problem. Prefer a clean end state over a sequence of local patches that preserve accidental architecture.

## Core Rule

Preserve intended observable behavior.

Everything else may change:
- file layout;
- module boundaries;
- class structure;
- function decomposition;
- naming;
- dependency direction;
- internal data flow;
- abstractions;
- implementation strategy;
- inheritance vs composition;
- framework usage;
- internal APIs that are not part of a required external contract.

Do not preserve bad structure merely to reduce the number of changed lines.

## Workflow

1. Understand the behavior that must remain stable.

   Inspect:
   - callers;
   - tests;
   - public APIs;
   - errors and failure modes;
   - side effects;
   - persistence and serialization;
   - ordering when observable;
   - concurrency guarantees when relevant;
   - compatibility constraints;
   - performance requirements when they are part of the contract.

   Distinguish intended behavior from incidental implementation details.

2. Identify the real structural problem.

   Look beyond the nearest symptom. Examples:
   - responsibilities are split across the wrong boundaries;
   - the same concept is represented in several incompatible ways;
   - control flow is scattered across modules;
   - dependency direction is inverted;
   - a layer exists only to forward calls;
   - abstractions encode historical constraints that no longer matter;
   - multiple local workarounds point to one architectural flaw;
   - a module has become a dumping ground;
   - domain logic is mixed with transport, persistence, or framework code.

3. Design the desired end state first.

   Ask:
   - If this code were written today with the current requirements, what would the clean structure be?
   - Which concepts deserve first-class boundaries?
   - Which abstractions should disappear?
   - Which responsibilities should move?
   - Which files or modules should be merged, split, or deleted?
   - What dependency direction makes the system easiest to understand?

   Optimize for coherence, simplicity, and maintainability, not for minimal diff size.

4. Choose a safe transformation path.

   The final refactor may be large, but the path should remain understandable.

   Use intermediate steps when they reduce risk:
   - introduce characterization tests;
   - create a temporary seam;
   - move behavior before deleting old structure;
   - migrate callers;
   - run both representations briefly when necessary;
   - remove compatibility scaffolding once migration is complete.

   Small steps are a safety technique, not a limit on the final design.

5. Refactor toward the target architecture.

   Freely use transformations such as:
   - merge or split modules;
   - move responsibilities across layers;
   - replace inheritance with composition;
   - replace objects with functions or functions with objects;
   - remove obsolete abstractions;
   - introduce clearer domain types;
   - redesign internal APIs;
   - flatten unnecessary layers;
   - consolidate duplicated concepts;
   - reorganize directories;
   - rewrite tangled implementation code;
   - delete dead architecture.

   Do not stop at cosmetic improvement when the structural problem remains.

6. Continuously check behavior.

   Run focused tests or other verification after meaningful milestones.

   If coverage is weak, add characterization tests around behavior that must survive the refactor.

   When a failure appears, determine whether:
   - behavior was unintentionally changed;
   - the test depended on an implementation detail;
   - the previous behavior was accidental rather than contractual.

7. Remove transitional complexity.

   A refactor is incomplete while both old and new architectures coexist without a real compatibility need.

   Delete:
   - obsolete wrappers;
   - migration adapters;
   - duplicate implementations;
   - dead feature flags;
   - stale abstractions;
   - compatibility layers that no longer serve callers;
   - temporary files and scaffolding.

8. Evaluate the final design as a whole.

   Ask:
   - Is the resulting structure simpler than before?
   - Are responsibilities easier to locate?
   - Is the dependency graph clearer?
   - Did we remove accidental complexity rather than move it?
   - Are there fewer concepts a maintainer must understand?
   - Would we choose this structure if starting from scratch today?

   If not, continue refactoring.

9. Run broad verification.

   Use the repository's relevant test suite, type checks, lint, build, integration checks, or other available validation proportional to the refactor's surface area.

## Behavior vs Structure

Treat these as behavior unless the task explicitly allows changes:
- externally visible return values;
- errors and failure semantics;
- externally observable side effects;
- persisted or serialized data formats;
- public API contracts;
- protocol behavior;
- ordering when callers rely on it;
- concurrency guarantees;
- compatibility promises;
- required performance characteristics.

Treat these as structure and therefore freely changeable unless explicitly constrained:
- private names;
- file locations;
- module boundaries;
- internal helper APIs;
- class hierarchies;
- implementation patterns;
- internal representations;
- number of layers;
- dependency injection style;
- internal control flow.

## Do Not Preserve Accidental Architecture

Existing code is evidence of current behavior, not proof that its structure is good.

Do not keep:
- an unnecessary service layer because it already exists;
- one class per file because the repository historically did that;
- an interface with one meaningless implementation;
- a generic framework built for variants that never arrived;
- historical wrappers around old APIs;
- duplicated concepts because changing many callers feels expensive;
- a poor dependency direction merely to avoid moving files.

If removing these produces a cleaner system while preserving behavior, remove them.

## Refactor Scope

Scope should follow the structural problem.

A refactor may legitimately touch many files or subsystems when they participate in the same architectural issue.

Do not artificially constrain the refactor to the originally edited file if doing so would leave the root problem intact.

At the same time, avoid unrelated cleanup that does not contribute to the target design.

The correct boundary is conceptual relevance, not diff size.

## Rewrite Guidance

A rewrite is acceptable when incremental restructuring would preserve so much accidental complexity that it becomes harder to reason about than replacing the implementation.

Before rewriting:
- understand required behavior;
- identify compatibility boundaries;
- ensure there is enough verification to compare old and new behavior;
- preserve externally relevant semantics.

Prefer rewriting a contained subsystem over rewriting an entire product without necessity.

## Relationship to Simplicity

Use the simplest coherent design that satisfies current requirements.

If the cleanest refactor removes abstractions, layers, configuration, indirection, or generic machinery, prefer deletion.

If a new abstraction genuinely clarifies a stable domain boundary, introduce it even when that makes the diff larger.

Do not optimize for line count. Optimize for conceptual simplicity.

## Stop Conditions

Stop when:
- intended behavior is preserved;
- the structural problem is actually resolved;
- transitional architecture has been removed;
- further changes would be unrelated polish rather than improvement to the target design.

Do not stop merely because the immediate symptom disappeared.

## Output Behavior

Before a substantial refactor, state:
- the behavior that must remain stable;
- the structural problem;
- the intended target architecture.

Afterward, summarize:
- the structural changes made;
- what was removed or simplified;
- whether any intentional behavior changed;
- what verification was run;
- any behavior that could not be verified.
