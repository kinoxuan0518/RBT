# RBT

RBT, short for Release Bosszhipin Time, is a Bosszhipin closed-loop orchestrator that turns one high-level command into a full recruiting run.

It does not replace the Bosszhipin skills. It orchestrates them.

It is built for people who already have a private workflow that works, and want to preserve the real operational value publicly without leaking private infrastructure.

> Release your Bosszhipin Time.

## What Happens When You Type `start`

RBT should be able to:

1. start a Bosszhipin run with one command
2. call an outreach skill
3. push that outreach stage to real closure
4. switch into message and resume handling
5. evaluate and upload or sync downstream results
6. run one more cleanup pass if backlog remains
7. return a structured summary

That is the product.

## At A Glance

- One command instead of step-by-step instruction
- One orchestrator coordinating outreach plus message or resume handling
- One closed loop from greeting to downstream upload or sync
- Minimal user micromanagement
- Public orchestration layer, private execution layer

## Dependency Model

RBT is not a standalone recruiting skill.

RBT assumes you already have:

- one usable Bosszhipin outreach skill
- one usable Bosszhipin message and resume handling skill

RBT sits on top of those skills and coordinates them into one closed loop.

## The Core Value

The most important thing RBT wants to preserve is not generic abstraction. It is this operational value:

- an orchestrator can call an outreach skill
- then call a message and resume handling skill
- then close the loop with upload or sync
- and the user only needs to say "start"

That is the original value behind Zeno-like orchestration on Bosszhipin.

RBT turns that value into a public, reusable shape.

## The Product In One Sentence

RBT lets a user say `start`, then takes over the Bosszhipin loop by coordinating:

- proactive outreach
- message processing
- resume evaluation
- upload or sync closure
- summary reporting

## Why RBT

Many private recruiting sub-agents are "usable" only inside the original author's machine because they depend on:

- absolute paths
- one browser controller
- one ATS or spreadsheet
- one set of private prompts
- one company's selectors, rules, and logs

RBT extracts the reusable part while keeping the real operational idea intact:

- one-command startup
- closed-loop stage orchestration
- role and lifecycle
- command routing
- event schema
- safety and stop semantics
- adapter contracts
- host wrappers for different agent environments

## Who This Is For

RBT is for you if:

- you already have a private agent that works
- you want to open source the reusable layer
- you do not want to leak prompts, selectors, accounts, or internal data
- you need one contract that can be adapted to different agent hosts

## What RBT Is

RBT is a Bosszhipin-oriented closed-loop orchestrator pattern.

It does not assume one platform. It assumes:

- a host agent exists
- the host can provide two executable capabilities:
- one for proactive outreach
- one for message, resume, and upload handling
- the workflow needs orchestration, reporting, and safety checks

In practice, RBT gives you a clean split:

- public repo: contract, wrappers, schemas, examples
- private repo: production adapters, secrets, platform details, business logic

And a clean responsibility split:

- Boss skills: do the actual outreach, message handling, resume handling, and upload work
- RBT: decides when each skill runs, when a stage is really done, and when to summarize

## Why This Is Better Than A Prompt Dump

A raw private prompt is usually not reusable.

It tends to be tied to:

- one machine
- one browser setup
- one ATS
- one operator's habits

RBT keeps the part that other people can actually copy:

- the orchestration logic
- the one-command experience
- the stage order
- the summary format
- the boundaries between orchestrator and downstream skills

## The Closed Loop

The canonical RBT loop is:

1. Start proactive outreach.
2. Push that stage to real closure.
3. Switch into message or resume handling.
4. Evaluate, filter, and upload or sync downstream results.
5. Re-run cleanup only if backlog remains.
6. Emit a structured summary.

This is the product, not just the wrapper.

## What RBT Is Not

This repo does not include:

- private browser profiles
- production selectors
- company-specific rules
- ATS field mappings
- sensitive execution logs
- real credentials or tokens
- private candidate data

## Repository Layout

