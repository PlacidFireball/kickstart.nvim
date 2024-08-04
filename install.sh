
echo "loading .tmux.conf"
cp .tmux.conf ~/
if [[ -n "$LINUX_DISTRO" && "$LINUX_DISTRO" == "nixos" ]]; then
  echo "loading configuration.nix"
  sudo cp configuration.nix /etc/nixos/configuration.nix
  sudo nixos-rebuild switch
fi
echo "loading .wezterm.lua"
cp .wezterm.lua ~/
