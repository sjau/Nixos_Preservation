# To install in low ram environments we first juts use Disko for partitioning
# Then we create a swap file to expand the nix store in the memory
# Finally we do the installation

# Use Disko for partioning
nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko disko.nix

# Use the zfs tmp dataset as /tmp
mount --bind /mnt/tmp /tmp

# Create swap file on /mnt/tmp - we will empty /tmp anyway on reboot...
dd if=/dev/zero of=/mnt/tmp/swapfile bs=1M count=8192
chmod 600 /mnt/tmp/swapfile
mkswap /mnt/tmp/swapfile
swapon /mnt/tmp/swapfile

# Expand the overlay nix store
mount -o remount,size=8G /nix/.rw-store

# Install Nixos
nixos-install --flake .#nixos
