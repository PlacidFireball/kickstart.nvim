{ config, lib, pkgs, ... }:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-24.05.tar.gz";
in
{
  imports = [ 
    <nixpkgs/nixos/modules/installer/virtualbox-demo.nix>
    (import "${home-manager}/nixos")
  ];

  nixpkgs.config.allowUnfree = true;

  # Let demo build as a trusted user.
# nix.settings.trusted-users = [ "demo" ];

# Mount a VirtualBox shared folder.
# This is configurable in the VirtualBox menu at
# Machine / Settings / Shared Folders.
# fileSystems."/mnt" = {
#   fsType = "vboxsf";
#   device = "nameofdevicetomount";
#   options = [ "rw" ];
# };

# By default, the NixOS VirtualBox demo image includes SDDM and Plasma.
# If you prefer another desktop manager or display manager, you may want
# to disable the default.
# services.xserver.desktopManager.plasma5.enable = lib.mkForce false;
# services.displayManager.sddm.enable = lib.mkForce false;

# Enable GDM/GNOME by uncommenting above two lines and two lines below.
# services.xserver.displayManager.gdm.enable = true;
# services.xserver.desktopManager.gnome.enable = true;

# Set your time zone.
  time.timeZone = "America/Denver";

  home-manager.users.demo = {
    home.stateVersion = "24.05";

    programs.git = {
      enable = true;
      userName = "PlacidFireball";
      userEmail = "jared.lee.weiss@gmail.com";
    };

    home.packages = with pkgs; [
      wezterm
      discord
      protonvpn-gui
      protonvpn-cli
      qbittorrent
    ];
  };
  
  # networking configuration
  networking.hostName = "jwPersonalNix";
  networking.networkmanager.enable = true;
  #networking.wireless.enable = true;

  #networking.wireless.networks = {
  #  JnE103 = {
  #    psk = "J+E2024@2078";
  #  };
  #  "JnE103-5G" = {
  #    psk = "J+E2024@2078";
  #  };
  #};
  
  # enable OpenSSH daemon
  services.openssh.enable = true;

  fonts.packages = with pkgs; [
    nerdfonts
  ];

  programs.zsh.ohMyZsh = {
    enable = true;
    plugins = [ "git" "python" "man" ];
    theme = "agnoster";
  };

  nixpkgs.config.allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
    "1password-gui"
    "1password"
  ];

  programs._1password.enable = true;
  programs._1password-gui = {
    enable = true;
    # polkitPolicyOwners = [ "yourUsernameHere" ];
  };

  programs.steam.enable = true;

# List packages installed in system profile. To search, run:
# \$ nix search wget
 environment.systemPackages = with pkgs; [
   wget 
   vim
   git
   neovim
   ripgrep
   gnumake
   unzip
   nodejs_22
   python3
   rustc
   rustup
   rustfmt
   cargo
   gcc14
   neofetch
   steam
];


}
