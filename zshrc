# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
ZSH_THEME="solarized-powerline"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
plugins=(git rbenv bundler rails macos pyenv zsh-autosuggestions zsh-syntax-highlighting)

# User configuration
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin":$PATH

# Pyenv configuration
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init --path)"
fi
# Dynamically add Python user base bin to PATH (fallback if pyenv not active)
if command -v python3 >/dev/null; then
    export PATH="$(python3 -m site --user-base)/bin:$PATH"
fi

source $ZSH/oh-my-zsh.sh

export LANG=en_ZA.UTF-8

# Pyenv init handled by oh-my-zsh plugin

if [ -d "$HOME/.prv_env" ]; then
  source ~/.prv_env
fi

if [ -f ~/.oracle_client ]; then
  source ~/.oracle_client
fi
source ~/.aliases
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

