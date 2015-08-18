dotfiles
--------

My dot files, a work in progess

Linux Setup
---



# install ZSH
sudo apt-get install zsh

# change shell
chsh -s /usr/bin/zsh

# install oh my
sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

git clone https://github.com/ismaild/dotfiles
ln -s ~/dotfiles/vim .vim
ln -s ~/dotfiles/vimrc .vimrc -f
ln -s ~/dotfiles/git/git-completion.bash .git-completion.bash
ln -s ~/dotfiles/zshrc .zshrc
ln -s ~/dotfiles/gitconfig .gitconfig
ln -s ~/dotfiles/gitignore .gitignore




