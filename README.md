# Dotfiles
Dotfiles for zsh, vim, and kitty terminal

### Run
`sh install.sh -f`: Forcefully install dotfiles in default home and config directories
`sh install.sh -fq <new home directory> <new config directory>` All parameters specified for force, quiet, and new home/config directories

#### Optional Flags
`-f`: Force mode. This will override existing files and forcefully replace them with current dotfiles
`-q`: Quiet mode. This will supress all logging to the console

#### Optional Positional Arguments
`Home Directory`: Specify different home directory. Default is `~`
`Config Directory`: Specify different config directory. Dfault is `~/.config`
