function ls --wraps=exa --wraps='exa --group-directories-first' --description 'alias ls exa --group-directories-first'
  exa --group-directories-first $argv
end
