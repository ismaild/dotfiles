#!/bin/bash
############################
# .make.sh
# This script creates symlinks from the home directory to any desired dotfiles in ~/dotfiles
############################

########## Variables

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"                    # dotfiles directory
olddir=~/dotfiles_old_$(date +%Y%m%d_%H%M%S)             # old dotfiles backup directory
# list of files/folders to symlink in homedir
files="aliases bash_profile git-completion.bash gitconfig oracle_client vimrc vim zshrc"
themes="solarized-powerline.zsh-theme"

##########

# create dotfiles_old in homedir
echo -n "Creating $olddir for backup of any existing dotfiles in ~ ..."
mkdir -p $olddir
echo "done"

# change to the dotfiles directory
echo -n "Changing to the $dir directory ..."
cd $dir
echo "done"

# Check for Homebrew and install if not present
if ! command -v brew &> /dev/null; then
    echo "Homebrew not found. Installing..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install Homebrew packages
if [ -f "$dir/homebrew/Brewfile" ]; then
    echo "Installing Homebrew packages..."
    brew bundle --file="$dir/homebrew/Brewfile"
fi

# Check for git
if ! command -v git &> /dev/null; then
    echo "Error: git is not installed."
    exit 1
fi

# Setup git credentials
if [ ! -f ~/.gitconfig.local ]; then
    echo "Setting up Git credentials..."
    read -p "Please enter your Git global user name: " git_user
    read -p "Please enter your Git global user email: " git_email
    echo "[user]" > ~/.gitconfig.local
    echo "  name = $git_user" >> ~/.gitconfig.local
    echo "  email = $git_email" >> ~/.gitconfig.local
    echo "Git credentials saved to ~/.gitconfig.local"
fi

# move any existing dotfiles in homedir to dotfiles_old directory, then create symlinks from the homedir to any files in the ~/dotfiles directory specified in $files
for file in $files; do
    if [ -e ~/.$file ]; then
        echo "Moving existing user dotfile .$file from ~ to $olddir"
        mv ~/.$file $olddir/
    fi
    echo "Creating symlink to $file in home directory."
    ln -s $dir/$file ~/.$file
done

install_zsh () {
# Test to see if zshell is installed:
if [ -f /bin/zsh -o -f /usr/bin/zsh ]; then
    echo "ZSH installed!"
    # Clone my oh-my-zsh repository from GitHub only if it isn't already present
    if [[ ! -d $HOME/.oh-my-zsh ]]; then
      echo "Installing oh-my-zsh "
      git clone https://github.com/ohmyzsh/ohmyzsh.git $HOME/.oh-my-zsh
    fi
    
    # Install Zsh Autosuggestions
    if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
        echo "Installing zsh-autosuggestions..."
        git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    fi

    # Install Zsh Syntax Highlighting
    if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting" ]; then
        echo "Installing zsh-syntax-highlighting..."
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    fi
    # Set the default shell to zsh if it isn't currently set to zsh
    if [[ ! $(echo $SHELL) == $(which zsh) ]]; then
        chsh -s $(which zsh)
    fi
    # Applied themes
    for theme in $themes; do
      if [ -f "$dir/ohmyzsh/$theme" ]; then
          echo "Installing theme: $theme"
          rm -f "$HOME/.oh-my-zsh/themes/$theme"
          ln -s "$dir/ohmyzsh/$theme" "$HOME/.oh-my-zsh/themes/$theme"
      else
          echo "Warning: Theme file $dir/ohmyzsh/$theme not found!"
      fi
    done

else
    # If zsh isn't installed, get the platform of the current machine
    platform=$(uname);
    # If the platform is Linux, try an apt-get to install zsh and then recurse
    if [[ $platform == 'Linux' ]]; then
        sudo apt-get install zsh
        install_zsh
    # If the platform is OS X, tell the user to install zsh :)
    elif [[ $platform == 'Darwin' ]]; then
        echo "Please install zsh, then re-run this script!"
        exit
    fi
fi
}

install_zsh
