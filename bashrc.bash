[[ $- != *i* ]] && return

## Utilities

### Terminal utilities
function _term_to_color() {
  local COLOR_BLACK='\e[1;30m'
  local COLOR_RED='\e[0;31m'
  local COLOR_GREEN='\e[0;32m'
  local COLOR_YELLOW='\e[0;33m'
  local COLOR_BLUE='\e[0;34m'
  local COLOR_PURPLE='\e[0;35m'
  local COLOR_CYAN='\e[0;36m'
  local COLOR_WHITE='\e[0;37m'
  local COLOR_RESET='\e[0m'

  local str="$1"
  local color=""

  case "$2" in
    'black')
      color="$COLOR_BLACK"
      ;;
    'red')
      color="$COLOR_RED"
      ;;
    'green')
      color="$COLOR_GREEN"
      ;;
    'yellow')
      color="$COLOR_YELLOW"
      ;;
    'blue')
      color="$COLOR_BLUE"
      ;;
    'purple')
      color="$COLOR_PURPLE"
      ;;
    'cyan')
      color="$COLOR_CYAN"
      ;;
    '*')
      color="$COLOR_WHITE"
      ;;
  esac

  printf "$color%s$COLOR_RESET" "$str"
}

### Git utilities
function _git_working_tree_is_clean() {
  if ! git status &>/dev/null; then
    return 2
  fi

  if [[ $(git status 2> /dev/null | tail -n1) = *"nothing to commit"* ]]; then
    return 0
  else
    return 1
  fi
}

### String utilities

function _str_append() {
  printf "$1%s" "$2"
}

### Other utilities

function _append_path() {
  local new_path && new_path="$(_str_append "$PATH" ":$1")"
  export PATH="$new_path"
}

## Configure prompt

function _git_prompt() {
  if ! git symbolic-ref -q HEAD &>/dev/null; then
    return 1
  fi

  branch_name=$(git symbolic-ref -q HEAD)
  branch_name="${branch_name##refs/heads/}"
  branch_name="${branch_name:-HEAD}"

  if _git_working_tree_is_clean; then
    _term_to_color "$branch_name" 'black'
  else
    printf "%s %s" \
      "$(_term_to_color "$branch_name" 'black')" \
      "$(_term_to_color "*" 'yellow')"
  fi

  printf " "
}

function prompt() {
  PS1="$(_term_to_color '\w' 'cyan') $(_git_prompt)\n$(_term_to_color '> ' 'black')"
}

PROMPT_COMMAND=prompt

## Configure history and enable hstr

export HISTCONTROL=ignorespace   # leading space hides commands from history
export HISTFILESIZE=10000        # increase history file size (default is 500)
export HISTSIZE=${HISTFILESIZE}  # increase history size (default is 500)
export HSTR_CONFIG=hicolor       # get more colors
export HSTR_TIOCSTI=n
export PROMPT_COMMAND="history -a; history -n; ${PROMPT_COMMAND}" # ensure synchronization between bash memory and history file

alias hh=hstr                    # hh to be alias for hstr
shopt -s histappend              # append new history items to .bash_history

function hstrnotiocsti {
  { READLINE_LINE="$( { </dev/tty hstr "${READLINE_LINE}"; } 2>&1 1>&3 3>&- )"; } 3>&1;
    READLINE_POINT=${#READLINE_LINE}
  }

  if [[ $- =~ .*i.* ]]; then bind -x '"\C-r": "hstrnotiocsti"'; fi # if this is interactive shell, then bind hstr to Ctrl-r (for Vi mode check doc)

## Enable zoxide

eval "$(zoxide init bash)"

## Enable nvm

function _nvm_load() {
  unset -f nvm node npm nvim
  export NVM_DIR="$HOME/Projects/nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"
}

function nvm() {
  _nvm_load
  nvm "$@"
}

function node() {
  _nvm_load
  node "$@"
}

function npm() {
  _nvm_load
  npm "$@"
}

function nvim() {
  _nvm_load
  nvim "$@"
}

## Enable bash-completion

[[ -r /usr/share/bash-completion/bash_completion ]] \
  && . /usr/share/bash-completion/bash_completion

## Enable .net

export DOTNET_ROOT="$HOME/.dotnet"
_append_path "$DOTNET_ROOT"
_append_path "$DOTNET_ROOT/tools"

## Config

PROMPT_DIRTRIM=2 # Trim long paths in the prompt

shopt -s checkwinsize # Update window size on every command
shopt -s globstar 2>/dev/null # Enable ** globbing
shopt -s nocaseglob # Case-insensitive globbing

bind "Space:magic-space" # Expand the !! into the actual command with <space>
bind "TAB: menu-complete" # Enable cycling through completion options using <TAB>
bind "set colored-completion-prefix on" # Highlight the common prefix on completion options
bind "set colored-stats on" # Display completion options in different colors based on file types.
bind "set completion-ignore-case on" # Perform file completion in a case insensitive fashion
bind "set completion-map-case on" # Treat hyphens and underscores as equivalent
bind "set mark-symlinked-directories on" # Immediately add a trailing slash when autocompleting symlinks to directories
bind "set menu-complete-display-prefix on" # First completion trigger only display options, instead of immediately choosing the first option
bind "set show-all-if-ambiguous on" # Display matches for ambiguous patterns at first tab press

alias ls='ls --color=auto --group-directories-first'

function batdiff() {
  local path && path="${1:-"./"}"
  git diff --name-only --relative --diff-filter=d "$path" | xargs bat --diff
}

_append_path "$HOME/.local/bin"
