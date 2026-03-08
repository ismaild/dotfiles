# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
ZSH_THEME="solarized-powerline"

# Which plugins would you like to load?
plugins=(git rbenv bundler rails macos pyenv zsh-autosuggestions zsh-syntax-highlighting)

# Homebrew PATH for Apple Silicon and Intel
if [[ -d /opt/homebrew/bin ]]; then
  export PATH="/opt/homebrew/bin:/opt/homebrew/sbin:$PATH"
elif [[ -d /usr/local/bin ]]; then
  export PATH="/usr/local/bin:$PATH"
fi

# Ensure basic system paths are included
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:$PATH"

# Pyenv configuration (Plugin handles init, we just set the root)
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"

# Python user base bin (fallback)
if command -v python3 >/dev/null; then
    export PATH="$(python3 -m site --user-base)/bin:$PATH"
fi

# Load Oh My Zsh
source $ZSH/oh-my-zsh.sh

# Preferred language
export LANG=en_ZA.UTF-8

# Private environments and clients
[[ -d "$HOME/.prv_env" ]] && source ~/.prv_env
[[ -f ~/.oracle_client ]] && source ~/.oracle_client
[[ -f ~/.aliases ]] && source ~/.aliases

# iTerm2 Integration
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

export DOCKER_BUILDKIT=1
