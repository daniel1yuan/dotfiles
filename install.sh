#!/bin/sh
# Parameters:
# -f Force override
# -q quiet mode
# Optional
#   Home directory, new home directory to copy to. Default: ~/
#   Config directory, config directory to copy to. Default: ~/.config

HOME_DIR=$HOME
CONFIG_DIR=$HOME/.config
WORKING_DIR=$(pwd)

FORCE=0
VERBOSE=1

while getopts ":fq" opt; do
  case $opt in
    f)
      FORCE=1
      ;;
    q)
      VERBOSE=0
      ;;
    \?)
      echo "Invalid option: -$OPTARG" >&2
      ;;
  esac
done

# Shift all the arguments, so we can still use positional parameters
shift $(($OPTIND - 1))

log() {
  if [ $VERBOSE -eq 1 ]; then
    echo $1
  fi
}

get_abs_path() {
  echo $(cd $1; pwd)
}

install_file_dir() {
  local source=$WORKING_DIR/$1
  local target=$2
  local use_cp=$3

  log "Installing $source -> $target"
  if [ "$use_cp" = true ]; then
    cp -r $source $target
  else
    ln -s $source $target
  fi
}

install() {
  local source=$1
  local target=$2
  local use_cp=$3

  if [ -f $target ] || [ -d $target ] || [ -L $target ]; then
    if [ $FORCE -eq 1 ]; then
      if [ -d $target ]; then
        rm -rf $target
      else
        rm $target
      fi
      install_file_dir $source $target $use_cp
    else
      log "$target already exsists, please remove the file/dir or enable force mode -f"
    fi
  else
    install_file_dir $source $target $use_cp
  fi
}

if ! [ -z $1 ]; then
  log "Specified home directory: $1"
  HOME_DIR=$1
fi
HOME_DIR=$(get_abs_path $HOME_DIR)

if ! [ -z $2 ]; then
  log "Specified config directory: $2"
  CONFIG_DIR=$2
fi
CONFIG_DIR=$(get_abs_path $CONFIG_DIR)

if [ $FORCE -eq 1 ]; then
  log "Force mode activated"
fi

log "Installing dotfiles..."
log "Home Directory: $HOME_DIR"
log "Config Directory: $CONFIG_DIR"

# Install Submodules
git submodule init
git submodule update

install zsh/zshrc $HOME_DIR/.zshrc false
install zsh/zsh.d $HOME_DIR/.zsh.d false
install zsh/zplug $HOME_DIR/.zplug true

install vim/vimrc $HOME_DIR/.vimrc false
install vim/vim $HOME_DIR/.vim false

install kitty $CONFIG_DIR/kitty false 
