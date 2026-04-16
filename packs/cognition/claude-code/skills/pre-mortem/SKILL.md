---
name: cognition:pre-mortem
description: >
  Run a pre-mortem analysis before starting a project or making a decision.
  USE when the user invokes /cognition:pre-mortem, says "pre-mortem", or asks to
  stress-test a plan/decision/project before committing.
context: fork
---

# Pre-Mortem

You are running a **pre-mortem** — assume the project or decision has already failed, and work backwards to identify why.

## Protocol

1. **Set the scene.** Ask the user to describe the project, decision, or plan they're about to commit to. If they've already described it, confirm your understanding.

2. **Fast-forward to failure.** State: "It is 3 months from now. This has failed. Not partially — it didn't work out." Then ask: "What went wrong?"

3. **Generate failure modes.** Produce a structured list of plausible failure causes, organized by category:
   - **Technical** — wrong tool, underestimated complexity, dependency failure
   - **Strategic** — solved the wrong problem, market shifted, scope creep
   - **Resource** — ran out of time, money, motivation, or attention
   - **Cognitive** — confirmation bias, sunk cost fallacy, overconfidence

4. **Likelihood × Impact matrix.** For each failure mode, rate likelihood (H/M/L) and impact (H/M/L). Flag the H×H cells.

5. **Mitigations.** For each high-risk failure, suggest one concrete mitigation the user can act on *before* starting.

6. **Go/No-Go recommendation.** Based on the analysis, give a clear recommendation: proceed, proceed with modifications, or reconsider.

## Output Format

```
## Pre-Mortem: [Project/Decision Name]

### Assumed Failure
[1-2 sentence vivid description of the failure scenario]

### Failure Modes
| # | Category | Failure | Likelihood | Impact | Mitigation |
|---|----------|---------|-----------|--------|------------|
| 1 | ... | ... | H/M/L | H/M/L | ... |

### Critical Risks (H×H)
- ...

### Go/No-Go: [recommendation]
[reasoning]
```

## Gotchas

- Don't be a fear-maximizer. The goal is realistic risk assessment, not paralysis.
- If the user is doing something small (a weekend side project), keep the pre-mortem lightweight — 3-5 failure modes, not 15.
- The 3-month horizon is a default. Adjust if the user gives a different timeline.