# AI Research Workflow Blueprint

**Author:** Daokhanh
**Status:** Draft v2
**Last Updated:** April 2026

---

## Purpose

Design a personal AI operating system for LLM research work — layered, intentional, and built to protect cognitive growth rather than erode it.

### Core Problems to Solve

- Avoid burning through token budgets wastefully
- Prevent AI from replacing the thinking that makes a better researcher
- Build competence, not dependency
- Allow the system to evolve safely over time
- Keep AI aware of what you're working on across multiple domains without re-explaining every session

---

## Architecture Overview

| Layer | Name | Core Question |
|---|---|---|
| 0 | Experimentation | How do I safely test changes to this system? |
| 1 | Workspace Awareness | Does the AI know what I'm working on and where it lives? |
| 2 | Cognition | Am I thinking, or am I outsourcing thinking? |
| 3 | Execution | Which tool handles this task most efficiently? |
| 4 | Automation | What repeats often enough to remove from my attention? |
| 5 | Knowledge | Can I find what I've already learned when I need it? |
| 6 | Learning | Am I getting better, or just getting faster? |
| 7 | Adaptation | Is the system itself improving based on experience? |
| 8 | Communication | Can I share my work effectively with others? |

**Priority rules:**
- Layer 0 sits underneath everything — it governs how all other layers change.
- Layer 2 sits at the top in priority — protecting your thinking is the whole point.
- Layer 1 is the connective tissue — without it, every other layer operates blind.

---

## Work Domains

The system operates across distinct domains of work. Each domain has different priorities, AI behavior, and tool preferences.

| Domain | Nature | AI Posture |
|---|---|---|
| Research | Papers, experiments, reproducing results, novel ideas | Strict — challenge thinking, Socratic mode, refuse to hand answers |
| Startup | Product, business, building for users | Collaborative — brainstorm together, move fast, help execute |
| Dev / Learning | Sandbox experiments, learning new tools, skill-building | Tutor — scaffold then fade, track what you're practicing |
| Side Projects | Hobby code, creative exploration | Hands-on — speed matters, fun matters, less friction |
| Knowledge Base | Notes, organizing, connecting ideas | Librarian — help retrieve, connect, and refine, don't capture for you |

AI behavior should shift based on which domain you're operating in. Research mode thinks differently than startup mode.

---

## Layer 0 — Experimentation (Self-Modification Sandbox)

**Purpose:** Safely test new ideas, papers, and configurations without breaking a working system.

### Why This Layer Exists

You read a paper about agent adaptation. You want to try it. But overwriting your current setup risks breaking what already works. You need A/B testing for your own workflow.

### Components

- **Branching configs** — like git branches for code, maintain branches for your AI setup. Stable config is production. Experiment config is a test branch. Run both for a few days and compare.
- **Rollback safety** — every config change is versioned. If an experiment fails, revert in seconds.
- **Experiment log** — structured notes: what paper inspired this? What changed? What was the hypothesis? What happened?
- **Evaluation criteria defined upfront** — before trying something, write: "I'll consider this successful if X." Prevents abandoning good ideas too early or keeping bad ones too long.

---

## Layer 1 — Workspace Awareness (Context That Persists)

**Purpose:** Make AI aware of your projects, their status, and their domain — so you never start a session from zero.

### Why This Layer Exists

Every other layer assumes the AI knows what you're working on. Without this layer, you waste time re-explaining context, forget stalled projects, and lose the thread between sessions. This is the missing connective tissue.

### Components

- **Project registry** — a living list of active projects across all domains. Each entry: name, domain, status (active / waiting / paused / done), what's next, and when it was last touched.
- **Domain detection** — when you start working, the AI should know which domain you're in and adjust its posture accordingly. This can be explicit ("I'm in research mode") or inferred from context (which repo you're in, what you're asking about).
- **Priority surfacing** — AI can remind you what's stalled, what's overdue, what you said was important last week but haven't touched. Not nagging — just visibility.
- **Context switching support** — when you move between domains, the AI shifts behavior. Moving from research to side project means less Socratic questioning, more hands-on help.
- **Cross-domain awareness** — sometimes a research insight applies to your startup, or a dev experiment informs research. The system should notice when domains overlap.

