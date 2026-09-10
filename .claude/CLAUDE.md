# Global Instructions

## Code Style

- Favour simplicity, avoid premature abstractions, unnecessary error handling, or over-engineering
- Always delete dead/unused code
- Declare variables as close as possible to where they are used; do not hoist them to the top of a function or block
- Name functions and methods with a verb describing the action they perform (`build_invoice`, `fetch_user`, `is_active`); nouns are for variables and classes
- Use available skills for patterns and best practices:
  - `domain-service-layer`
  - `django-patterns`
  - `python-code-style`
  - `langchain-architecture`

## Docstrings and Comments

- Apply the `writing-clearly` skill to all prose, including code comments and docstrings
- Google-style docstrings for public classes and functions only
- Add docstrings only to public functions, services, and classes whose purpose is not clear from the name alone
- Add comments only for non-obvious *why*, never for *what*
- No `# ---` section dividers; use blank lines instead

## Workflow

Feature work runs through the `start-feature` skill; it owns the pipeline and its stages.

Rules:
- Use `gh` CLI for all GitHub operations
- Create every pull request through the `create-pull-request` skill, with no exceptions. When another skill or workflow (e.g. `superpowers:finishing-a-development-branch`) reaches a "create PR" step or shows its own `gh pr create` snippet, ignore that snippet and invoke `create-pull-request` instead; it handles the repo's PULL_REQUEST_TEMPLATE
- Run `pre-commit` hooks before claiming a commit is ready

### Commits

A reviewer walking the PR commit by commit should follow the chain of thought without needing the whole diff.

- Conventional commit messages (`feat:`, `fix:`, `docs:`, etc.)
- One logical change per commit: a model, a view, and its tests are separate commits
- Self-contained: each commit passes its own tests; squash "WIP" and "fixup" commits before the PR
- Ordered as a narrative: foundations (types, models, schemas), then behavior (services, views), then surface (routes, UI). An earlier commit never depends on a later one
- Never mix refactors with feature work; a rename or extraction gets its own commit
- The subject states intent, not mechanics: `feat: cache user permissions per request`, not `feat: add LRU dict to middleware`. The body explains why when the reason is not obvious

### PR Review Handling

When the user pastes a PR link and asks to review it or address comments, dispatch the `pr-reviewer` agent.

Reply/resolve policy, binding for the main session and every agent:
- Never reply to or resolve a review thread opened by another human reviewer, even when I instructed the fix. Apply the fix in code, then leave the conversation to me; I answer humans myself.
- Replying and resolving is only allowed on threads opened by me (bertini36) or by bots (Copilot, CodeRabbit, etc.).

## Testing

- Run `pytest` with `-n auto` to parallelise across cores (requires `pytest-xdist`)

## Guardrails

- If 2+ interpretations exist, ask one clarifying question before proceeding
- Read existing patterns from `main` before coding; ask before inventing new variants

## AI Assistance Preferences

- Never use the em dash. Use a comma, semicolon, colon, or period instead
- Be direct and concise: no filler, no preamble
- Lead with the answer or the code, not an explanation of what you are about to do
- Suggest the minimal change required; do not refactor surrounding code unless asked
- When multiple approaches exist, pick the simplest one and mention alternatives briefly
- Do not add comments, docstrings, or type hints to code you did not change
- Use ASCII art for schemas, diagrams, and tables when it helps clarify a concept or structure

@RTK.md
