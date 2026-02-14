# Dotfiles

A collection of dotfiles for macOS.

## Features

*   **Zsh Theme**: Custom `solarized-powerline` theme for a beautiful, informative prompt.
*   **Colors**: Solarized configured for Vim, iTerm, and Sublime Text.
*   **Dynamic Configuration**: python path dynamic resolution and platform-specific aliases.
*   **Easy Installation**: Automated script to backup existing dotfiles and symlink new ones.

## Installation

### Prerequisites

*   `git`
*   `zsh`

### Setup

The installation process is automated. It will:
1.  Check for **Homebrew** and install it if missing.
2.  Install required packages and **Powerline Fonts** from `homebrew/Brewfile`.
3.  Backup your existing dotfiles to `~/dotfiles_old_<timestamp>`.
4.  Symlink the new dotfiles to your home directory.
5.  Install **Oh My Zsh** and the **Solarized Powerline** theme.

```bash
git clone https://github.com/ismaild/dotfiles.git
cd dotfiles
./symlink.sh
```

## Features

*   **gitconfig**: common aliases, color configuration (Solarized-friendly), and credential helper. Prompts for user/email on first run.
*   **zshrc**: Oh My Zsh plugins (`git`, `rbenv`, `zsh-autosuggestions`, `zsh-syntax-highlighting`), dynamic path, and custom theme.
*   **vimrc**: Solarized colorscheme and basic settings.
*   **aliases**: Useful abbreviations and macOS-specific commands.
*   **oracle_client**: Oracle client environment variables (optional sourcing).
*   **prv_env**: Private environment variables (optional sourcing).
*   **Homebrew**: Automated installation of packages and fonts.
*   **Fonts**: Installs `Source Code Pro for Powerline` automatically.

## Post-Installation

1.  **iTerm2 Colors**:
    *   Open Preferences > Profiles > Colors.
    *   Load Presets... > Select **Solarized Dark** (built-in).
2.  **iTerm2 Fonts**:
    *   Open Preferences > Profiles > Text.
    *   Change Font to **Source Code Pro for Powerline**.
    *   Check "Use a different font for non-ASCII text" if you see missing glyphs.


