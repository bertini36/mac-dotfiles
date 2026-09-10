---
name: start-feature
description: Start the feature development pipeline
---

Follow this pipeline stage by stage. Route decides which stages the task needs; do not skip any other stage. Pause only where a stage asks for user input or a GO verdict.

Task: $ARGUMENTS

Current branch: !`git rev-parse --git-dir > /dev/null 2>&1 && git branch --show-current || echo "(no git repo)"`
Uncommitted changes: !`git rev-parse --git-dir > /dev/null 2>&1 && git status --short || echo "(no git repo)"`
In a worktree: !`git rev-parse --git-dir 2>/dev/null | grep -q '/worktrees/' && echo "yes" || echo "no"`

Additional rules:
- If the task above includes a Jira ticket, pass it along so it lands in the PR description.
- If no `.git` repo is present, skip the git stages (Workspace, commits, PR, Address feedback, Finish).
- Superpowers skills end by handing off to another skill. Inside this pipeline, the next stage below wins over any such handoff.

## 1. Route

Invoke the `feature-router` skill. It inspects the task and proposes a route and a workspace in one message, and the user confirms both at once.

- **Quick Change or Standard Implementation:** create the workspace (stage 2), implement per the router's preview, commit per the Commits rules in `CLAUDE.md`, then go to stage 8 (Verify).
- **Needs Grill/Plan:** create the workspace (stage 2), then continue to stage 3 (Brainstorm).

## 2. Workspace

Use the workspace the user confirmed in Route, without asking again:

- **Current checkout:** the session is already in a worktree or on a branch other than `main`. Stay there.
- **Branch:** create a descriptive branch off `main` (for example `fix/typo-in-login-error`) in the current working tree.
- **Worktree:** create one with `superpowers:using-git-worktrees` on a descriptive branch (for example `feat/add-user-authentication`) and run the rest of the pipeline inside it.

## 3. Brainstorm

`superpowers:brainstorming` explores requirements, edge cases, and design with the user, one question at a time, and writes the spec the user reviews.

## 4. Plan

`superpowers:writing-plans` turns the spec into a task-by-task plan. When it saves the plan, skip its "execution options" handoff: the plan is not ready to execute until it passes Grill and Evaluate.

## 5. Grill

`grill-me` interviews the user one question at a time on the decisions the plan introduced. It skips anything the spec already settled and records each resolved decision in the plan file.

## 6. Evaluate

Dispatch the `plan-evaluator` agent. With fresh context and no stake in the plan, it checks the plan against the codebase and returns GO or NO-GO. Implement only on GO. On NO-GO, revise the plan with the blockers as input and re-grill only the parts that changed.

## 7. Implement

Execute the plan with `superpowers:subagent-driven-development` without asking the user to pick an execution mode. Every task follows `superpowers:test-driven-development`, and each subagent brief names the domain skills for the files it touches (for example `django-patterns`, `python-code-style`).

Its scratch files live in the git-ignored `.superpowers/sdd/` directory. `git clean -fdx` deletes its progress ledger for good, so do not run it mid-plan.

When its final whole-branch review is clean, stop there: skip its `superpowers:finishing-a-development-branch` handoff and go to Verify.

Commit per the Commits rules in `CLAUDE.md`. Before opening the PR, read `git log --oneline main..HEAD`; if the sequence does not tell a coherent story, rebase until it does.

## 8. Verify

Run the `fix-until-green` skill. It runs the project checks and `pre-commit`, fixes failures in a loop capped at 5 iterations, and reports with the command output, which is the evidence `superpowers:verification-before-completion` asks for. Do not run `production-code-audit` here; it rewrites code rather than verifying it.

## 9. Review

Match the review to the route, so no diff gets reviewed twice:

- **Quick Change:** no review agent; Verify is enough.
- **Standard Implementation:** run `/review-branch`.
- **Needs Grill/Plan:** skip `/review-branch`; subagent-driven development already reviewed every task and the whole branch.

On any route, when the router listed a security risk (auth, payments, secrets, user input, permissions), also dispatch the `security-reviewer` agent on the diff against `main`. Investigate any bug a review finds with `superpowers:systematic-debugging` before fixing it, then re-run Verify.

## 10. Create PR

Invoke the `create-pull-request` skill.

## 11. Address PR feedback

When reviewers have commented, the user pastes the PR link. Dispatch the `pr-reviewer` agent.

## 12. Finish

After the user merges the PR, run `/end-feature` from the main checkout. It switches to `main`, pulls, and removes the worktree and the merged branch.

## Quick Reference

```
Route + Workspace
   |
   +-- Quick Change / Standard ------------------------------------------+
   |                                                                     |
   +-- Needs Grill/Plan --> Brainstorm --> Plan --> Grill --> Evaluate   |
                                             ^                  |        |
                                             +----- NO-GO ------+        |
                                                                | GO     |
                                                                v        v
                                                          Implement --> Verify --> Review --> PR --> Feedback --> Finish
```

Manual touchpoints: confirm the route, answer Brainstorm and Grill, read the PR body, paste the PR link for feedback, and run `/end-feature` after merging.
