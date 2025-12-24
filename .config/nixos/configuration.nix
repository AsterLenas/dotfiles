# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      /etc/nixos/hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # prevent screen flicker on Tuxedo Infinitybook 14
  boot.kernelParams = [ "i915.enable_psr=0" "amdgpu" ];

  # activate SysRq
  boot.kernel.sysctl = {
    "kernel.sysrq" = 1;
    "vm.max_map_count" = 2147483642;
  };

  networking.hostName = "taihou"; # Define your hostname.
  networking.domain = "kai.ni"; # Define your domain
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;  # Easiest to use and most distros use this by default.

  # Bridge config
  # networking.interfaces = {
  #   enp0s20f0u4.useDHCP = true;
  #   br0.useDHCP = true;
  # };
  # networking.bridges = {
  #   "br0" = {
  #     interfaces = [ "enp0s20f0u4" ];
  #   };
  # };

  fileSystems = {
    "/".options = [ "defaults" "compress=zstd" ];
    "/home".options = [ "defaults" "compress=zstd" ];
  };

  swapDevices = [ {
    device = "/swapfile";
    size = 8*1024;
  } ];

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_AU.UTF-8";
  console = {
  #   font = "Lat2-Terminus16";
    keyMap = "de";
  #   useXkbConfig = true; # use xkbOptions in tty.
  };

  # Nix options
  nix.settings = {
    auto-optimise-store = true;
    experimental-features = [ "nix-command" "flakes" ];
  };

  nixpkgs.config = {
    packageOverrides = pkgs: {
      stable = import <stable> {
        config = config.nixpkgs.config;
      };
    };
    allowUnfreePredicate = pkg: builtins.elem (lib.getName pkg) [
      "steam"
      "steam-original"
      "steam-run"
      "steam-unwrapped"
    ];
  };

  # install steam
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true;
  };

  programs.gamemode.enable = true;

  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    windowManager.qtile = {
      enable = true;
      package = pkgs.stable.python3.pkgs.qtile;
    };
    desktopManager.xterm.enable = false;
    xkb.layout = "de"; # X11-keymap
    displayManager.startx.enable = true;
    videoDrivers = [ "amdgpu" ];
    deviceSection = ''Option "TearFree" "true"'';
    dpi = 100;
    excludePackages = [ pkgs.xterm ];
  };

  #services.libinput.enable = true; # touchpad

  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;

  # Enable scanning
  hardware.sane.enable = true;
  hardware.sane.extraBackends = [ pkgs.sane-airscan ];

  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      mesa
    ];
    # For 32 bit applications
    extraPackages32 = with pkgs; [
      pkgsi686Linux.mesa
    ];
  };

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  # Enable bluetooth
  # hardware.bluetooth.enable = true;

  # virtualisations
  virtualisation.libvirtd.enable = true;
  virtualisation.docker.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.cinque = {
    isNormalUser = true;
    extraGroups = [
      "wheel" # Enable ‘sudo’ for the user.
      "libvirtd" # Allow usage of libvirt without extra authentication.
      "docker"
      "scanner"
      "lp"
    ];
    shell = pkgs.zsh;
  #   packages = with pkgs; [
  #     brave
  #     thunderbird
  #   ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    bat
    beauty-line-icon-theme
    brave
    btop-rocm
    coreutils
    curl
    distrobox
    dust
    emacs
    eza
    fastfetch
    fd
    feh
    flameshot
    gcc
    git
    gnupg
    goverlay
    htop
    keepassxc
    kitty
    lxappearance
    lxsession
    mangohud
    networkmanagerapplet
    nix-zsh-completions
    numix-cursor-theme
    numix-gtk-theme
    numix-icon-theme
    pasystray
    pavucontrol
    pcmanfm
    picom
    procs
    remmina
    ripgrep
    rofi
    rsync
    seafile-client
    stable.rustdesk-flutter
    starship
    topgrade
    v4l-utils # Webcam controlls
    vesktop
    vim-full
    virt-manager
    vkbasalt
    vscodium
    wallust
    xclip
    xfce.ristretto
    yt-dlp
    zsh
    zsh-autosuggestions
    zsh-completions
    zsh-syntax-highlighting
  ];

  environment.sessionVariables = {
    AMD_VULKAN_ICD = "RADV";
    RADV_PERFTEST = "aco";
  };

  fonts = {
    fontconfig = {
      antialias = true;
      hinting.enable = true;
    };
    packages = with pkgs; [
      dejavu_fonts
      fira-code
      font-awesome
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      source-han-code-jp
      source-han-sans
    ];
  };

  programs.zsh = {
    enable = true;
    autosuggestions.enable = true;
    enableCompletion = true;
    syntaxHighlighting.enable = true;
  };

  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-gnome3;
  };
  
  # List of services that you want to enable:
  services.locate = {
    package = pkgs.mlocate;
    enable = true;
  };

  # services.blueman.enable = true;

  services.fstrim.enable = true;

  services.tumbler.enable = true;

  services.gvfs.enable = true;

  # Enable the OpenSSH daemon.
  services.openssh.enable = false;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

}
