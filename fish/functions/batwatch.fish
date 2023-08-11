function batwatch --description 'alias batwatch tail -f $FILE | bat --paging=never -l log'
  tail -f $argv[1] | bat --paging=never -l log
end
