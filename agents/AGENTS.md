# Agent Instructions

## About This Environment

macOS developer setup (bertini36/mac-dotfiles). Primary languages: Python and shell scripting.
Tools in use: `uv` for package management, `pyenv` for Python versions, `ruff` for linting/formatting,
`pre-commit` for git hooks, `gh` CLI for GitHub operations, Docker for containers.

## Code Style

### General

- Google-style docstrings for public classes and functions
- Comments only for non-obvious *why*, never for *what*
- Favour simplicity, avoid premature abstractions, unnecessary error handling, or over-engineering
- No backwards-compatibility shims for removed code; delete unused code outright
- Take into account the `writing-clearly-and-concisely` skill when writing any prose, including code comments and docstrings. Avoid AI patterns like hedging, passive voice, and grandiose language.
- When writing docstrings, focus on clarity and conciseness. Avoid unnecessary jargon or complex language. Use simple, direct sentences to explain the purpose and functionality of the code. Remember that the goal is to make the code easily understandable for other developers who may read it in the future.
- Use comments when the naming and abstractions are not sufficient to convey the intent. For example, if a function performs a non-obvious operation or has side effects that are not clear from its name, a comment can help clarify its purpose. However, avoid adding comments that simply restate what the code does, as this can create noise and reduce readability.
- Don't use comments in tests unless absolutely necessary. Tests should be self-explanatory through clear naming and structure. If a test requires a comment to explain its purpose, consider whether the test can be refactored for clarity instead.

### Python

- Python 3.12+ syntax; use modern features (`match`, `|` union types, `tomllib`, `dataclasses`, etc.)
- Package management with `uv` (not `pip` directly)
- Linting and formatting with `ruff` (replaces flake8, isort, black)
- Type hints on all public APIs; strict mypy or pyright where configured
- Naming: `snake_case` for functions/variables, `PascalCase` for classes, `SCREAMING_SNAKE_CASE` for constants
- Line length: 120 characters
- Absolute imports only; group as stdlib → third-party → local
- Avoid adding pydocs to test functions, as they are often self-explanatory and can become outdated
- Add just pydoc to main/public functions, services and classes, but not to every single function or method, especially if their purpose is clear from their name and context

### Shell

- ZSH scripts with 4-space indentation (per `.editorconfig`)
- Prefer `bat` over `cat`, `eza` over `ls`, `fzf` for interactive selection
- Use aliases defined in `.zshrc` when suggesting shell commands

### Other Conventions

- 4-space indentation for JSON, Markdown, and shell scripts
- Markdown: use `-` for lists, not `*`; prefer fenced code blocks with language specified; no hard line breaks in paragraphs

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
- Remember to take into account the skills in `~/.agents/skills/` when suggesting code or commands