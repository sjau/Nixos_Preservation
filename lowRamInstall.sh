# To install in low ram environments we first juts use Disko for partitioning
# Then we activated the zfs swap
# We set the nix store to the zfs nix dataset
# Finally we do the installation

# Use Disko for partioning
nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko disko.nix

# Activate swap
swapon -a /dev/zvol/tankTest/Nixos/encZFS/v/swap

# Set /nix/store
export NIX_STORE_DIR=/mnt/nix/store

# Install Nixos
nixos-install --flake .#nixos
