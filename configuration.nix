{ config, pkgs, lib, ... }:

{
    imports = [
        ./hardware-configuration.nix
    ];

    # Kernel Parameters
    # boot.kernelParams = [ "ip=10.0.0.250::10.10.10.1:255.255.255.0:freshi:any:off" ];

    # Uefi Boot
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Add more filesystems
    boot.supportedFilesystems = [ "zfs" ];
    boot.zfs.forceImportRoot = true;
    boot.zfs.package = pkgs.zfs_unstable;
    boot.zfs.devNodes = "/dev";
    services.zfs.autoScrub = {
        enable = true;
        interval = "monthly";
        pools = [ ]; # List of ZFS pools to periodically scrub. If empty, all pools will be scrubbed.
    };

    # Trust hydra. Needed for one-click installations.
    nix.settings.trusted-substituters = [ "http://hydra.nixos.org" ];
    nix.settings.download-buffer-size = 524288000;

    # Setup networking
    networking = {
        hostName = "freshNixos"; # Define your hostname.
        hostId = "00000000";
    };

    # Select internationalisation properties.
    console.font = "Lat2-Terminus16";
    console.keyMap ="sg-latin1";
    i18n = {
        defaultLocale = "en_US.UTF-8";
        supportedLocales = [ "all" ];
    };

    # Enable the OpenSSH daemon.
    services.openssh = {
        enable = true;
        hostKeys = [
            {   path = "/data/ssh/ssh_host_ed25519_key";
                type = "ed25519"; }
        ];
        settings = {
            PermitRootLogin = "yes";
        };
        ports = [ 22 ];
    };

    # Enable ntp or rather timesyncd
    services.timesyncd = {
        enable = true;
        servers = [ "0.ch.pool.ntp.org" "1.ch.pool.ntp.org" "2.ch.pool.ntp.org" "3.ch.pool.ntp.org" ];
    };

    # Time.
    time.timeZone = "Europe/Zurich";

    # Enable sudo
    security.sudo = {
        enable = true;
        wheelNeedsPassword = true;
    };

    # Define a user account. Don't forget to set a password with ‘passwd’.
    users.defaultUserShell = "/var/run/current-system/sw/bin/bash";
    users.users = {
        root = {
            initialHashedPassword = null;
            hashedPassword = "$6$phaepoh9mohMoeyi$vrZCrxM5ePyinO8yz0.cvRu9rnXBQwH9fx1yHtYyYcrxK5sDjR5X8SESBLbLtbvZjCQd//8MYMc2qck0MW.yk1";
        };
        hyper = {
            isNormalUser = true;    # creates home, adds to group users, sets default shell
            createHome = false;
            home = "/home/hyper";
            description = "hyper";
            extraGroups = [ "networkmanager" "vboxusers" "wheel" "audio" "cdrom" "kvm" ]; # wheel is for the sudo group
            uid = 1000;
            hashedPassword = "$6$j/S4ArYO$jQUCFWSNwVB42TOIam5TJcU4KOebumNCdMj3QRNblbhoQnPoAOdSc/xHfpZx5P4AlIqTtVZlKfbfScZCCUga00";
        };
    };

    # Setup nano
    programs.nano.nanorc = ''
        set nowrap
        set tabstospaces
        set tabsize 4
        set constantshow
        # include /usr/share/nano/sh.nanorc
    '';

    # The NixOS release to be compatible with for stateful data such as databases.
    system.stateVersion = "26.05";

    nixpkgs.config.allowUnfree = true;
    nix.settings.experimental-features = [ "nix-command" "flakes" ]; # Activate feature for using flakes

    # List packages installed in system profile.
    environment.systemPackages = with pkgs; [
        curl
        git
        htop
        nano
        mc
        tmux
    ];

}
