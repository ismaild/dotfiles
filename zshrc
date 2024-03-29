# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load.
ZSH_THEME="agnoster"

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
plugins=(git rbenv zsh-autosuggestions zsh-syntax-highlighting)

# User configuration
export PATH="/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin":$PATH
export PATH="/Users/ismail/Library/Python/3.8/bin":$PATH

source $ZSH/oh-my-zsh.sh

export LANG=en_ZA.UTF-8

# only setup rbenv if we have it installed
if [ -d "$HOME/.rbenv" ]; then
  export PATH="$HOME/.rbenv/bin:$PATH"
  eval "$(rbenv init - --no-rehash)"
fi

if [ -d "$HOME/.prv_env" ]; then
  source ~/.prv_env
fi

source ~/.oracle_client
source ~/.aliases
test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

