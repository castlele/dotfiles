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

installAlacritty() {
    echo "Downloading alacritty"

    if [[ $OS_TYPE == $LINUX_MINT* ]]; then
        $INSTALLATION_CMD cmake clang
	$INSTALLATION_CMD pkg-config libfreetype6-dev libfontconfig1-dev libxcb-xfixes0-dev libxkbcommon-dev python3
        $INSTALLATION_CMD cargo
        cargo install alacritty
	sudo mv ~/.cargo/bin/alacritty /usr/local/alacritty
	sudo cp Alacritty.desktop /usr/share/applications/
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
    #cloneProjects
    #installAlacritty
    #setupAlacritty
    #setupTmux
    #setupLazygit
    setupNeovim
else
    setupGit
fi