```text
RBT/
  README.md
  LICENSE
  .gitignore
  docs/
    bosszhipin-closed-loop.md
    host-integration.md
    migration-from-private-agent.md
  specs/
    agent-contract.md
    event-schema.json
    adapter-interface.ts
  agents/
    codex/SKILL.md
    claude/AGENT.md
  examples/
    recruiting-demo/README.md
  templates/
    .env.example
    private-boundary-checklist.md
```

## Core Concepts

### Modes

- `MORNING_RUN`
- `EVENING_RUN`
- `FULL_RUN`
- `STATUS_QUERY`
- `STOP`
- `RETRY_SYNC`
- `EVOLVE`

### Required Adapters

- `TaskAdapter`: runs stage work such as outreach, inbox handling, evaluation, or sync
- `OutcomeStoreAdapter`: reads downstream funnel or result data
- `NotificationAdapter`: publishes progress and final summaries
- `SafetyAdapter`: enforces stop signals, rate limits, and hard-stop conditions

### Optional Adapters

- `BrowserAdapter`
- `ResumeStoreAdapter`
- `RuleStoreAdapter`

## Quick Start

### Install Order

If you want the full Bosszhipin closed loop, install in this order:

1. [`bosszhibin-auto-recruiter-skill`](https://github.com/kinoxuan0518/bosszhibin-auto-recruiter-skill)
2. [`bosszhibin-message-resume-handler`](https://github.com/kinoxuan0518/bosszhibin-message-resume-handler)
3. `RBT`

RBT is the orchestration layer.

It becomes useful only after the two downstream Bosszhipin skills are already installed and usable.

If those skills do not work yet, install and verify them first. Then install RBT to remove the need for step-by-step manual instruction.

### Option A: Understand the framework

Read these first:

- [`specs/agent-contract.md`](./specs/agent-contract.md)
- [`specs/adapter-interface.ts`](./specs/adapter-interface.ts)
- [`specs/event-schema.json`](./specs/event-schema.json)

### Option B: Wire it into a host

- Codex: [`agents/codex/SKILL.md`](./agents/codex/SKILL.md)
- Codex Bosszhipin orchestrator: [`agents/codex/BOSSZHIPIN_ORCHESTRATOR.md`](./agents/codex/BOSSZHIPIN_ORCHESTRATOR.md)
- Claude Code: [`agents/claude/AGENT.md`](./agents/claude/AGENT.md)
- Bosszhipin closed-loop model: [`docs/bosszhipin-closed-loop.md`](./docs/bosszhipin-closed-loop.md)
- Host integration: [`docs/host-integration.md`](./docs/host-integration.md)

### Option C: Port an existing private agent

Use adapters to bind your private workflow to the public contract.

Before publishing, run through:

- [`templates/private-boundary-checklist.md`](./templates/private-boundary-checklist.md)

## Porting A Private Agent

When moving an existing private sub-agent into RBT:

1. Keep the production implementation private.
2. Replace absolute paths with adapter calls.
3. Move vendor-specific logic behind interfaces.
4. Publish only the portable prompts, schemas, and orchestration semantics.
5. Provide a fake or demo adapter before exposing a real one.

There is also a migration note here:

- [`docs/migration-from-private-agent.md`](./docs/migration-from-private-agent.md)

## Suggested Release Strategy

Start with:

- public contract
- one host wrapper
- one demo workflow
- one adapter example

Then add:

- vendor-specific adapters
- evolution helpers
- analytics helpers
- richer event taxonomy

## First Release Scope

The current public release focuses on:

- the Bosszhipin closed-loop orchestration idea
- agent contract
- event schema
- adapter interfaces
- host wrappers
- migration guidance

It does not yet try to ship a production-ready platform adapter. That boundary is deliberate.

## Chinese Summary

RBT 适合这样一种场景：你已经有一个私下可用的 sub-agent，但它强依赖你自己的本地环境。这个仓库的作用不是把那套私货原样公开，而是把其中可复用的“协议层、编排层、适配层”抽出来，让别人也能接入自己的环境来用。

## License

This repository uses `Apache-2.0`.
