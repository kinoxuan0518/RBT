# RBT Agent Contract

## Purpose

RBT is a host-agnostic coordinator sub-agent. It does not assume a specific vendor, browser controller, ATS, or storage backend.

The contract exists so the same sub-agent behavior can be reused across:

- Codex
- Claude Code
- MCP-capable hosts
- custom internal agent runtimes

## Responsibilities

RBT is responsible for:

- loading host-provided capabilities
- routing commands into execution modes
- checking safety gates before and during execution
- emitting progress events
- producing a final structured summary
- optionally generating improvement suggestions from outcome data

RBT is not responsible for:

- direct ownership of credentials
- assuming fixed local file paths
- coupling to one recruiting site or ATS
- embedding private business rules in public artifacts

## Inputs

### User Intent

RBT accepts normalized intents:

- `start morning`
- `start evening`
- `start full`
- `status`
- `stop`
- `retry sync`
- `evolve`

### Host Context

The host must provide:

- adapter implementations
- environment variables or secrets
- any persisted preferences
- any accessible tool or MCP handles

## Execution Lifecycle

### 1. Preflight

RBT must:

- verify required adapters are available
- verify no conflicting run is active
- verify safety rules allow execution
- load thread or workspace preferences if present

### 2. Route

RBT maps the user intent to a run mode and a stage plan.

### 3. Execute

RBT calls adapter-backed tasks for each stage in sequence unless the plan explicitly allows parallel work.

### 4. Guard

At every stage boundary, RBT must:

- check for stop signals
- check safety violations
- check blocking task failures
- decide whether to continue, skip, or escalate

### 5. Report

RBT emits machine-readable progress events plus a human-readable summary.

### 6. Evolve

If requested, or if enabled by policy, RBT may read outcome data and produce suggestions. Suggestions are advisory unless the host explicitly allows auto-apply.

## Stage Model

A default recruiting-oriented stage model:

- `A`: proactive sourcing or outreach
- `B`: inbound handling or evaluation
- `C`: backlog cleanup or retry pass
- `D`: final summary and next actions

Hosts may rename stage implementations while preserving event semantics.

## Safety Rules

The public contract requires these minimum protections:

- stop within one action cycle after a valid stop signal
- do not continue a blocked task after a safety adapter hard-stop
- do not auto-apply low-confidence evolution suggestions
- do not assume headless automation is safe for all platforms
- escalate when outcome data is incomplete or contradictory

## Output Guarantees

RBT must always produce:

- `run_id`
- `mode`
- terminal `status`
- per-stage outcomes
- summary counts
- list of skipped or failed items
- `human_intervention_required`

## Compatibility Principle

A public RBT implementation should change prompts and wrappers slowly, while keeping the event schema and adapter interface stable.
