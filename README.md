```
lsblk
NAME  MAJ:MIN RM  SIZE RO TYPE MOUNTPOINTS
loop0   7:0    0  1.3G  1 loop /nix/.ro-store
sr0    11:0    1  1.3G  0 rom  /iso
vda   253:0    0  100G  0 disk
```

```
nix --extra-experimental-features "nix-command flakes" run 'github:nix-community/disko/latest#disko-install' -- --flake .#nixos --disk main /dev/vda
warning: unknown setting 'no-write-lock-file'
Failed to build NixOS configuration
```

```
ls
configuration.nix  disko.nix  flake.lock  flake.nix  hardware-configuration.nix  preservation.nix
```

```
nix --extra-experimental-features "nix-command flakes" run nixpkgs#disko-install -- --flake .#nixos --disk main /dev/vda
error: flake 'flake:nixpkgs' does not provide attribute 'apps.x86_64-linux.disko-install', 'packages.x86_64-linux.disko-install', 'legacyPackages.x86_64-linux.disko-install' or 'disko-install'
```
