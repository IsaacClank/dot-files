if status is-interactive; and test -d "$HOME/isaac/.local/fnm"
  set FNM_PATH "$HOME/.local/share/fnm"
  set PATH "$FNM_PATH" $PATH
  fnm env | source
end

