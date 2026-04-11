# Global rules for Claude Code

> **Context:** User is a **researcher**, not a software engineer. Most of my
> work is research code, experiments, and tooling around models — not
> production systems. Read these rules with that framing in mind.

## Core principle: Plan before you execute

**Never jump into complex work without planning.** For any non-trivial task,
follow the full loop:

    Research → Plan → Execute → Review → Ship

The single biggest failure mode I want you to avoid is **skipping to Execute**.
When in doubt, assume the task is more complex than it looks and pause to plan.

**Fast-path for small, low-risk work.** For clearly-scoped edits — a typo, a
one-line fix, a small isolated function, a throwaway probe — you may compress
Research and Plan into a one-sentence statement and proceed. The full loop is
the default for anything non-trivial; the fast-path is the exception, and
*you* decide whether a task qualifies. If you're unsure, default to the full
loop.

Each phase below is an action, not a vibe. You are not done with a phase until
you have actually done the things listed.

---

### 1. Research

Build an accurate picture *before* proposing anything.

- **Read the code you'll touch — and the code that depends on it.** Don't guess
  what a function returns or how a module is used; open the file.
- **Understand the *why*.** What problem does this task solve? What does
  "done" look like? If the intent isn't clear, stop and ask me — don't plan
  against a guess.
- **Verify assumptions against reality.** Library behavior, data shapes, API
  contracts, config values — check them in the repo or the docs, not from
  memory. LLMs (including you) hallucinate API surfaces confidently; I may
  not spot a fabricated method name, so you need to.
- **Probe to learn, but label it.** For open-ended questions ("does this
  library even expose X?"), a small throwaway script is often faster and more
  reliable than reading docs. That's fine — just mark the run as
  *exploration*. Exploration feeds the Plan; it doesn't replace it.
- **Surface what you *don't* know.** Explicitly name the unknowns. Each one
  becomes either "look it up," "ask the user," or "explicit assumption stated
  in the Plan." Unknowns that slip through unacknowledged are where most wrong
  turns start.

Research is done when you could defend the Plan against *"why this and not
something else?"* — not when you've skimmed a file.

### 2. Plan

State the approach *explicitly* before touching code.

- **Write the plan down.** Use plan mode for non-trivial work, or at minimum
  state the plan in chat before editing. If it's only in your head, it doesn't
  exist.
- **Name the trade-offs.** What did you consider and reject, and why? A plan
  that only describes the chosen approach is half a plan.
- **Name what you're deliberately *not* doing.** Out-of-scope items called out
  explicitly can't come back as "why didn't you do X?" later.
- **Surface risks.** What could go wrong? What will you verify in Review?
- **Stop and confirm for high-blast-radius work** — deleting files, schema
  changes, rewrites, anything touching shared state or external systems.

### 3. Execute

Now — and only now — write code. Follow the style rules below.

**Functional by default.**

- Prefer **pure functions**: inputs in, outputs out, no hidden state.
- Prefer **immutability**: don't mutate arguments; return new values.
- Prefer **composition over inheritance**: small functions that compose beat
  class hierarchies.
- **Push side effects to the edges** (I/O, logging, mutation, RNG, network).
  The core logic should be pure; effects happen at the boundary.
- When the language or a performance constraint makes pure/functional style
  genuinely painful (e.g. hot loops in Python, in-place tensor ops in PyTorch),
  **say so in the Plan and justify the exception** — don't silently drop the
  style.

**Verification-first.**

State *how you'll know it works* before writing the implementation. The form
depends on what you're building:

- **For well-defined behavior** (pure functions, parsers, data transforms,
  anything with a clear input→output contract): write a **failing test**
  first. Run it, watch it fail for the right reason, then write the minimum
  code to make it pass. The test should describe behavior, not implementation.
- **For research/experiment code** (*"does this prompt work better,"*
  *"does this run converge"*) where a unit test isn't meaningful: propose a
  lightweight verification — a reproducible script, a metric to track, a
  side-by-side comparison, a sanity-check assertion.

"No test, it's research" is not acceptable. "Here's the verification I'll run
instead" is. Either way, the check exists *before* the code does.

### 4. Review

Before saying "done":

- **Re-read your own diff.** Not skim — read it. Most regressions are visible
  on a careful re-read.
- **Run the verification you set up — and the existing tests.** A green suite
  is the floor, not the ceiling.
- **Check the plan was actually followed.** Did you do what you said you'd
  do? Did scope creep in? If the plan changed mid-Execute, say so explicitly
  and explain why.
- **Look for the bug you didn't test for.** What's the most likely failure
  mode hiding in this change? Probe it deliberately.

### 5. Ship

- Commit messages explain the ***why***, not the *what*. The diff shows what
  changed; the message should say why it needed to change.
- **Never** amend published commits, force-push shared branches, or skip hooks
  (`--no-verify`) without asking first.
- **If I haven't asked you to commit, don't commit.** Staging and writing the
  message is fine; pulling the trigger is my call.

---

## About me — what "researcher, not engineer" means in practice

- **Favor clarity over cleverness.** I have to read and modify your code, so
  it should be obvious, not compact. One extra line for readability beats a
  one-liner I have to decode.
- **Don't over-engineer.** Research code often gets thrown away. Don't add
  configurability, abstraction layers, retry logic, or error handling for
  problems I don't actually have. Three similar lines beat a premature
  abstraction.
- **Explain the *software* side when it matters.** When you use a language
  feature, library pattern, or SWE convention I might not know, add a one-line
  note. Don't lecture — just flag it so I can learn.
- **Trust me on the *research* side.** If I describe an experiment, a metric,
  a training dynamic, or a model behavior, don't second-guess the premise.
  Ask clarifying questions, but assume the research framing is correct.
- **When a shortcut would save time but costs reproducibility, don't take it.**
  Determinism, seed-setting, logged configs, and recorded command lines matter
  more in research code than they do in most production code, because I'll be
  comparing runs.
- **Be concise by default.** Match response weight to task weight. A
  three-line change doesn't need a structured plan document; a big refactor
  does. Expand only when complexity or uncertainty demands it.
- **Prefer short iteration loops when uncertainty is high.** Propose →
  validate → refine beats specifying a fully-formed large solution upfront.
