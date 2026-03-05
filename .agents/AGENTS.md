# Agent Instructions

## About This Environment

macOS developer setup (bertini36/mac-dotfiles). Primary languages: Python and shell scripting.
Tools in use: `uv` for package management, `pyenv` for Python versions, `ruff` for linting/formatting,
`pre-commit` for git hooks, `gh` CLI for GitHub operations, Docker for containers.

## Code Style

### Python

- Python 3.12+ syntax; use modern features (`match`, `|` union types, `tomllib`, etc.)
- Package management with `uv` — not `pip` directly
- Linting and formatting with `ruff` (replaces flake8, isort, black)
- Type hints on all public APIs; strict mypy or pyright where configured
- Naming: `snake_case` for functions/variables, `PascalCase` for classes, `SCREAMING_SNAKE_CASE` for constants
- Line length: 120 characters
- Absolute imports only; group as stdlib → third-party → local
- Google-style docstrings for public classes and functions
- Comments only for non-obvious *why*, never for *what*

### Shell

- ZSH scripts with 4-space indentation (per `.editorconfig`)
- Prefer `bat` over `cat`, `eza` over `ls`, `fzf` for interactive selection
- Use aliases defined in `.zshrc` when suggesting shell commands

### General

- 4-space indentation for JSON, Markdown, and shell scripts
- Favour simplicity — avoid premature abstractions, unnecessary error handling, or over-engineering
- No backwards-compatibility shims for removed code; delete unused code outright

## Workflow & Tooling

- Git: conventional commit messages (`feat:`, `fix:`, `docs:`, etc.)
- Use `gh` CLI for all GitHub operations (PRs, issues, releases)
- Run `pre-commit` hooks before suggesting a commit is ready
- Docker via `docker-compose` (alias `dc`)
- Database: PostgreSQL 18

## AI Assistance Preferences

- Never use the em dash (—). It is a reliable signal of AI-generated text. Use a comma, semicolon, colon, or period instead.
- Be direct and concise: no filler, no preamble
- Lead with the answer or the code, not an explanation of what you are about to do
- Suggest the minimal change required; do not refactor surrounding code unless asked
- When multiple approaches exist, pick the simplest one and mention alternatives briefly
- Do not add comments, docstrings, or type hints to code you did not change
- Remember to take into account the skills in `skills/` when suggesting code or commands
- Avoid adding pydocs to test functions, as they are often self-explanatory and can become outdated
