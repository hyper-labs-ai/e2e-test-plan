# e2e-test-plan — agent instructions

## What this is

An OpenCode skill that generates Playwright E2E test plan documents (`.md` files). It does **not** execute tests — it produces plans for another agent to run.

## Source of truth

`SKILL.md` — the skill definition that OpenCode loads at runtime. All behavior changes go here.

## Key structure

```
SKILL.md                          # Skill definition (source of truth)
references/plan-template.md       # Template for generated E2E plans
evals/evals.json                  # Eval prompts (used by skill-creator)
deploy.sh                         # cp to ~/.agents/skills/e2e-test-plan/
package.sh                        # Builds dist/e2e-test-plan.skill
```

No `package.json`, no tests, no lint/typecheck for the skill itself.

## Commands

| Command        | What it does                                                      |
| -------------- | ----------------------------------------------------------------- |
| `./deploy.sh`  | Copy skill to `~/.agents/skills/e2e-test-plan/` for local testing |
| `./package.sh` | Create distributable `.skill` zip in `dist/`                      |

## Conventions

- Generated plans go in `.e2e-plans/` at the **target project's** root (not this repo).
- Helper scripts use **TypeScript** via `npx tsx` — no Python, no Rust.
- Edits to `references/plan-template.md` change output format for all generated plans.
- Edits to `evals/evals.json` add/modify test prompts for skill-creator evals.
- Do not commit `dist/` or `.e2e-test-plan-workspace/` (gitignored).
- Plans must not be saved to disk until the user explicitly approves.
