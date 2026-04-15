# Bosszhipin Closed Loop

This document describes the highest-value idea behind RBT.

## The Real Product

RBT is not only a generic shell.

Its core value is a one-command Bosszhipin orchestrator that can:

1. call a proactive outreach skill
2. call a message and resume handling skill
3. finish downstream upload or sync work
4. report structured progress and results
5. do all this without requiring the user to micromanage each step

In other words:

> Start once, then let the orchestrator close the loop.

## The Two-Skill Model

The public model assumes two downstream capabilities:

### 1. Outreach Skill

Responsible for:

- candidate search
- filtering
- proactive greeting or outreach
- reach-out limits and platform-side risk controls

### 2. Message And Resume Skill

Responsible for:

- reading inbound messages
- identifying truly new conversations
- resume request and collection
- resume evaluation
- downstream upload or ATS sync

RBT itself does not replace these skills. It coordinates them.

## Why This Matters

Without orchestration, the user has to manually say:

- now go greet people
- now stop and process messages
- now review resumes
- now upload the good ones
- now summarize what happened

With RBT, the user should only need something like:

- `start morning run`
- `start evening run`
- `start full run`

That is the value worth copying.

## Canonical Stage Plan

### MORNING_RUN

- Stage A: call the outreach skill and push that phase to real closure
- Stage B: call the message and resume skill to process inbound work
- Stage C: run one more cleanup pass if backlog remains
- Stage D: emit summary

### EVENING_RUN

- Stage B: process message, resume, and upload backlog
- Stage D: emit summary

### FULL_RUN

- run `MORNING_RUN`
- optionally run one extra outreach pass if safety allows
- finish with message and resume closure

### RETRY_SYNC

- call only the message and resume skill
- do not trigger new outreach

## Public Contract, Private Implementation

The public repository should expose:

- command routing
- stage sequencing
- progress events
- summary format
- safety semantics

The private implementation can keep:

- real selectors
- internal prompts
- platform login details
- ATS field mapping
- production rule caches

## Minimal User Experience

The best public expression of RBT should make this obvious:

- the user gives one high-level instruction
- RBT decides the stage order
- RBT delegates execution to the two downstream skills
- RBT returns a structured summary

If that is not obvious from the repo, the repo is missing the point.
