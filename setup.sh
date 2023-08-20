#! /bin/sh

config_dir="$HOME/.config"
nvim_submodule_dir="/nvim"
nvim_config_dir=$config_dir$nvim_submodule_dir
tmux_submodule_dir="/tmux"
tmux_config_dir=$config_dir$tmux_submodule_dir
pwd=$(pwd)

create_directories()
{
    if [ ! -d $config_dir ]; then
        echo "Creating .config directory..."
        mkdir $config_dir
    fi
}

clone_projects()
{
    if [ ! -d "."$nvim_submodule_dir ]; then
        git clone git@github.com:castlele/nvim.git
    fi

    if [ ! -d "."$tmux_submodule_dir ]; then
        git clone git@github.com:castlele/tmux.git
    fi

    git submodule update --init --recursive
}

symlink_dotfiles()
{
    if [ ! -d $nvim_config_dir ]; then
        echo "Creating symlink for nvim config"
        ln -s $pwd$nvim_submodule_dir $nvim_config_dir
    fi

    if [ ! -d $tmux_config_dir ]; then
        echo "Creating symlink for tmux config"
        ln -s $pwd$tmux_submodule_dir $tmux_config_dir
    fi
}

setup_dotfiles()
{
    echo "Configuration of nvim config"
    cd $nvim_config_dir
    ./setup.sh

    echo "Configuration of tmux config"
    cd $tmux_config_dir
    ./setup.sh
}

create_directories
clone_projects
symlink_dotfiles
setup_dotfiles
