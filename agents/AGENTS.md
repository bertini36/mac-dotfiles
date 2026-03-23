# Agent Instructions

## Code Style

- Favour simplicity, avoid premature abstractions, unnecessary error handling, or over-engineering
- Always delete dead/unused code
- Use available skills for patterns and best practices:
  - `ddd-patterns`
  - `django-patterns`
  - `python-code-style`
  - `langchain-architecture`

### Code comments and docstrings
- Apply the `writing-clearly-and-concisely` skill to all prose, including code comments and docstrings. Avoid AI patterns: hedging, passive voice, grandiose language.
- Google-style docstrings for public classes and functions
- DON'T ADD DOCSTRINGS FOR EVERY FUNCTION OR METHOD. Add them only to public functions, services, and classes whose purpose isn't clear from the name alone.
- Add comments only for non-obvious *why*, never for *what*
- DON'T USE COMMENTS IN TESTS unless absolutely necessary. Tests should be self-explanatory through clear naming and structure. If a test needs a comment, refactor for clarity instead.
- No `# ---` section dividers; use blank lines instead.

### Python

- Python 3.12+ syntax; use modern features (`match`, `|` union types, `tomllib`, `dataclasses`, etc.)
- Package management with `uv` (not `pip` directly)
- Linting and formatting with `ruff` (replaces flake8, isort, black)
- Naming: `snake_case` for functions/variables, `PascalCase` for classes, `SCREAMING_SNAKE_CASE` for constants
- Only prefix functions with `_` when they are intended for internal/local use within a module; never use `_` prefix on variables or constants
- Line length: 120 characters
- Absolute imports only; group as stdlib → third-party → local
- Activate the venv before running Python/pytest/ruff/Django commands: `workon` or `source .venv/bin/activate`. Check if `source config/postactivate` is also needed.

## Workflow

- Git: conventional commit messages (`feat:`, `fix:`, `docs:`, etc.)
- Use `gh` CLI for all GitHub operations (PRs, issues, releases)
- Run `pre-commit` hooks before suggesting a commit is ready
- For spec-driven development, use the superpowers skills.
- Before marking a task complete, run the `production-code-audit`, `django-patterns`, and `python-code-style` skills.
- Use `create-pull-request` skill to create PRs, and make sure to include a clear description answering the following questions:
  - What does this PR do / which problem does it solve?
  - How does it solve it? (briefly, without going too deep into implementation details)
  - Are there any potential side effects or risks?
- Use the `writing-clearly-and-concisely` skill to make the description clear and easy to read.

## AI Assistance Preferences

- Never use the em dash (—). It is a reliable signal of AI-generated text. Use a comma, semicolon, colon, or period instead.
- Be direct and concise: no filler, no preamble
- Lead with the answer or the code, not an explanation of what you are about to do
- For spec-driven development with superpowers skills, create a descriptive branch first, e.g. feat/add-user-authentication
- Suggest the minimal change required; do not refactor surrounding code unless asked
- When multiple approaches exist, pick the simplest one and mention alternatives briefly
- Do not add comments, docstrings, or type hints to code you did not change
- Consult skills in `~/.agents/skills/` when suggesting code or commands.
- Use ASCII art for schemas, diagrams, and tables when it helps clarify a concept or structure.                                                     