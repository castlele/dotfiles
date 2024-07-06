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
    echo "Set up Neovim"
}

setupTmux() {
    echo "Setup Tmux"
}

installAlacritty() {
    echo "Downloading alacritty"

    if [[ $OS_TYPE == $LINUX_MINT* ]]; then
        $INSTALLATION_CMD cmake
        $INSTALLATION_CMD clang
        $INSTALLATION_CMD cargo
        cargo install alacritty
    elif [[ $OS_TYPE == $MACOS* ]]; then
        $INSTALLATION_CMD cmake
    fi
}

setupAlacritty() {
    echo "Creating symlink for alacritty config"

    createConfigDir

    alacrittyDir="$CONFIG_DIR/alacritty/"

    if [ ! -d $alacrittyDir ]; then
        mkdir $alacrittyDir
    fi

    alacrittyThemeDir="alacritty/alacritty-theme"

    if [ ! -d $alacrittyThemeDir ]; then
        mkdir $alacrittyThemeDir
    fi

    ln -s $PWD/$alacrittyThemeDir $CONFIG_DIR/$alacrittyThemeDir
    cp .alacritty.toml ~/.alacritty.toml
}

symlink_dotfiles() {
    if [ ! -d $alacritty_config_dir ]; then
        echo "Creating symlink for alacritty config"
        ln -s $pwd$alacritty_dir $alacritty_config_dir
        cp alacritty.toml ~/.alacritty.toml
    fi

    if [ ! -d $nvim_config_dir ]; then
        echo "Creating symlink for nvim config"
        ln -s $pwd$nvim_submodule_dir $nvim_config_dir
    fi

    if [ ! -d $tmux_config_dir ]; then
        echo "Creating symlink for tmux config"
        ln -s $pwd$tmux_submodule_dir $tmux_config_dir
    fi
}

setup_dotfiles() {
    echo "Configuration of nvim config"
    cd $nvim_config_dir
    ./setup.sh

    echo "Configuration of tmux config"
    cd $tmux_config_dir
    ./setup.sh
}

echo $PWD

if [ -z $EMAIL ]; then
    cloneProjects
    installAlacritty
    setupAlacritty
else
    setupGit
fi

