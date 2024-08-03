#!/bin/bash

OS_TYPE="$OSTYPE"
LINUX_MINT="linux-gnu"
MACOS="darwin"

if [[ $OS_TYPE == $LINUX_MINT* ]]; then
    INSTALLATION_CMD="sudo apt install"
elif [[ $OS_TYPE == $MACOS* ]]; then
    INSTALLATION_CMD="brew install"
fi

CONFIG_DIR="$HOME/.config"
PWD=$(pwd)
EMAIL=$1

createConfigDir() {
    if [ ! -d "~/.config" ]; then
        echo "Creating .config dir"
    fi
}

setupGit() {
    echo "Set up git"
    echo "Generating new ssh key"
    ssh-keygen -t ed25519 -C "$EMAIL"
    eval "$(ssh-agent -s)"
    ssh-add ~/.ssh/id_ed25519
    cat ~/.ssh/id_ed25519.pub

    cp gitconfig ~/.gitconfig
}

cloneProjects() {
    git submodule update --init --recursive
}

setupNeovim() {
    echo "Setup Neovim"

    cargo install tree-sitter-cli

    ln -s $PWD/nvim/ $CONFIG_DIR/nvim

    cd nvim
    ./setup.sh
    cd ..
}

setupTmux() {
    echo "Setup Tmux"

    ln -s $PWD/tmux/ $CONFIG_DIR/tmux
    cd tmux
    ./setup.sh
    cd ..
}

setupLazygit() {
    echo "Setup Lazygit"

    LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
    curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
    tar xf lazygit.tar.gz lazygit
    sudo install lazygit /usr/local/bin
}

setupKitty() {
    echo "Setup Kitty"

    ln -s $PWD/kitty/ $CONFIG_DIR/kitty
}

echo $PWD

if [ -z $EMAIL ]; then
    cloneProjects
    setupTmux
    setupLazygit
    setupNeovim
    setupKitty
else
    setupGit
fi

