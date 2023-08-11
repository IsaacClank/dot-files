if status is-interactive; and test -d "$HOME/.dotnet"
  set -gx DOTNET_ROOT "$HOME/.dotnet"
  fish_add_path -gP "$DOTNET_ROOT"
  fish_add_path -gP "$DOTNET_ROOT/tools"
end
