---
name: rbt
description: Portable RBT coordinator wrapper for Codex. Use when you want a reusable sub-agent contract that can be bound to local adapters instead of hard-coded private workflows.
---

# RBT For Codex

This is the public Codex wrapper for RBT. It is intentionally host-oriented and adapter-driven.

## Use This When

- the user wants a reusable sub-agent
- the workflow should run across different environments
- the host can provide tools, scripts, or MCP servers via adapters

## Do Not Assume

- fixed absolute paths
- one browser controller
- one ATS
- one recruiting platform
- one outcome data source

## Required Host Bindings

Before execution, the host must map local capabilities to these roles:

- `TaskAdapter`
- `OutcomeStoreAdapter`
- `NotificationAdapter`
- `SafetyAdapter`

Optional:

- `RuleStoreAdapter`
- browser helpers
- resume storage helpers

## Command Routing

Map user requests into:

- `MORNING_RUN`
- `EVENING_RUN`
- `FULL_RUN`
- `STATUS_QUERY`
- `STOP`
- `RETRY_SYNC`
- `EVOLVE`

## Execution Rules

1. Run preflight checks before any stage work.
2. Emit a structured event at every stage boundary.
3. Re-check stop and hard-stop conditions between stages.
4. Produce a final summary even when the run fails or stops early.
5. Never auto-apply low-confidence suggestions.

## Suggested Stage Plan

### MORNING_RUN

- Stage A: proactive work
- Stage B: inbound or evaluation work
- Stage C: cleanup or retry pass
- Stage D: summary

### EVENING_RUN

- Stage B
- Stage D

### FULL_RUN

- Stage A
- Stage B
- optional extra proactive pass if safety allows
- Stage C
- Stage D

### EVOLVE

- read outcome data
- diagnose patterns
- emit suggestions

## Output Format

Prefer this machine-readable block:

```text
[RBT Progress]
run_id: <id>
mode: <mode>
stage: <A|B|C|D>
status: <STARTED|DONE|FAILED|SKIPPED|STOPPED>
note: <short note>
```

Final summary:

```text
[RBT Summary]
run_id: <id>
mode: <mode>
result: <completed|failed|stopped>
counts: <serialized counts>
human_intervention_required: <true|false>
```

## Privacy Boundary

If the local environment has private rules or scripts:

- call them through adapters
- do not expose their internals in public output
- avoid copying private prompts into this public wrapper
