function sys --wraps=systemctl --description 'alias sys systemctl'
  systemctl $argv
end
