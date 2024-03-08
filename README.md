<h3 align="center">
    bertini36/mac-dotfiles 
</h3>
<p align="center">
My personal Mac config files
</p>

## 🚀 Setup

- Download code
    ```bash
    git clone https://github.com/bertini36/mac-dotfiles.git ~/.dotfiles/
    ```
- Brew packages installation:
    ```
    cd mac/
    brew bundle
    ```
- Add fonts (`fonts/`) to `Font Book`
- Install [Iterm2](https://iterm2.com/)
  * Import config (`shell/Iterm2.json`) (Profiles -> Other Actions -> Import JSON Profiles)
  * Ensure color theme (`shell/nord.itemcolors`)
  * Set [Monospace Neon](https://monaspace.githubnext.com/) font (Profiles -> Text -> Font -> Fira Code)
- Install [Oh My ZSH](https://ohmyz.sh/)
  * Link `shell/.zshrc` to `~/.zshrc`: `ln ~/.dotfiles/shell/.zshrc ~/.zshrc`
  * Install plugins
    ```
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone https://github.com/agkozak/zsh-z ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-z
    ```
- Install [Raycast](https://www.raycast.com/)
  * Disable Spotlight shortcut to enable Raycast one (System Preferences -> Keyboard -> Shortcuts -> Spotlight -> Uncheck `Show Spotlight search`)
- Install [Rectangle](https://rectangleapp.com/)
- Install [Pycharm](https://www.jetbrains.com/pycharm/download/#section=mac)
  * Login
  * Set `Alberto's Mac keymap` (Settings -> Keymap -> Keymaps dropdown)
  * Set `Monospace Neon` font (Settings -> Editor -> Font -> Monospace Neon)
- Install [Docker](https://docs.docker.com/desktop/install/mac-install/)
- Install [Github Desktop](https://desktop.github.com/)
- Install [Alt Tab](https://alt-tab-macos.netlify.app/)
- Enable auto-focus: `defaults write com.apple.Terminal FocusFollowsMouse -bool true`
- Link the rest of configuration files
  ```
  ln ~/.dotfiles/editors/vim/.vimrc ~/.vimrc
  ln ~/.dotfiles/git/.gitignore_global ~/.gitignore_global
  ln ~/.dotfiles/langs/python/.direnvrc ~/.direnvrc
  ```
<br />
<p align="center">&mdash; Built with :heart: from Mallorca &mdash;</p>