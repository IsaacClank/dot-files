function suse-packages --wraps='sudo yast2 sw_single' --description 'alias suse-packages sudo yast2 sw_single'
  sudo yast2 sw_single $argv; 
end
