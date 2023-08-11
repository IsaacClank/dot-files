if not status is-interactive; or not type -q bat
  exit 0
end

function fzf --description 'alias fzf fzf --preview "bat --color=always --style=numbers --line-range=:500 {}"'
  command fzf --preview "bat --color=always --style=numbers --line-range=:500 {}" $argv
end
