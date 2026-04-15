# Migrating A Private Agent Into RBT

This note is for authors who already have a working private sub-agent and want to publish only the reusable parts.

## The Main Rule

Do not publish your current production agent as-is.

Instead:

- keep your private implementation
- extract the public contract
- connect the two with adapters

## What Usually Exists In A Private Agent

Most private agents bundle these things together:

- orchestration logic
- platform-specific automation
- private data sources
- private prompts and business rules
- logs and runtime state

RBT separates them.

## Mapping Guide

### Private command phrases -> Public modes

- "start morning flow" -> `MORNING_RUN`
- "start evening flow" -> `EVENING_RUN`
- "start full flow" -> `FULL_RUN`
- "status" -> `STATUS_QUERY`
- "stop" -> `STOP`
- "retry upload" or "retry sync" -> `RETRY_SYNC`
- "evolve" or "review strategy" -> `EVOLVE`

### Private sequential steps -> Public stages

- first proactive pass -> Stage `A`
- inbound handling or evaluation -> Stage `B`
- cleanup, retry, backlog closing -> Stage `C`
- summary and next actions -> Stage `D`

### Private tools -> Adapters

- browser scripts -> `TaskAdapter` or optional `BrowserAdapter`
- ATS reads and writes -> `OutcomeStoreAdapter`
- Slack, Feishu, email, or terminal updates -> `NotificationAdapter`
- stop flags, rate limits, quotas -> `SafetyAdapter`
- local rule caches -> `RuleStoreAdapter`

## What To Remove Before Publishing

- absolute local paths
- account assumptions
- real company names if sensitive
- private prompts
- selectors that expose production automation details
- screenshots, resumes, and execution logs

## What To Keep Public

- lifecycle
- command routing
- stage boundaries
- summary structure
- event schema
- adapter contracts
- fake examples

## Recommended Migration Sequence

1. Freeze your private version.
2. Copy only the orchestration semantics into a new public repo.
3. Replace every hard-coded dependency with an adapter boundary.
4. Add one fake example that runs without private infrastructure.
5. Publish the public repo.
6. Keep your production implementation wired privately.

## Litmus Test

If a stranger clones the repo, they should be able to:

- understand the agent contract
- run a demo
- replace the demo adapter with their own implementation

They should not be able to:

- recover your production setup
- access your data
- infer private operational details
