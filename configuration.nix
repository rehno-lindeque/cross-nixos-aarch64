{ config, pkgs, lib, ... }:
{
  security.polkit.enable = false; # required by xserver
  services.udisks2.enable = false;

  programs.command-not-found.enable = false;

  system.boot.loader.kernelFile = lib.mkForce "Image";

  # installation-device.nix forces this on. But it currently won't
  # cross build due to w3m
  services.nixosManual.enable = lib.mkOverride 0 false;

  # installation-device.nix turns this off.
  systemd.services.sshd.wantedBy = lib.mkOverride 0 ["multi-user.target"];

  nixpkgs.crossSystem = lib.systems.examples.aarch64-multiplatform;

  nix.checkConfig = false;
  networking.wireless.enable = lib.mkForce false;

  imports = [./sd-image-aarch64.nix];

  system.stateVersion = "18.03";

  # extras
  sdImage.bootSize = 480;
  services.openssh = {
    enable = true;
    permitRootLogin = lib.mkForce "yes";
    extraConfig = ''
      MaxAuthTries 20
    '';
  };
  boot.loader.generic-extlinux-compatible.configurationLimit = 5;

  documentation.man.enable = false;
  # services.nixosManual.enable = false;

  hardware.enableRedistributableFirmware = true;
  hardware.firmware = [
    (pkgs.stdenv.mkDerivation {
       name = "broadcom-rpi3-extra";
       src = pkgs.fetchurl {
         url = "https://raw.githubusercontent.com/RPi-Distro/firmware-nonfree/54bab3d/brcm80211/brcm/brcmfmac43430-sdio.txt";
         sha256 = "19bmdd7w0xzybfassn7x4rb30l70vynnw3c80nlapna2k57xwbw7";
       };
       phases = [ "installPhase" ];
       installPhase = ''
         mkdir -p $out/lib/firmware/brcm
         cp $src $out/lib/firmware/brcm/brcmfmac43430-sdio.txt
         '';
     })
  ];

  environment.systemPackages =
    with pkgs;
    [
      wget
      # xorg.xorgserver.out
      # xorg.xrandr
      # xorg.xrdb
      # xorg.setxkbmap
      # xorg.xlsclients
      # xorg.xset
      # xorg.xsetroot
      # xorg.xinput
      # xorg.xprop
      # xorg.xauth
      # xterm
      # xdg_utils
      # xorg.xf86inputevdev.out
    ];

  # services.xserver = {
  #   enable = true;
  #   videoDrivers = [ "modesetting" ];
  #   layout = "us";
  #   desktopManager.default = "none";
  #   desktopManager.session = 
  #       [ { name = "xterm";
  #           bgSupport = false;
  #           start = ''
  #             ${pkgs.xterm}/bin/xterm -ls &
  #             waitPID=$!
  #           '';
  #         }
  #       ];
  #   displayManager = {
  #     # sessionCommands = ''
  #     #   xmessage "Hello World!" &
  #     # '';
  #     # session =
  #     #   [ { manage = "desktop";
  #     #       name = "xterm";
  #     #       # bgSupport = false;
  #     #       start = ''
  #     #         ${pkgs.xterm}/bin/xterm -ls &
  #     #         waitPID=$!
  #     #       '';
  #     #     }
  #     #   ];
  #   };

  #   # displayManager = {
  #   #   lightdm = {
  #   #     enable = true;
  #   #     greeter.enable = false;
  #   #     autoLogin = {
  #   #       enable = true;
  #   #       user = "guest";
  #   #     };
  #   #   };
  #   # };
  #   # x11vnc = {
  #   #   enable = true;
  #   #   user = "guest";
  #   #   extraArguments = ''-auth /home/guest/.Xauthority -rfbport 5900 -forever -bg -shared -noxdamage -solid -wait 50'';
  #   # };
  # };

  # Add key for easy ssh
  users.extraUsers.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBa8dvNG2B4CKdcNxbpRhc9SrkI6zhUBqxIk3i/wP9aq NixOps client key"
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC4l3exfk44/NHAO2vDgtKuF9eDiSoWR+VOWhB6ZbLtR72MX05TTirQT11cXCEBdVl6/hS1Xca0DTuk9Zth/yfTvCiyWr9s+5MvHZp0pptqfz/Hzb3lnl/HA8ctfo3uZ6aiL8oL0xo8kHo79g8Z5nIhFGh/XEUpj7ARG/VSRBNVtlPSpHoBFoyDsPs58BhKyIRWR+A6SGbSGOuaxj6ynlcyv7FUG9Gq9HLVK32yUafBrthUVpX2BSUNoh2cDZlxbn0k2NKdfc2APYHa+V289OHKdfoMjA3xCacbpAMudv09NWT/X7RoRZ8yHuMJTqUi7OFTddY3XPKyRFm7GE9Pt35+pvuJfGKpP5GYXVhAUuohxMO0xD3gNdnGzzcMJGRtH14kFGE5rhQHkIiWQeEae9p81u5d3wn7CvGrjOPSJPeBq+CmdmyRGerIVG2QbYkTXvz5Bp7fRH/KTrjIrZAMCgqcZhezaDjke4s4AFEnm017U1FBolAEyiN5BrHX/cfI1RLWUW7hX5QZi4zDuZoCe8D4aMQv65Bie5Ymz/MVN/97CKvO2P3L1cCC9313BkeDAgSy3N2jwZO5Bo9symApOY+P0XvoKAMKooQjYP0mKYequsmys5Qrkgm4xffBmy/PmVQlJYiBU6EjrI+8ElVz89UvSD/kPvLnYEf70OOYs3X+3w== remote-build-for-access-point"
  ];

  # Define a guest user account. Remember to set a password with ‘passwd’.
  users.users.guest = {
    isNormalUser = true;
    uid = 1000;
    packages = with pkgs; [
      # google-chrome
      # firefox
    ];
  };
}
