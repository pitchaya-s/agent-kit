---
name: ai-development-loop
description: Use when improving an AI system through experiments: prompts, agents, RAG, inference, fine-tuning, training recipes, or model architecture. Drive changes with baselines, failure analysis, explicit hypotheses, controlled experiments, evals, and keep/revert decisions.
---

# AI Development Loop

Improve AI systems by learning from experiments, not by accumulating plausible changes.

Use this loop for prompts, agents, retrieval, tool use, inference, fine-tuning, training recipes, multimodal systems, and model architecture. Adapt the rigor to the cost of the experiment, but keep the causal logic intact.

The user's explicit goal and constraints take precedence over this workflow.

## Core Loop

~~~
define target
→ establish baseline
→ inspect failures
→ form hypothesis
→ design discriminating experiment
→ change
→ evaluate
→ inspect results and regressions
→ keep / revert / investigate
→ update evidence
→ repeat
~~~

Do not jump from "performance is bad" directly to a fix.

## 1. Define What Better Means

Before optimizing, identify the behavior or capability being improved and the constraints that matter.

Use task-specific measurements. Depending on the system, include some combination of:

- task success, accuracy, reward, or domain metric;
- failure rate by important category;
- reliability across repeated trials;
- latency and throughput;
- tokens, memory, FLOPs, or monetary cost;
- safety or policy constraints;
- user-visible quality.

Do not optimize a proxy simply because it is easy to measure. Prefer measurements tied to the actual system objective.

Keep hard constraints separate from optimization targets. A candidate that improves accuracy but violates a required latency, memory, safety, or compatibility constraint is not an improvement.

## 2. Establish a Baseline

Measure the current system before changing it.

Record enough context to reproduce the comparison when practical:

- code or commit;
- model and checkpoint;
- prompt/template/version;
- data split or task set;
- relevant preprocessing;
- decoding/inference settings;
- training configuration;
- random seed or repeated-trial policy;
- hardware/runtime when it can affect results;
- primary metrics plus important cost metrics.

Use the simplest meaningful baseline when starting a new system. For research, include the strongest relevant baseline you can reasonably run as well as any simple control needed to interpret the result.

Do not compare a carefully tuned candidate against a poorly configured baseline.

## 3. Analyze Failures Before Editing

Aggregate scores tell you whether something changed. Failures tell you what to change.

Inspect representative examples, traces, trajectories, retrieved context, tool calls, intermediate outputs, or model predictions as appropriate.

Group failures into a small actionable taxonomy specific to the system. Possible categories include retrieval, perception, reasoning, tool selection, tool arguments, planning, formatting, calibration, long-context, resource failure, and eval/grader failure.

Estimate which failures are common, important, and plausibly fixable. Prioritize by expected impact rather than by whichever example was seen most recently.

Before modifying the system, ask whether a low score is caused by the model/system or by:

- an ambiguous task;
- a broken grader;
- an unrealistic evaluation environment;
- data leakage or contamination;
- infrastructure failure;
- a metric that does not represent the desired behavior.

Read failures directly. Do not take the evaluator at face value when its verdict conflicts with the actual outcome.

## 4. State a Falsifiable Hypothesis

For a meaningful experiment, write the causal claim before seeing the result:

~~~
Hypothesis:
Changing X should improve Y because Z.

Expected evidence:
A improves; B should remain approximately stable.

Main risk:
C may regress.

Decision:
What result would make us keep, reject, or investigate this change?
~~~

A useful hypothesis can be wrong.

"This might help" is not enough. The experiment should distinguish the hypothesis from plausible alternatives.

For exploratory work, uncertainty is allowed. State what the experiment is intended to learn.

## 5. Design the Experiment to Teach You Something

Prefer changing one causal factor at a time when diagnosing why a system behaves differently.

Avoid unnecessary confounding such as simultaneously changing the model, prompt, retrieval, dataset, decoding, tool schema, architecture, and optimization recipe.

A coherent intervention may legitimately require several coupled changes. In that case, evaluate the bundle first, then use ablations or controlled comparisons to identify which parts matter when that knowledge is important.

For expensive model or architecture research, use staged experiments:

~~~
cheap sanity check
→ small controlled run
→ promising configuration
→ larger confirmation run
~~~

Do not spend full-scale compute to answer a question a smaller experiment can resolve.

## 6. Build Evals Around Real Behavior

Prefer evaluation cases from:

- real failures;
- representative user or task distributions;
- manually tested important behaviors;
- domain expert cases;
- known edge cases;
- adversarial cases when relevant.

Synthetic cases are useful for filling coverage gaps, but should not be the only evidence.

Keep evaluation tasks unambiguous. A correct system should be able to understand what success requires, and a known valid solution should be able to pass the grader when practical.

Test both positive and negative behavior. If an agent should call a tool in some cases, include cases where it should not. If a classifier should detect a condition, include realistic non-condition cases.

### Capability vs Regression

Maintain the distinction:

- **Capability evals:** difficult tasks that reveal where the system can improve.
- **Regression evals:** behavior that already works and should remain reliable.

When a previously difficult behavior becomes stable, promote representative cases into the regression suite.

Do not let an improving headline metric hide regression on established behavior.

## 7. Use the Right Grader

Prefer the most objective grader that measures the desired outcome.

Use, roughly in this order:

