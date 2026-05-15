# E2E Test Plan: [Project / Subproject Name]

> **Instructions for the testing agent**: This plan is designed for an agent with
> no prior knowledge of the project. Follow every step exactly as written.
> When the plan asks you to ask the user a question, stop and wait for their answer
> before proceeding.

---

## 1. Metadata

| Field              | Value                                                  |
| ------------------ | ------------------------------------------------------ |
| **Plan ID**        | `[project-name]-v1`                                    |
| **Version**        | `1.0.0`                                                |
| **Date**           | `[YYYY-MM-DD]`                                         |
| **Scope**          | [Entire project / Subproject name / Specific workflow] |
| **Auth Method**    | [Interactive / Static / None]                          |
| **Target Browser** | Playwright (Chromium)                                  |

---

## 2. Project Overview

### Description

[Brief 2-3 sentence description of what this project/subproject does.]

### How to Deploy and Start

```bash
# Install dependencies
npm install

# Build the project (if needed)
npm run build

# Start the dev server
npm run dev
```

### URLs

| Environment | URL                     |
| ----------- | ----------------------- |
| Local dev   | `http://localhost:5173` |
| Production  | `[URL if known]`        |

### Required Environment Variables

[From .env.example, AGENTS.md, or README. List only what the testing agent needs to know.]

---

## 3. Testing Configuration

### Viewport

Default: `1280x720`. The testing agent should set this in Playwright before starting.

### Responsive Viewport Testing

The happy path of EVERY workflow must be tested at the following breakpoints to verify responsive behavior:

| Breakpoint | Viewport   | Focus                                                               |
| ---------- | ---------- | ------------------------------------------------------------------- |
| Desktop    | `1280x720` | Full layout, multi-column, sidebars, navbars                        |
| Tablet     | `768x1024` | Collapsed navigation, adjusted grid, touch targets                  |
| Mobile     | `375x812`  | Single column, hamburger menu, stacked layout, no horizontal scroll |

For each breakpoint, the testing agent MUST:

1. Resize the browser viewport to the target dimensions
2. Execute the workflow steps
3. Verify:
   - No horizontal scrollbars appear
   - No text is truncated or overflowing its container
   - No elements overlap
   - All interactive elements (buttons, links, form fields) remain tappable/clickable
   - Navigation adapts correctly (e.g., hamburger menu on mobile)
   - Images scale appropriately without distortion
4. Capture a full-page screenshot for visual comparison

Edge cases (non-happy-path scenarios) can be tested at the default desktop viewport only, unless the edge case is specifically about responsive behavior.

### Authentication Detail

[This section changes based on the auth method chosen during plan generation.]

**If Interactive:**

The testing agent has no credentials and must ask the user to log in manually. The agent monitors the browser DOM to detect when login completes before proceeding.

```
The testing agent MUST:
1. Navigate to the login page
2. Ask the user: "Please log in to the application in the browser window.
   I will wait for you."
3. Monitor the DOM using Playwright's page.waitForSelector,
   page.waitForURL, or a polling mechanism. Detection signals:
   - Post-login element: [data-testid="user-menu"] or user avatar or
     dashboard heading
   - URL change: URL no longer contains /login, /auth, /signin
   - Cookie/localStorage: auth token appears
4. Set a timeout of 5 minutes. If timeout expires, prompt the user again.
5. Once login is detected, proceed with the test workflow.
```

**If Static (env file):**

```
The testing agent MUST:
1. Read E2E_TEST_USERNAME and E2E_TEST_PASSWORD from the .env file at the
   project root (or from environment variables)
2. Navigate to the login page
3. Fill the username/email field with E2E_TEST_USERNAME
4. Fill the password field with E2E_TEST_PASSWORD
5. Click the submit/login button
6. Wait for the post-login page to load (URL change or element appearance)
7. If login fails (stays on login page, sees error message), report the
   issue and stop
8. Proceed with the test workflow
```

---

## 4. Workflows

---

### Workflow 1: [Workflow Name]

