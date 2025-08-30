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

    curl https://sh.rustup.rs -sSf | sh
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

    if [[ $OS_TYPE == $LINUX_MINT* ]]; then
        LAZYGIT_VERSION=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep -Po '"tag_name": "v\K[^"]*')
        curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/latest/download/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
        tar xf lazygit.tar.gz lazygit
        sudo install lazygit /usr/local/bin
    fi
}

setupKitty() {
    echo "Setup Kitty"

    ln -s $PWD/kitty/ $CONFIG_DIR/kitty
}

setupYazi() {
    echo "Setup Yazi"

    cd yazi
    ./setup.sh
    cd ..
    ln -s $PWD/yazi/ $CONFIG_DIR/yazi
}

setupGhostty() {
    echo "Setup ghostty"

    ln -s $PWD/ghostty/ $CONFIG_DIR/ghostty
}

setupZsh() {
    if [[ $OS_TYPE == $LINUX_MINT* ]]; then
        sudo apt install zsh
        chsh -s $(which zsh)

        echo "Restart your computer :)"
    fi
}

setupOhMyZsh() {
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
}

setupZshContent() {
    cat ./zshrc/zshrc > ~/.zshrc
    echo "Run `source ~/.zshrc` to apply changes"
}

setupRmpc() {
    $INSTALLATION_CMD rmpc
    ln -s $PWD/rmpc $CONFIG_DIR/rmpc
}

setupMpd() {
    $INSTALLATION_CMD mpd mpc
    ln -s $PWD/mpd $CONFIG_DIR/mpd
}

echo $PWD

if [ -z $EMAIL ]; then
    cloneProjects
    setupZsh
    setupOhMyZsh
    setupZshContent
    setupTmux
    setupLazygit
    setupNeovim
    setupKitty
    setupYazi
    setupMpd
    setupRmpc
else
    setupGit
fi

