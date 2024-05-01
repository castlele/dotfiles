#! /bin/sh

# git clone https://github.com/tmux-plugins/tpm

OS_TYPE="$OSTYPE"
LINUX_MINT="linux-gnu"
MACOS="darwin"

if [[ $OS_TYPE == $LINUX_MINT* ]]; then
    sudo apt install tmux
elif [[ $OS_TYPE == $MACOS* ]]; then
    brew install tmux
fi
