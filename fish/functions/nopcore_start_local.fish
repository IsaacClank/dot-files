function nopcore_start_local
  set ROOT "$argv[1]"; and test -z $ROOT; and set ROOT "$HOME/.local/src/nop-core" 

  set DRIP_ROOT "$ROOT/repos/Drip/wintermute-api"
  set FLD_ROOT "$ROOT/repos/FlexDanmark"
  set session "nopcore"

  tmux new-session -d -s $session
  tmux rename-window -t $session:0 "stack"

  tmux split-window -t $session:0
  tmux split-window -t $session:0
  tmux split-window -t $session:0
  tmux split-window -h -t $session:0.3
  tmux split-window -h -t $session:0.2
  tmux split-window -h -t $session:0.1
  tmux split-window -h -t $session:0.1
  tmux split-window -h -t $session:0.1
  tmux split-window -h -t $session:0.1

  tmux send-keys -t $session:0.0 "z $DRIP_ROOT/api/drive-orders && skaffold dev" C-m
  tmux send-keys -t $session:0.1 "z $DRIP_ROOT/api/transporters && skaffold dev" C-m
  tmux send-keys -t $session:0.2 "z $DRIP_ROOT/api/geo && skaffold dev" C-m
  tmux send-keys -t $session:0.3 "z $DRIP_ROOT/api/people && skaffold dev" C-m
  tmux send-keys -t $session:0.4 "z $DRIP_ROOT/api/errands-reports && skaffold dev" C-m
  tmux send-keys -t $session:0.5 "z $DRIP_ROOT/api/suti && skaffold dev" C-m
  tmux send-keys -t $session:0.7 "z $DRIP_ROOT/api/roadnet && skaffold dev" C-m
  tmux send-keys -t $session:0.6 "z $DRIP_ROOT/scheduling && skaffold dev" C-m
  tmux send-keys -t $session:0.8 "z $FLD_ROOT/Api/External && dotnet run" C-m
  tmux send-keys -t $session:0.9 "z $FLD_ROOT/Api/UI && dotnet run" C-m

  tmux new-window -t $session:1 -n 'k9s' 'k9s'

  tmux select-layout -t $session:0 main-horizontal
end
