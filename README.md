# RBT

RBT, short for Release Bosszhipin Time, is an open framework for turning a useful private sub-agent into a reusable public one.

It is designed for people who already have an internal workflow that works, but want to publish the portable layer without leaking private environment details.

> Release your Bosszhipin Time.

## At A Glance

- Publish reusable orchestration without exposing private infrastructure
- Standardize agent modes, stages, events, and adapter boundaries
- Support multiple hosts such as Codex and Claude Code
- Keep vendor logic and production automation behind private adapters

## Why RBT

Many sub-agents are "usable" only inside the original author's machine because they depend on:

- absolute paths
- one browser controller
- one ATS or spreadsheet
- one set of private prompts
- one company's selectors, rules, and logs

RBT extracts the reusable part:

- role and lifecycle
- command routing
- stage orchestration
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

RBT is a coordinator sub-agent framework.

It does not assume one platform. It assumes:

- a host agent exists
- the host can provide tools or adapters
- the workflow needs orchestration, reporting, and safety checks

In practice, RBT gives you a clean split:

- public repo: contract, wrappers, schemas, examples
- private repo: production adapters, secrets, platform details, business logic

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

### Option A: Understand the framework

Read these first:

- [`specs/agent-contract.md`](./specs/agent-contract.md)
- [`specs/adapter-interface.ts`](./specs/adapter-interface.ts)
- [`specs/event-schema.json`](./specs/event-schema.json)

### Option B: Wire it into a host

- Codex: [`agents/codex/SKILL.md`](./agents/codex/SKILL.md)
- Claude Code: [`agents/claude/AGENT.md`](./agents/claude/AGENT.md)

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
