#!/bin/bash

############################
# symlink.sh
# This script creates symlinks from the home directory to any desired dotfiles in this repository.
############################

set -e

# Colors for output
NC='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'

log_info()    { printf "${BLUE}[INFO]${NC}  %s\n" "$1"; }
log_success() { printf "${GREEN}[OK]${NC}    %s\n" "$1"; }
log_warn()    { printf "${YELLOW}[WARN]${NC}  %s\n" "$1"; }
log_error()   { printf "${RED}[ERROR]${NC} %s\n" "$1"; }

dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
olddir=~/dotfiles_old_$(date +%Y%m%d_%H%M%S)
backup_created=false
dry_run=false

# Check for dry-run flag
if [[ "$1" == "--dry-run" || "$1" == "-d" ]]; then
    dry_run=true
    log_info "DRY RUN ENABLED - No changes will be made."
fi

# Files/folders in the root of the dotfiles repo to EXCLUDE from symlinking
exclude_list=(".git" ".gitignore" "README.md" "symlink.sh" "homebrew" "ohmyzsh" "pip" "sublime")

ensure_backup_dir() {
    if [ "$dry_run" = true ]; then
        log_info "[DRY RUN] Would create backup directory: $olddir"
        return
    fi
    if [ "$backup_created" = false ]; then
        log_info "Creating $olddir for backup of existing dotfiles..."
        mkdir -p "$olddir"
        backup_created=true
    fi
}

# 1. Homebrew Setup
if ! command -v brew &> /dev/null; then
    if [ "$dry_run" = true ]; then
        log_info "[DRY RUN] Would install Homebrew."
    else
        log_info "Homebrew not found. Installing..."
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
fi

if [ -f "$dir/homebrew/Brewfile" ]; then
    if [ "$dry_run" = true ]; then
        log_info "[DRY RUN] Would sync Homebrew packages from $dir/homebrew/Brewfile."
    else
        log_info "Syncing Homebrew packages..."
        brew bundle --file="$dir/homebrew/Brewfile"
    fi
fi

# 2. Git Local Config
if [ ! -f ~/.gitconfig.local ]; then
    if [ "$dry_run" = true ]; then
        log_info "[DRY RUN] Would prompt for Git credentials and create ~/.gitconfig.local."
    else
        log_warn "Git credentials not found."
        read -p "Enter Git user name: " git_user
        read -p "Enter Git user email: " git_email
        cat <<EOF > ~/.gitconfig.local
[user]
  name = $git_user
  email = $git_email
EOF
        log_success "Git credentials saved to ~/.gitconfig.local"
    fi
fi

# 3. Dynamic Symlinking
log_info "Starting symlink process..."
cd "$dir"

# Loop through all files/dirs in the root, excluding the list above
for file in *; do
    # Skip if in exclude list
    should_skip=false
    for exclude in "${exclude_list[@]}"; do
        if [[ "$file" == "$exclude" ]]; then
            should_skip=true
            break
        fi
    done
    [[ "$should_skip" == true ]] && continue

    target="$HOME/.$file"
    source="$dir/$file"

    if [ -L "$target" ]; then
        current_link=$(readlink "$target")
        if [ "$current_link" == "$source" ]; then
            log_success "Already linked: $file"
            continue
        else
            log_warn "Link mismatch for $file: points to $current_link."
            if [ "$dry_run" = true ]; then
                log_info "[DRY RUN] Would move existing link to backup and create new link."
            else
                ensure_backup_dir
                mv "$target" "$olddir/"
                ln -s "$source" "$target"
                log_success "Linked: $file -> $target"
            fi
        fi
    elif [ -e "$target" ]; then
        log_warn "Existing file found for $file."
        if [ "$dry_run" = true ]; then
            log_info "[DRY RUN] Would move existing file to backup and create new link."
        else
            ensure_backup_dir
            mv "$target" "$olddir/"
            ln -s "$source" "$target"
            log_success "Linked: $file -> $target"
        fi
    else
        if [ "$dry_run" = true ]; then
            log_info "[DRY RUN] Would create link: $file -> $target"
        else
            ln -s "$source" "$target"
            log_success "Linked: $file -> $target"
        fi
    fi
done

# 4. Zsh & Oh My Zsh Setup
install_omz_and_plugins() {
    if [[ ! -d $HOME/.oh-my-zsh ]]; then
        if [ "$dry_run" = true ]; then
            log_info "[DRY RUN] Would install oh-my-zsh."
        else
            log_info "Installing oh-my-zsh..."
            git clone --depth=1 https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
        fi
    fi

    # Zsh Plugins
    local plugins_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"
    
    if [ ! -d "$plugins_dir/zsh-autosuggestions" ]; then
        if [ "$dry_run" = true ]; then
            log_info "[DRY RUN] Would install zsh-autosuggestions."
        else
            mkdir -p "$plugins_dir"
            log_info "Installing zsh-autosuggestions..."
            git clone --depth=1 https://github.com/zsh-users/zsh-autosuggestions "$plugins_dir/zsh-autosuggestions"
        fi
    fi

    if [ ! -d "$plugins_dir/zsh-syntax-highlighting" ]; then
        if [ "$dry_run" = true ]; then
            log_info "[DRY RUN] Would install zsh-syntax-highlighting."
        else
            mkdir -p "$plugins_dir"
            log_info "Installing zsh-syntax-highlighting..."
            git clone --depth=1 https://github.com/zsh-users/zsh-syntax-highlighting.git "$plugins_dir/zsh-syntax-highlighting"
        fi
    fi

    # Custom Theme
    local theme_file="solarized-powerline.zsh-theme"
    if [ -f "$dir/ohmyzsh/$theme_file" ]; then
        if [ "$dry_run" = true ]; then
            log_info "[DRY RUN] Would install custom theme."
        else
            log_info "Installing custom theme..."
            mkdir -p "$HOME/.oh-my-zsh/themes"
            ln -sf "$dir/ohmyzsh/$theme_file" "$HOME/.oh-my-zsh/themes/$theme_file"
        fi
    fi
}

if command -v zsh &> /dev/null; then
    install_omz_and_plugins
    if [[ "$SHELL" != "$(which zsh)" ]]; then
        log_info "Changing shell to zsh..."
        chsh -s "$(which zsh)"
    fi
else
    log_error "Zsh not found. Please install it manually."
fi

log_success "Dotfiles setup complete!"
