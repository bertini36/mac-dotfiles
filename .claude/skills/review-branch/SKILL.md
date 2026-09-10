---
name: review-branch
description: Review current branch changes for quality and security
---

## Changes to Review

Base branch: !`git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@' || echo main`

!`BASE=$(git symbolic-ref refs/remotes/origin/HEAD 2>/dev/null | sed 's@^refs/remotes/origin/@@'); git diff --stat "${BASE:-main}...HEAD"`

Dispatch the `code-reviewer` agent on this branch. The agent has no `Bash`, so paste the output of `git diff <base>...HEAD` into its prompt and tell it to review the diff, reading the changed files only for surrounding context. Summarize its findings and suggest fixes.
