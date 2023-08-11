function suse --wraps='sudo yast2' --description 'alias suse sudo yast2'
  sudo yast2 $argv; 
end
