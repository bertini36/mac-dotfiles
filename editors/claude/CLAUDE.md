# Global Instructions

## Code Style

- Favour simplicity, avoid premature abstractions, unnecessary error handling, or over-engineering
- Always delete dead/unused code
- Use available skills for patterns and best practices:
  - `ddd-patterns`
  - `django-patterns`
  - `python-code-style`
  - `langchain-architecture`

## Docstrings and Comments

- Apply the `writing-clearly-and-concisely` skill to all prose, including code comments and docstrings
- Google-style docstrings for public classes and functions only
- Add docstrings only to public functions, services, and classes whose purpose is not clear from the name alone
- Add comments only for non-obvious *why*, never for *what*
- No `# ---` section dividers; use blank lines instead

## Workflow

- Git: conventional commit messages (`feat:`, `fix:`, `docs:`, etc.)
- Use `gh` CLI for all GitHub operations (PRs, issues, releases)
- Run `pre-commit` hooks before suggesting a commit is ready
- For spec-driven development, use the `superpowers` skills
- After writing an implementation plan, dispatch the `evaluator` agent before proceeding
- Before marking a task complete, run the `production-code-audit`, `django-patterns`, and `python-code-style` skills
- Use `create-pull-request` skill to create PRs with a clear description:
  - What does this PR do / which problem does it solve?
  - How does it solve it?
  - Are there any potential side effects or risks?
  - Use the `writing-clearly-and-concisely` `skill to draft the description and make it easy to understand

## Guardrails

- If 2+ interpretations exist, ask one clarifying question before proceeding
- Read existing patterns from `main` before coding; ask before inventing new variants
- Tool priority: LSP > semantic code search > Grep/Glob

## AI Assistance Preferences

- Never use the em dash. Use a comma, semicolon, colon, or period instead
- Be direct and concise: no filler, no preamble
- Lead with the answer or the code, not an explanation of what you are about to do
- For spec-driven development with `superpowers` skills, create a descriptive branch first, e.g. feat/add-user-authentication
- Suggest the minimal change required; do not refactor surrounding code unless asked
- When multiple approaches exist, pick the simplest one and mention alternatives briefly
- Do not add comments, docstrings, or type hints to code you did not change
- Use ASCII art for schemas, diagrams, and tables when it helps clarify a concept or structure