### What This Is NOT

This is not a full project management system. It's not Jira. It's lightweight awareness — just enough for the AI to be contextually useful without you managing another tool.

### Integration with Knowledge Layer

Project tracking is operational: "what am I doing and what's next." Knowledge management is intellectual: "what have I learned and where is it." They connect but serve different purposes. The project registry lives in your workspace; the knowledge base lives in your second brain. Status and tasks flow from Layer 1. Insights and notes flow to Layer 5.

---

## Layer 2 — Cognition (Think Better, Not Faster)

**Purpose:** AI as a thinking partner, not a thinking replacement. This is the most important layer.

### The Core Distinction

| AI as Assistant | AI as Tool for Thought (Preferred) |
|---|---|---|
| "Give me the answer" | "Help me find the right question" |
| Automates known processes | Explores unknown territory |
| Optimizes for speed | Optimizes for understanding |
| Output-focused | Process-focused |
| Does the job | Helps understand the job |
| Produces right answers | Produces right questions |

### Domain-Aware Cognition

The strictness of this layer depends on the domain:

- **Research** — maximum friction. AI challenges everything, refuses to write your arguments, asks what you've already considered before offering anything.
- **Startup** — moderate friction. AI still pushes back on weak reasoning but collaborates more freely on execution.
- **Dev / Learning** — adaptive friction. High scaffolding when learning something new, reduced as competence grows.
- **Side Projects** — minimal friction. The goal is fun and exploration, not growth pressure.

### Concrete Behaviors

- When you ask to solve something, AI should **first ask what you've already considered** — like a thesis advisor
- It should **challenge weak reasoning** before offering alternatives
- It should **refuse to write your arguments** in research contexts — instead offering counterarguments, gaps, or frameworks
- It should **flag when you're outsourcing thinking** you should be doing yourself

### Structured Thinking Protocols

- **Thinking templates** — when evaluating a paper: "What problem does this solve? What assumptions does it make? What would break this approach? How does it connect to your current work?" AI asks these, doesn't answer them.
- **Debate mode** — state a position, AI argues against it. Stress-tests reasoning before committing to a direction.
- **Pre-mortem practice** — before starting a project: "Assume this fails in 3 months. Why did it fail?" Forces risk-thinking while it's still actionable.
- **Help vs. answers detection** — the system should detect whether you're asking for help or asking for answers, and respond differently.

### Language Discipline

If you switch to Vietnamese mid-conversation, that's a self-identified "lazy mode" trigger. The system pushes back: "You switched languages — let's stay in English to keep the friction productive."

---

## Layer 3 — Execution (Get Things Done)

**Purpose:** Route tasks to the cheapest, most appropriate tool.

### Coding Workflow Split

| Tool | Best For | Token Cost |
|---|---|---|
| Claude Code (Pro) | Planning, architecture, complex debugging — where reasoning quality matters | High |
| Opencode / Aider (free/local) | Mechanical edits, refactoring, boilerplate, test writing — where speed matters more than depth | Free |
| Local LLM | Simple transformations, formatting, templated generation | Free |

### Token Economics — When Local LLM Actually Saves Tokens

When Claude Code delegates to a local LLM, it still consumes tokens to construct the prompt, format context, and parse the response. For a single-shot local LLM call, overhead might cost more than having Claude Code do it directly.

**Savings only appear when:**

- The local task is self-contained (no large context needed)
- You're running batch operations (many small calls)
- The task is repetitive with a fixed template (Claude Code builds the template once, local LLM executes many times)

**Rule of thumb:** If you need to pass more than ~500 tokens of context to the local LLM, you're probably not saving anything. Use local LLMs for tasks with small input and predictable output.

### Task Routing Intelligence

Define clear routing rules rather than manually deciding every time:

- **Decision matrix** — "If the task touches more than 3 files → Claude Code. Single-file edit with clear instruction → Opencode. Formatting or template-filling → Local LLM."
- **Fallback chains** — if Opencode can't handle it, escalate to Claude Code automatically.
- **Cost tracking** — log which tasks consume the most tokens to optimize routing over time. Connects to Layer 7 (Adaptation).

