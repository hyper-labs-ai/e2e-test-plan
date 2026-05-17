# Plan Formats Reference

Standard formats used in all E2E test plans. Every generated plan uses these formats so the testing agent can execute steps consistently.

## Happy Path Step Format

Each step in a happy path workflow uses this exact format:

```
Step N: [Action description]
  Action:        [e.g., Click "Add to Cart" button]
  Selector:      [e.g., button:text("Add to Cart") or [data-testid="add-to-cart"]]
  Input:         [If typing, what text to enter — or "N/A"]
  Wait for:      [Element, URL, or state to wait for after the action]
  Validate:      [What to check — element visible, text present, URL changed, etc.]
  Visual check:  [What to verify visually — layout, no overlapping elements, text not truncated, images loaded]
  a11y check:    [true/false — whether to run axe-core and keyboard-navigation checks]
  Screenshot:    [true/false — whether to capture a screenshot at this step]
  Expected:      [e.g., Cart badge shows count of 1, toast notification "Item added"]
```

## Edge Case Format

Each edge case uses this format:

```
Edge Case N: [Brief description]
  Happy step reference: [The happy-path step this deviates from]
  Variation:    [What differs from the happy path]
  Action:       [What the testing agent should do instead]
  Input:        [If different from happy path]
  Expected:     [What should happen — this is often an error message or fallback UI]
  Screenshot:   [true/false]
```

## Cleanup Section Format

Each workflow's cleanup section uses this table:

| Resource                            | Cleanup Action                   | Verification                                      |
| ----------------------------------- | -------------------------------- | ------------------------------------------------- |
| [Resource created/modified/deleted] | [Exact steps to undo the change] | [How to confirm the resource is gone or restored] |

## Test Data Table Format

For workflows that require prerequisite data:

| Record     | Creation Method  | Identifier                  | Cleanup    |
| ---------- | ---------------- | --------------------------- | ---------- |
| [Resource] | [API/UI/Fixture] | [Unique name or ID pattern] | [Strategy] |

## Issue Report Format

```markdown
---
title: "[Workflow Name] - [Brief issue description]"
workflow: "[Workflow Name]"
step: [Step number]
date: "[YYYY-MM-DD]"
---

## Description

[What went wrong — 2-3 sentences]

## Steps to Reproduce

1. [Step 1 from the workflow that led to the issue]
2. [Step 2]
3. [Step N — the failing step]

## Current Behavior

[What actually happened — error message, wrong state, missing element, etc.]

## Expected Behavior

[What should have happened per the plan]

## Screenshot

![Screenshot](data:image/png;base64,[Base64-encoded Playwright screenshot taken at the moment of failure])

## Browser Console Errors

[Any console.error or console.warn messages captured during the failing interaction]

## Suggested Fix

[Based on your understanding of the codebase, suggest what might be causing the issue and how to fix it. Include file paths and line numbers if known.]

## Environment

- Browser: Playwright (Chromium)
- Viewport: [viewport at time of failure]
- URL: [URL where the issue occurred]
- Plan Version: [Version from metadata]
```

## Workflow Cleanup Strategy Summary

| Strategy         | When to use                                            | How it works                                                  |
| ---------------- | ------------------------------------------------------ | ------------------------------------------------------------- |
| Self-contained   | Preferred whenever possible                            | Create → exercise → delete resource in one workflow run       |
| Paired teardown  | When self-contained is impractical (e.g., shared data) | Track created resources and explicitly revert each at the end |
| Idempotent state | Session/ephemeral data (e.g., cart, one-time actions)  | No explicit cleanup needed — session ends, data disappears    |
