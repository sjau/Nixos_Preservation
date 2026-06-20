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
