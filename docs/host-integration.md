# Host Integration

This document shows how to connect the public RBT Bosszhipin orchestrator to a real host environment.

## The Goal

The host should expose two executable capabilities:

- one capability for proactive outreach
- one capability for message, resume, and upload handling

RBT then sits above them and decides:

- when to start outreach
- when outreach is truly done for this pass
- when to switch into downstream handling
- when to run one more cleanup pass
- when to stop and summarize

## Minimal Integration Shape

### Option 1: Skill Names

If your host supports named skills, bind:

- `outreach_skill`
- `message_resume_skill`

Then let the orchestrator prompt call those by name.

### Option 2: Tool Adapters

If your host supports tools or MCP, bind:

- `run_outreach_stage()`
- `run_message_resume_stage()`
- `read_outcomes()`
- `emit_progress()`
- `check_safety()`

### Option 3: Script Wrappers

If your host runs local scripts, wrap your private implementation into entrypoints such as:

```bash
./bin/run-outreach-stage
./bin/run-message-resume-stage
./bin/read-outcomes
```

The public repo should document the interface, not the private internals.

## Bosszhipin-Specific Integration Idea

A typical private setup looks like this:

- one skill handles active sourcing and greeting
- one skill handles messages, resumes, and downstream upload
- RBT orchestrates their sequence

That is the value to preserve publicly.

## What The Host Must Keep Private

- login state and browser profiles
- selectors and navigation details
- ATS field mappings
- rule caches
- private prompts
- company-specific logic

## What The Host Can Publish

- stage order
- command routing
- progress format
- summary format
- safety semantics

## Litmus Test

If someone can read your public repo and understand:

- what `start` means
- which stages are run
- which downstream capabilities are required
- what summary they will receive

then your public integration story is strong enough.