---

## Layer 4 — Automation (Reduce Friction on Repetitive Work)

**Purpose:** Eliminate busywork that doesn't build skills.

### Good Candidates for Automation

- Downloading and organizing papers (arxiv API + local LLM for tagging/summarizing metadata)
- Setting up experiment environments from GitHub repos (clone → detect dependencies → create venv → run baseline → log results)
- Converting between formats (BibTeX ↔ markdown, etc.)
- Monitoring arxiv feeds for papers matching your interests

### The "Research Fork" Workflow

1. Clone a repo
2. Create an isolated experiment branch
3. Reproduce baseline results
4. Log configuration, results, and observations automatically
5. Generate a structured experiment note

This is a strong local LLM + scripting target — predictable steps, minimal reasoning required.

### Domain-Specific Automations

- **Research** — arxiv scanning, experiment scaffolding, paper organization
- **Startup** — dependency monitoring, deployment checks, boilerplate generation
- **Dev / Learning** — environment setup, tutorial scaffolding
- **Knowledge Base** — weekly review prompts, stale note detection, link checking

### Triggers and Scheduling (Often Overlooked)

- **Scheduled automations** — daily arxiv scan, weekly experiment cleanup, monthly knowledge base review
- **Event-driven triggers** — "When I clone a new repo, automatically create an experiment scaffold." "When I finish reading a paper, prompt me to write a structured note."
- **Notification design** — how do automation results surface? Daily digest? Dashboard? Silent automations are useless if you never see the output.

---

## Layer 5 — Knowledge (Capture and Connect)

**Purpose:** Build a durable second brain from research activity.

### Components

- **Paper notes** — structured summaries when you read (your takeaways, with AI helping organize — not AI-generated summaries)
- **Second brain** — searchable, linked knowledge base following PARA method (Projects, Areas, Resources, Archives)
- **Presentations** — slide generation from notes and findings
- **Drafts** — writing scaffolds for papers, reports, blog posts

### Retrieval and Linking (Often Missing)

A knowledge base you can't search effectively is just a graveyard.

- **Semantic search over notes** — "What did I read about attention mechanisms in January?" Local embeddings + vector store.
- **Automatic linking** — when writing a new note, the system suggests: "This seems related to your note from 3 weeks ago about X."
- **Spaced repetition for key concepts** — the learning layer pulls from the knowledge base to reinforce things you're forgetting.
- **Raw vs. refined notes** — first pass is messy capture. Second pass (weekly) is distillation into clean, reusable knowledge. AI helps with the second pass but shouldn't do the first.

### Cross-Domain Knowledge Flow

Insights don't stay in one domain. A technique from a research paper might solve a startup problem. A side project hack might become a research tool. The knowledge layer should surface these connections across domains, not silo them.

### Relationship to Layer 1

Layer 1 (Workspace Awareness) tracks **what you're doing** — active projects, status, next actions. Layer 5 (Knowledge) tracks **what you've learned** — insights, concepts, connections. They feed each other: finishing a project generates knowledge; knowledge informs new projects. But they are separate concerns with separate systems.

### Key Principle

AI should help you retrieve and connect your own knowledge, not replace the act of encoding it. The note-taking itself is part of learning.

---

## Layer 6 — Learning (Grow While Working)

**Purpose:** Extract learning from every work session.

### Core Loop

**Work → Reflect → Learn → Work (improved)**

### Mechanisms

- After completing a coding task, the system prompts: "What pattern did you apply here? Could you do this without AI next time?"
- When reading a paper, it asks Socratic questions rather than summarizing
- It tracks which skills you're exercising vs. which you're outsourcing
- Periodic reviews: "This week you delegated 80% of your PyTorch debugging — want to practice that manually next session?"

### Skill Mapping (Often Missing)

