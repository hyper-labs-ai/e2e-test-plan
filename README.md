# e2e-test-plan

An AI agent skill for defining and maintaining End-To-End (E2E) Testing Plans for web applications. The skill generates comprehensive, step-by-step browser testing plans designed to be executed by a Playwright-based testing agent with no prior knowledge of the project internals.

## What it does

This skill guides an AI agent to:

- **Scan** a project codebase to understand all pages, workflows, routes, and CRUD operations
- **Map** every user-facing workflow with happy paths and edge cases
- **Generate** detailed E2E test plans with step-by-step instructions, Playwright selectors, visual checks, responsive breakpoints, and expected outcomes
- **Update** existing plans when new features are added
- **Review** existing plans for accuracy against the actual codebase

Each plan includes authentication strategy (interactive/static/none), `data-testid` selector conventions, timeout/retry policies, accessibility check requirements, workflow priority tagging (P0/P1/P2), test data seeding strategy, responsive breakpoint testing, issue reporting rules, cleanup and state restoration instructions, and user prompts for the testing agent at execution time.

## Installation

### Quick install

**macOS / Linux** (one-liner):

```bash
curl -fsSL https://raw.githubusercontent.com/hyper-labs-ai/e2e-test-plan/master/install.sh | bash
```

**Windows** (PowerShell 5+ / pwsh):

```powershell
irm https://raw.githubusercontent.com/hyper-labs-ai/e2e-test-plan/master/install.ps1 | iex
```

Installs `SKILL.md`, `references/`, and `evals/` to `~/.agents/skills/e2e-test-plan/`.

### Option 1: Deploy from source (development)

```bash
./deploy.sh
```

This copies the skill files to `~/.agents/skills/e2e-test-plan/`.

### Option 2: Package and install (distribution)

```bash
./package.sh
unzip -o dist/e2e-test-plan.skill -d ~/.agents/skills/
```

### Verify installation

```bash
ls ~/.agents/skills/e2e-test-plan/
# Should show: SKILL.md  evals/  references/
```

## How to use

Once installed, the skill triggers automatically when you ask Claude Code to:

- "Create an E2E test plan for my project"
- "Map out all the workflows in my admin dashboard for browser testing"
- "Update my existing test plan with a new workflow for the checkout flow"
- "Review the E2E testing coverage in my web app"
- "Write a Playwright test plan for the search and filter functionality"
- "Help me plan what to test in my app's settings page"
- "Define happy paths and edge cases for user registration"

The skill will walk you through:

1. **Project discovery** — scans your codebase to understand the project structure
2. **Intent selection** — asks whether to create, update, or review a plan
3. **Scope definition** — narrows down which workflows to cover
4. **Auth strategy** — determines how authentication is handled during test execution
5. **Workflow analysis** — identifies all workflows with happy paths and edge cases
6. **Plan generation** — writes the plan to `.e2e-plans/` in your project root
7. **Review** — presents the plan for your approval before saving

## Development

### Project structure

```
e2e-test-plan/
├── SKILL.md                    # Main skill file (source of truth)
├── deploy.sh                   # Deploy to ~/.agents/skills/
├── package.sh                  # Build distributable .skill file
├── dist/                       # Packaged .skill output
├── references/
│   ├── plan-template.md        # Template for generated E2E plans
│   └── plan-formats.md         # Standard formats for steps, edge cases, etc.
├── evals/
│   └── evals.json              # Test prompts for evaluation
└── .e2e-test-plan-workspace/   # Testing artifacts (git-ignore this)
    ├── e2e-test-plan.skill
    └── iteration-1/            # Eval run data
```

### Making changes

1. Edit `SKILL.md` for skill behavior changes
2. Edit `references/plan-template.md` for output format changes
3. Edit `references/plan-formats.md` for step/edge-case/cleanup/issue-report format changes
4. Edit `evals/evals.json` to add or modify test prompts
5. Run `./deploy.sh` to test changes locally
6. Run `./package.sh` to build the distributable `.skill` file

### Running evaluations

The `.e2e-test-plan-workspace/` directory contains the evaluation framework. Each iteration stores with-skill and without-skill comparisons for test prompts. To run a new evaluation, use the skill-creator tooling at `~/.agents/skills/skill-creator/`.

## The generated plans

Plans are saved as `.md` files in `.e2e-plans/` at your project root. Each plan includes:

| Section                    | What it covers                                                                                                                                          |
| -------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Metadata                   | Plan ID, version, scope, auth method                                                                                                                    |
| Project Overview           | Deploy instructions, URLs, env variables                                                                                                                |
| Test Data Requirements     | What data must exist and how to seed it                                                                                                                 |
| Testing Configuration      | Viewport, responsive breakpoints, data-testid convention, timeout conventions, retry strategy, accessibility checks, auth detail                        |
| Workflows                  | Metadata (priority/tags/duration), preconditions, test data, happy paths with step-by-step instructions (a11y, visual, screenshot), edge cases, cleanup |
| Visual & Responsive Checks | Breakpoints, screenshot requirements                                                                                                                    |
| Accessibility Checks       | aXe scans, keyboard navigation, screen reader hints                                                                                                     |
| Retry & Flaky Strategy     | How the testing agent handles step failures and flaky detection                                                                                         |
| Cleanup & Restoration      | How to restore system state after each workflow                                                                                                         |
| Issue Reporting            | How the testing agent reports problems found                                                                                                            |
| User Prompts               | Questions the testing agent asks before executing                                                                                                       |

## Requirements

- **Claude Code** or compatible AI coding assistant with skill loading support
- The skill only generates plan documents — it does not execute tests
- The testing agent requires Playwright (browser automation) tools to execute plans
