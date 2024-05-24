
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.efi.efiSysMountPoint = "/boot/efi";

  networking.hostName = "saturn"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Declare Wireless Networks
  networking.wireless.networks = {
    skynet = {
      psk = "RanchO91730";
    };
  };

  # Set your time zone.
  time.timeZone = "America/New_York";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.utf8";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  #services.xserver.displayManager.gdm.enable = true;
  #services.xserver.desktopManager.gnome.enable = true;

  # Enable the KDE Plasma Desktop Environment.
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Enable CUPS to print documents.
  #services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;


    # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.roger = {
    isNormalUser = true;
    description = "Roger";
    home = "/home/roger";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      firefox
      bitwarden
      element-desktop
      pridefetch
      inetutils
      git
    ];
    openssh = {
    	authorizedKeys.keys = [
    		"ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGPq2Oypb23EzXBJwiFC+BzaOFQiBjKFc2SZIyPCF7Xv oscar0228@gmail.com"
    	]
    };
  };
  
  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    micro # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    nix
    tmux
    dnsmasq
    parted
    home-manager
  ];

# 
  networking.useDHCP = false;
  networking.interfaces.wlo1 = {
  	useDHCP = false;
  	ipv4.addresses = [
  		{ address = "10.10.99.9"; prefixLength = 24;}
  	];
  };
  networking.defaultGateway = { address = "10.10.99.1"; interface = "wlo1"; };
  networking.nameservers = ["127.0.0.1" "8.8.8.8" ];
  
  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
   programs.mtr.enable = true;
   programs.gnupg.agent = {
     enable = true;
     enableSSHSupport = true;
   };

  # List services that you want to enable:

  # Enable AutoUpgrades
  system.autoUpgrade.enable = true;
  system.autoUpgrade.allowReboot = true;
  system.autoUpgrade.channel = https://nixos.org/channels/nixos-23.05;

# Enable the OpenSSH daemon.
   services.openssh.enable = true;
   
# Enable Flatpak
   services.flatpak.enable = true;
# Enable dnsmasq
   services.dnsmasq.enable = true;
   services.dnsmasq.alwaysKeepRunning = true;
#   services.dnsmasq.settings.server = ["xxx.xxx.xxx.xxx" "ip.addr"];
   services.dnsmasq.settings = { cache-size = 500; };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?

  nix = {
  	settings = {
  		experimental-features = "nix-command flakes";
  	};
  };
}
