# Private Boundary Checklist

Use this checklist before publishing an RBT-based repository.

## Must Remove

- absolute local paths
- private browser profiles
- cookies and session artifacts
- ATS tokens and webhooks
- production execution logs
- candidate resumes
- internal company names if they are sensitive
- field mappings tied to one private data model

## Must Replace

- vendor names with adapter names where practical
- local scripts with documented adapter entry points
- private prompts with generic examples
- real selectors with mock or omitted examples

## Safe To Publish

- command routing
- stage model
- event schema
- adapter interface
- mock data
- fake or redacted examples
- docs on how to implement a private adapter

## Final Check

If a stranger cloned this repo, could they:

- understand the contract
- run a demo
- plug in their own backend

If yes, the public boundary is probably correct.