1. outcome/state checks;
2. deterministic tests or task metrics;
3. structured assertions and static checks;
4. model-based graders for genuinely subjective behavior;
5. human/domain-expert judgment for calibration or high-value ambiguous cases.

Grade the **outcome** rather than prescribing a specific trajectory whenever multiple valid approaches exist.

Do not force an agent to use a particular sequence of tools unless that sequence itself is part of the requirement.

When using an LLM judge:

- use explicit criteria;
- separate distinct dimensions when useful;
- allow uncertainty instead of forcing a verdict;
- periodically compare judge decisions with human/domain-expert judgments;
- do not treat judge scores as ground truth merely because they are numeric.

## 8. Respect Stochasticity

AI systems can vary between identical runs.

For stochastic systems, do not overinterpret a single trial. Repeat enough trials to distinguish signal from ordinary variance when the decision matters.

Choose reliability measurements that match the product or research question:

- first-attempt success when one-shot behavior matters;
- success across repeated trials when consistency matters;
- best-of-N only when multiple attempts are actually available in the intended system.

When two candidates are close, report uncertainty and inspect more trials instead of declaring a winner from noise.

Keep evaluation conditions comparable across candidates.

## 9. Protect the Held-Out Signal

Do not repeatedly tune against the same final test set.

Where the project scale warrants it, separate:

- training or optimization data;
- development/eval data used for iteration;
- held-out data used for confirmation.

For prompt and agent work, avoid repeatedly inspecting and optimizing every held-out failure until the held-out set becomes another training set.

Add discovered production or development failures to regression coverage, but preserve some unseen signal for honest comparison when generalization matters.

## 10. Evaluate More Than the Aggregate Score

After every meaningful experiment, inspect:

- overall delta from baseline;
- per-category or per-slice changes;
- failures fixed;
- new regressions;
- representative successes and failures;
- latency/cost/resource deltas;
- traces or intermediate behavior when relevant.

A higher aggregate score can hide a serious regression in an important slice.

For agents, distinguish what the agent said happened from what actually happened in the environment. Prefer end-state verification for task completion.

## 11. Record the Experiment

Keep lightweight experiment memory.

At minimum record:

~~~
question / hypothesis
baseline
change
evaluation setup
result
important failures / regressions
decision
next implication
~~~

Record failed and neutral experiments too. They prevent rediscovery and narrow the search space.

For training experiments, retain the configuration and artifact identifiers needed to reproduce or compare the run.

Do not create process overhead that costs more than the experiment is worth.

## 12. End Every Iteration With a Decision

Use one of:

### KEEP

Evidence supports the change and important regressions are acceptable or absent. It becomes the new baseline when appropriate.

### REVERT

Evidence does not support the change, or tradeoffs violate the goal. Preserve the result as negative evidence.

### INVESTIGATE

The experiment is inconclusive because of noise, conflicting metrics, suspicious grader behavior, insufficient trials, or an unexpected failure mode.

Do not quietly keep a change because substantial work went into it.

## Research and Architecture Experiments

When comparing architectures, training methods, or model components:

- keep data, evaluation, training budget, and implementation quality comparable where the research question requires a fair comparison;
- identify unavoidable asymmetries rather than hiding them;
- run ablations that answer causal questions, not a combinatorial sweep without purpose;
- distinguish parameter count, training compute, inference compute, memory, latency, and quality rather than collapsing "efficiency" into one vague claim;
- confirm promising small-scale findings at a scale large enough to test whether the conclusion survives;
- avoid claiming general architectural superiority from one dataset, one seed, or one narrow operating point;
- compare against relevant established baselines when feasible.

A larger experiment is justified when it resolves uncertainty that the smaller experiment cannot.

## Anti-Patterns

Avoid:

- vibe-based evaluation;
- prompt tweaking without inspecting failures;
- changing many independent variables and attributing the result to one;
- optimizing only the average while ignoring important regressions;
- repeatedly tuning on the final test set;
- using an LLM judge for a condition that can be checked deterministically;
- trusting a grader without reading examples it marks wrong;
- declaring a win from one stochastic run;
- keeping only successful experiments;
- adding agent complexity before evals show the simpler system is insufficient;
- expanding to multi-agent, additional retrieval stages, or more model calls because they sound capable rather than because measured failures justify them;
- spending full training compute before a cheaper experiment validates the premise.

## Stop Conditions

Stop an iteration when the experiment has answered its question well enough to make a decision.

Stop optimizing a component when:

- the target requirement is met;
- remaining failures are outside the intended scope;
- improvements are below meaningful uncertainty or cost more than they are worth;
- the evaluation is saturated and needs harder or more representative tasks;
- further work requires a new hypothesis rather than more tweaking.

When an eval saturates, keep it as regression coverage and create a harder capability eval rather than continuing to optimize against a ceiling.

## Reporting

When doing experimental AI development, make the reasoning auditable without dumping unnecessary process.

Report, when relevant:

- baseline;
- observed failure mode;
- hypothesis;
- intervention;
- evaluation conditions;
- result and uncertainty;
- regressions/tradeoffs;
- KEEP / REVERT / INVESTIGATE;
- next question suggested by the evidence.

The objective is not to run more experiments. It is to maximize useful information per experiment and converge on a system whose improvement is supported by evidence.
