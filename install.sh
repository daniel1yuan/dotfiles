#!/bin/sh
HOME_DIR=$HOME
CONFIG_DIR=$HOME/.config

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

install_file_dir() {
  local source=$1
  local target=$2

  log "Installing $source -> $target"
  if [ -d $source ]; then
    log "Recursively copying?"
    cp -r $source $target
  else
    log "install file?"
    cp $source $target
  fi
}

install() {
  local source=$1
  local target=$2

  if [ -e $target ] || [ -d $target ]; then
    if [ $FORCE -eq 1 ]; then
      if [ -d $target ]; then
        rm -rf $target
      else
        rm $target
      fi
      install_file_dir $source $target
    else
      log "$target already exsists, please remove the file/dir or enable force mode -f"
    fi
  else
    install_file_dir $source $target
  fi
}

if ! [ -z $1 ]; then
  log "Specified home directory: $1"
  HOME_DIR=$1
fi

if ! [ -z $2 ]; then
  log "Specified config directory: $2"
  CONFIG_DIR=$2
fi

log "Installing dotfiles..."
log "Home Directory: $HOME_DIR"
log "Config Directory: $CONFIG_DIR"

install zshrc $HOME_DIR/.zshrc
install zsh.d $HOME_DIR/.zsh.d

# install vimrc $HOME_DIR/.vimrc
# install vim $HOME_DIR/.vim

# install kitty $CONFIG_DIR/kitty