- **Skill inventory** — explicit list: "These are the skills I'm developing." Examples: PyTorch proficiency, paper reading speed, experimental design, technical writing.
- **Delegation awareness** — track what you do yourself vs. delegate. If you always delegate data visualization, that skill atrophies. The system should notice.
- **Difficulty progression** — like a good tutor, gradually reduce scaffolding. Week 1: full code suggestions. Week 4: only hints. Week 8: just documentation pointers.
- **Learning goals with deadlines** — "By end of month, I should be able to write a training loop from memory." Otherwise learning stays vague.

---

## Layer 7 — Adaptation (The System Gets Better Over Time)

**Purpose:** The AI workflow improves as the collaboration matures.

### What Adaptation Looks Like

- **Prompt refinement** — instructions get more precise as you discover what works
- **Personalized defaults** — the system learns your preferred paper structure, coding conventions, note format
- **Difficulty calibration** — "strict teacher" mode adjusts based on demonstrated competence (pushes harder where you've mastered, supports more in new areas)
- **Workflow evolution** — tasks that started in Claude Code migrate to local LLM as they become routine
- **Domain posture tuning** — initial AI behavior per domain is a guess. Over time, refine how strict or hands-on the AI should be in each domain based on experience.

### Feedback Loops (Often Missing)

- **Explicit feedback moments** — after each significant task, quick rating: "Was this helpful? Did I learn? Did I over-rely on AI?" Takes 10 seconds, creates data.
- **Pattern detection** — "You've asked the same type of question 5 times this week. Should we create a template or automation?"
- **Configuration changelog** — every setup change logged with a reason. Becomes a history of workflow evolution.
- **Periodic system review** — monthly: "Here's how your tool usage changed. Here's where you spent the most tokens. Here's what you're learning vs. outsourcing."

### Practical Implementation

- Maintain a living preferences config capturing what works
- Regular retrospectives (weekly): what did AI help with? What should I have done myself? What was wasteful?
- Version your AI configuration — treat it like code, with a changelog
- Review domain postures quarterly — is research mode too strict? Is side project mode too loose?

---

## Layer 8 — Communication (Share Work Effectively)

**Purpose:** Research isn't solo — translate your work for different audiences.

### Components

- Drafting emails and messages to advisors, collaborators, reviewers
- Preparing presentations of your work
- Translating ideas into different formats (technical paper vs. blog post vs. conference talk)
- Peer review assistance — not writing reviews, but helping structure feedback on others' work

---

## Token Cost Summary

| Layer | Primary Tools | Token Cost |
|---|---|---|
| Experimentation | Git, config files, experiment logs | Zero (human effort) |
| Workspace Awareness | Project registry, context files | Zero (human effort, AI reads) |
| Cognition | Claude (chat), structured prompts | Low (but high value) |
| Execution | Claude Code, Opencode, Local LLM | Medium |
| Automation | Local LLM + scripts | Very low |
| Knowledge | Notes system, Claude for linking | Low |
| Learning | Socratic prompts, tracking | Minimal |
| Adaptation | Config files, retrospectives | Zero (human effort) |
| Communication | Claude (chat), templates | Low |

---

## Open Questions

- [ ] What specific local LLM models work best for each automation task?
- [ ] How to implement semantic search over the second brain affordably?
- [ ] What's the minimum viable version of each layer to start using immediately?
- [ ] How to measure whether the Cognition layer is actually protecting critical thinking?
- [ ] What tools handle the experiment branching workflow for configs?
- [ ] How should the AI detect which domain you're in — explicit switch or inferred from context?
- [ ] How granular should project tracking be — just status or full task breakdown?
- [ ] How do cross-domain connections get surfaced practically?

---

## Next Steps

1. **Start with Layer 0 (Experimentation)** — without it, you can't safely iterate on anything else
2. **Set up Layer 1 (Workspace Awareness)** — a simple project registry so AI always knows what you're working on
3. **Formalize Layer 2 (Cognition)** — it's the one most likely to get skipped under pressure, so bake it in early with domain-specific postures
4. **Build Layer 3 (Execution)** routing rules into your AI configuration
5. **Prototype one automation** from Layer 4 to prove the local LLM pipeline works
6. **Iterate** — use Layer 0 to test every change
