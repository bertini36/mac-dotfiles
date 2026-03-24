<h3 align="center">
    bertini36/mac-dotfiles 
</h3>
<p align="center">
My personal Mac setup and configurations
</p>

## 🚀 Setup

- Download code:

    ```bash
    git clone https://github.com/bertini36/mac-dotfiles.git ~/.dotfiles/
    ```

- Brew packages installation:

    ```bash
    brew bundle --file=mac/Brewfile
    ```

    | Package | Description |
    |---|---|
    | [`bat`](https://github.com/sharkdp/bat) | `cat` with syntax highlighting |
    | [`eza`](https://github.com/eza-community/eza) | Modern `ls` replacement |
    | [`fzf`](https://github.com/junegunn/fzf) | Fuzzy finder for the terminal |
    | [`gh`](https://github.com/cli/cli) | GitHub CLI |
    | [`pre-commit`](https://github.com/pre-commit/pre-commit) | Git hook manager |
    | [`graphviz`](https://gitlab.com/graphviz/graphviz) | Graph visualization tools |
    | [`jq`](https://github.com/jqlang/jq) | JSON processor |
    | [`libmagic`](https://github.com/file/file) | File type detection library |
    | [`gotop`](https://github.com/xxxserxxx/gotop) | Terminal system monitor |
    | [`gemini-cli`](https://github.com/google-gemini/gemini-cli) | Google Gemini AI CLI |
    | [`copilot-cli`](https://github.com/github/copilot-cli) | GitHub Copilot CLI (cask) |
    | [`mole`](https://github.com/tw93/Mole) | macOS disk space cleaner and system optimizer |
    | [`postgresql@18`](https://github.com/postgres/postgres) | PostgreSQL database |
    | [`pyenv`](https://github.com/pyenv/pyenv) | Python version manager |
    | [`uv`](https://github.com/astral-sh/uv) | Fast Python package manager |
    | [`python@3.14`](https://github.com/python/cpython) | Python interpreter |
    | [`tldr`](https://github.com/tldr-pages/tldr) | Simplified man pages with practical examples |
    | [`karabiner-elements`](https://github.com/pqrs-org/Karabiner-Elements) | Keyboard remapper (cask) |

- Extra packages installation (not available through Brew):

    ```bash
    bash mac/install_extras.sh
    ```

    | Package | Description |
    |---|---|
    | `claude` | Anthropic Claude CLI |

- Add fonts (`fonts/`) to `Font Book`
- Configure [Karabiner](https://karabiner-elements.pqrs.org/)
  - Change `Caps Lock` to `CMD + CTL + Option + Shift`
  - Map F4 to `CMD + Space` (Raycast)
- Install [Oh My ZSH](https://ohmyz.sh/)
  * Link `shell/.zshrc` to `~/.zshrc`: `ln ~/.dotfiles/shell/.zshrc ~/.zshrc`
  * Install plugins

    ```bash
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/agkozak/zsh-z ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-z
    ```

- Install [Raycast](https://www.raycast.com/)
  * Disable Spotlight shortcut to enable Raycast one (System Preferences -> Keyboard -> Shortcuts -> Spotlight -> Uncheck `Show Spotlight search`)
  * Configure shortcuts following [keymap.md](docs/keymap.md)
- Install [Iterm2](https://iterm2.com/)
- Install [Docker](https://docs.docker.com/desktop/install/mac-install/)
- Install [Jetbrains Toolbox](https://www.jetbrains.com/toolbox-app/) and [Pycharm](https://www.jetbrains.com/pycharm/)
- Install [Visual Studio Code](https://code.visualstudio.com/)
  * Install extensions:
    - [Container tools](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker)
    - [Dev containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
    - [Django](https://marketplace.visualstudio.com/items?itemName=batisteo.vscode-django)
    - [Github Copilot Chat](https://marketplace.visualstudio.com/items?itemName=GitHub.copilot-chat)
    - [GitLens](https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens)
    - [Lark grammar syntax support](https://marketplace.visualstudio.com/items?itemName=lark-parser.lark)
    - [Markdown Preview Mermaid Support](https://marketplace.visualstudio.com/items?itemName=bierner.markdown-mermaid)
    - [Tokyo Night](https://marketplace.visualstudio.com/items?itemName=enkia.tokyo-night)
    - [Pylance](https://marketplace.visualstudio.com/items?itemName=ms-python.vscode-pylance)
    - [Python](https://marketplace.visualstudio.com/items?itemName=ms-python.python)
    - [Ruff](https://marketplace.visualstudio.com/items?itemName=charliermarsh.ruff)
    - [shift shift](https://marketplace.visualstudio.com/items?itemName=ahebrank.shortcut-menu-bar)
    - [Tailwind CSS IntelliSense](https://marketplace.visualstudio.com/items?itemName=bradlc.vscode-tailwindcss)
    - [Auto-interpreter for PEP723 (uv)](https://marketplace.visualstudio.com/items?itemName=nsarrazin.pep723-uv-interpreter)

- Enable auto-focus: `defaults write com.apple.Terminal FocusFollowsMouse -bool true`
- Link the rest of configuration files

  ```bash
  ln -s ~/.dotfiles/git/.gitignore_global ~/.gitignore_global
  git config --global core.excludesfile ~/.gitignore_global

  ln -s ~/.dotfiles/editors/vim/.vimrc ~/.vimrc

  ln -s ~/.dotfiles/editors/claude/settings.json ~/.claude/settings.json
  ln -s ~/.dotfiles/editors/claude/statusline-command.sh ~/.claude/statusline-command.sh
  ln -s ~/.dotfiles/agents/skills ~/.claude/skills
  ln -s ~/.dotfiles/agents/AGENTS.md ~/.claude/AGENTS.md
  ln -s ~/.dotfiles/agents/CLAUDE.md ~/.claude/CLAUDE.md

  ln -s ~/.dotfiles/agents ~/.agents

  ln -s ~/.dotfiles/agents/skills ~/.copilot/skills
  ln -s ~/.dotfiles/agents/AGENTS.md ~/.copilot/AGENTS.md
  ```

## 🧠 Skills

This repo includes a set of reusable AI agent skills under `agents/skills/`. Each skill encodes domain-specific knowledge that the agent can apply when a task falls within its scope.

| Skill | Description |
|---|---|
| `create-pull-request` | Create a GitHub PR following project conventions using `gh` CLI |
| `ddd-patterns` | DDD entities, aggregate roots, value objects, repositories, domain services, and specifications |
| `django-patterns` | Django architecture, REST APIs with Pydantic, ORM best practices, caching, and signals |
| `langchain-architecture` | LangChain 1.x and LangGraph for agents, memory, and tool integration |
| `production-code-audit` | Deep-scan a codebase and transform it to production-grade quality |
| `python-code-style` | Python linting, formatting, naming conventions, type safety, and documentation |
| `writing-clearly-and-concisely` | Clear prose for docs, commits, error messages, and UI text |

### Evals

Each skill has an `evals/evals.json` file that defines test cases to measure skill effectiveness. To run the evals paste the following command your AI agent prompt.

1. Read the eval definitions in `agents/skills/<skill>/evals/evals.json`
2. Generate outputs — Run each eval prompt twice per skill (once with the skill loaded, once without) and save the results to agents/skills-workspace/iteration-1/<eval-id>/with_skill/outputs/ and without_skill/outputs/.
3. Create eval_metadata.json — Record the assertions from each eval's expectations array alongside references to the output files.
4. Compare outputs in `agents/skills-workspace/iteration-1/<eval>/with_skill/outputs/` vs `without_skill/outputs/`
5. Verify each assertion from `eval_metadata.json` against the corresponding output

## 🔌 Claude Plugins

Install the following MCP server plugins in Claude:

| Plugin | Description |
|---|---|
| [`superpowers`](https://github.com/obra/superpowers) | Spec driven development (SDD) based on brainstorming, planning, subagent-driven execution, TDD, and code review skills |
| [`pyright-lsp`](https://github.com/anthropics/claude-plugins-official/tree/main/plugins/pyright-lsp) | Python type checking and language server integration |
| [`notion`](https://github.com/makenotion/notion-mcp-server) | Read and manage Notion pages and databases |
| [`figma`](https://github.com/figma/mcp-server-guide) | Read Figma designs and generate code from them |
| [`context7`](https://github.com/upstash/context7) | Up-to-date documentation and code examples for any library |
| [`claude-mem`](https://github.com/thedotmack/claude-mem) | Persistent cross-session memory database with smart search and timeline reports |
| [`sentry-skills`](https://github.com/getsentry/skills) | Sentry engineering skills: PR writing, code review, Django patterns, security review, and more |
| `datadog-mcp` | Datadog observability: logs, metrics, traces, incidents, monitors, and dashboards |

Install Datadog MCP:

```bash
claude mcp add --transport http datadog-mcp https://mcp.datadoghq.eu/api/unstable/mcp-server/mcp
```

<br />
<p align="center">Built with ❤️ from Mallorca</p>