**Description**: [What this workflow achieves from the user's perspective]

**Preconditions**:

- [Precondition 1, e.g., "User is on the homepage"]
- [Precondition 2, e.g., "User is logged in"]
- [Precondition 3, e.g., "At least one product exists in the database"]

#### Happy Path

| Step | Action               | Selector Hint                                                 | Expected Result             |
| ---- | -------------------- | ------------------------------------------------------------- | --------------------------- |
| 1    | [Action description] | [e.g., `button:text("Login")` or `[data-testid="login-btn"]`] | [What should appear/change] |
| 2    | [Action description] | [e.g., `input[name="email"]`]                                 | [What should appear/change] |
| 3    | [Action description] | [e.g., `button:text("Submit")`]                               | [Final expected outcome]    |

#### Detailed Steps

**Step 1: [Title]**

```
Action:       [Describe exactly what to do — click, type, navigate, wait]
Selector:     [Playwright-compatible selector]
Input:        [If typing, what text to enter]
Wait for:     [Element or URL to wait for after the action]
Validate:     [What to check — element visible, text present, URL changed, etc.]
Visual check: [What to verify visually — layout, element visibility, no visual defects]
Screenshot:   [true/false — whether to capture a screenshot at this step]
```

**Step 2: [Title]**

```
Action:       [Describe exactly what to do]
Selector:     [Playwright-compatible selector]
Input:        [If typing, what text to enter]
Wait for:     [Element or URL to wait for after the action]
Validate:     [What to check]
Visual check: [What to verify visually]
Screenshot:   [true/false]
```

[Repeat for all steps]

#### Edge Cases

**Edge Case 1: [Title]**

```
Reference:  Happy Path Step [N]
Variation:  [What is different from the happy path]
Action:     [What the testing agent should do instead]
Input:      [If different from happy path]
Expected:   [What should happen — error message, fallback UI, etc.]
Screenshot: [true/false]
```

**Edge Case 2: [Title]**

```
Reference:  Happy Path Step [N]
Variation:  [What is different from the happy path]
Action:     [What the testing agent should do instead]
Input:      [If different from happy path]
Expected:   [What should happen — error message, fallback UI, etc.]
Screenshot: [true/false]
```

#### Cleanup

If this workflow creates, edits, or deletes any data, it MUST clean up after itself to leave the system in its original state.

| Resource                            | Cleanup Action                   | Verification                                      |
| ----------------------------------- | -------------------------------- | ------------------------------------------------- |
| [Resource created/modified/deleted] | [Exact steps to undo the change] | [How to confirm the resource is gone or restored] |

**Cleanup strategy**: [Self-contained / Paired teardown / Idempotent state]

---

### Workflow 2: [Workflow Name]

[Same structure as Workflow 1]

---

## 5. Issue Reporting

> **Instructions for the testing agent**: When you discover an issue during test
> execution, you MUST ask the user how to handle it BEFORE taking action.
>
> If the user chose "File an issue report", create one file per issue in the
> `.issues/` directory at the project root. Name files using the pattern:
> `<workflow-name>-<kebab-case-description>.md`. The `.issues/` directory is
> git-ignored by default — these files are handoff artifacts for a coding agent.

### Option A: Fix Immediately

Attempt to diagnose and fix the issue on the spot. After fixing, re-run the
affected workflow step to verify the fix. If the fix is incomplete or causes
other issues, fall back to filing an issue report.

### Option B: File an Issue Report

Create a detailed issue file in `.issues/<workflow-name>-<kebab-case-description>.md`
using the following GitHub-issue-like format:

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
```

[Any console.error or console.warn messages captured during the failing interaction]

```

## Suggested Fix

[Based on your understanding of the codebase, suggest what might be causing the issue and how to fix it. Include file paths and line numbers if known.]

## Environment

- Browser: Playwright (Chromium)
- Viewport: [viewport at time of failure, e.g. 1280x720]
- URL: [URL where the issue occurred]
- Plan Version: [Version from metadata]
```

---

## 6. User Prompts (for the testing agent)

The testing agent MUST ask the user these questions before executing this plan.
Wait for the user's answer to each question before proceeding.

1. **Scope confirmation**: "This plan covers [scope — e.g., "all workflows in the store subproject"]. Which workflows would you like me to test?"
   - Options: "All of them", "Just [specific workflow]", "A few specific ones: [list]"

2. **Issue handling**: "When I find an issue during testing, how should I handle it?"
   - Options: "Try to fix it immediately", "File a detailed issue report in the `.issues/` directory"

3. **Auth (if interactive)**: "Please log in to the application in the browser window. I will watch for the login to complete and then proceed with testing."

4. **Responsive testing**: "Should I run responsive checks at all breakpoints (desktop at 1280x720, tablet at 768x1024, and mobile at 375x812), or just the default desktop viewport?"

5. **Visual checks**: "Should I capture screenshots at each step for visual verification, and do you want me to flag any visual issues I notice?"

---

## 7. Plan Version History

| Version | Date         | Author           | Changes      |
| ------- | ------------ | ---------------- | ------------ |
| 1.0.0   | [YYYY-MM-DD] | [Plan generator] | Initial plan |
