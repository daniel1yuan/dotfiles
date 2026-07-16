# AWS CLI: profile switcher + tab completion.
# aws-profile <name> sets AWS_PROFILE; aws-profile clear unsets it; aws-profile
# (no args) prints the current value. Tab-completion reads ~/.aws/config.

# Bash-style `complete -F` syntax for the aws-profile completion below
autoload -Uz bashcompinit && bashcompinit

# AWS CLI's own zsh completer (sourced from brew prefix)
if (( $+commands[brew] )); then
  __aws_completer="$(brew --prefix)/bin/aws_zsh_completer.sh"
  [[ -f "$__aws_completer" ]] && source "$__aws_completer"
  unset __aws_completer
fi

aws-profile() {
  if [ $# -eq 0 ]; then
    echo "$AWS_PROFILE"
    return 0
  fi
  if [[ "$1" == "clear" ]]; then
    unset AWS_PROFILE
  else
    export AWS_PROFILE="$1"
  fi
}

_aws_profile() {
  local cur opts
  COMPREPLY=()
  cur="${COMP_WORDS[COMP_CWORD]}"
  # [^]]+ instead of \S+: \S is GNU-only and matches nothing on macOS BSD grep.
  # stderr silenced for machines with no ~/.aws/config.
  opts="$(grep -E -o "\[profile [^]]+\]" "$HOME/.aws/config" 2>/dev/null | cut -d" " -f2 | cut -d']' -f1 | tr "\n" " ") clear"
  COMPREPLY=($(compgen -W "${opts}" -- "${cur}"))
  return 0
}
complete -F _aws_profile aws-profile
