#! /bin/sh

config_dir="$HOME/.config"
nvim_submodule_dir="/nvim"
nvim_config_dir=$config_dir$nvim_submodule_dir
tmux_submodule_dir="/tmux"
tmux_config_dir=$config_dir$tmux_submodule_dir
alacritty_dir="/alacritty"
alacritty_config_dir=$config_dir$alacritty_dir
pwd=$(pwd)

clone_projects() {
    git submodule update --init --recursive
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

clone_projects
symlink_dotfiles
setup_dotfiles
