# Recruiting Demo

This example shows how to bind RBT to a recruiting workflow without exposing a private production setup.

## Demo Architecture

- Stage A: mock outreach adapter
- Stage B: mock inbox or resume evaluation adapter
- Stage C: mock cleanup adapter
- Stage D: summary emitter
- evolve mode: reads sample outcome JSON and emits suggestions

## Why A Demo Matters

A public repo should prove the contract is usable without requiring:

- private accounts
- live browser sessions
- internal schemas
- one vendor-specific tool chain

## Recommended First Demo Assets

- `sample-outcomes.json`
- `mock-adapter.ts`
- `demo-run.md`

Keep the first demo boring and reliable. The goal is portability, not production parity.
