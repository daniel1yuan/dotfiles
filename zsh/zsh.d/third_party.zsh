# Adding NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/danielyuan/.anaconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/danielyuan/.anaconda3/etc/profile.d/conda.sh" ]; then
        . "/home/danielyuan/.anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/danielyuan/.anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

# Adding Go
export PATH=$PATH:/usr/local/go/bin
