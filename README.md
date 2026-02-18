<h3 align="center">
    bertini36/mac-dotfiles 
</h3>
<p align="center">
My personal Mac config files
</p>

## 🚀 Setup

- Download code:

    ```bash
    git clone https://github.com/bertini36/mac-dotfiles.git ~/.dotfiles/
    ```

- Brew packages installation:

    ```bash
    cd mac/
    brew bundle
    ```

- Add fonts (`fonts/`) to `Font Book`
- Install [Karabiner](https://karabiner-elements.pqrs.org/)
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
- Install [Docker](https://docs.docker.com/desktop/install/mac-install/)
- Install [Github Desktop](https://desktop.github.com/)
- Install [Visual Studio Code](https://code.visualstudio.com/)
  * Install extensions:
    - [Container tools](https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-docker)
    - [Dev containers](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers)
    - [Django](https://marketplace.visualstudio.com/items?itemName=batisteo.vscode-django)
    - [Github Copilot Chat](https://marketplace.visualstudio.com/items?itemName=GitHub.copilot-chat)
    - [GitLens](https://marketplace.visualstudio.com/items?itemName=eamodio.gitlens)
    - [Lark grammar syntax support](https://marketplace.visualstudio.com/items?itemName=lark-parser.lark)
    - [Markdown Preview Mermaid Support](https://marketplace.visualstudio.com/items?itemName=bierner.markdown-mermaid)
    - [Monokai Pro](https://marketplace.visualstudio.com/items?itemName=monokai.theme-monokai-pro-vscode)
    - [Pylance](https://marketplace.visualstudio.com/items?itemName=ms-python.vscode-pylance)
    - [Python](https://marketplace.visualstudio.com/items?itemName=ms-python.python)
    - [Python environments](https://marketplace.visualstudio.com/items?itemName=ms-python.vscode-python-envs)
    - [Ruff](https://marketplace.visualstudio.com/items?itemName=charliermarsh.ruff)
    - [shift shift](https://marketplace.visualstudio.com/items?itemName=ahebrank.shortcut-menu-bar)
    - [Tailwind CSS IntelliSense](https://marketplace.visualstudio.com/items?itemName=bradlc.vscode-tailwindcss)

- Enable auto-focus: `defaults write com.apple.Terminal FocusFollowsMouse -bool true`
- Install brew packages from Brewfile

  ```bash
  brew bundle --file=mac/Brewfile
  ```
- Link the rest of configuration files

  ```bash
  ln ~/.dotfiles/git/.gitignore_global ~/.gitignore_global
  ln ~/.dotfiles/langs/python/.direnvrc ~/.direnvrc
  ln ~/.dotfiles/editors/vim/.vimrc ~/.vimrc
  ```
  
<br />
<p align="center">&mdash; Built with ❤️ from Mallorca &mdash;</p>