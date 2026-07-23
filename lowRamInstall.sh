# To install in low ram environments we first juts use Disko for partitioning
# Then we create a swap file to expand the nix store in the memory
# Finally we do the installation

# Use Disko for partioning
nix --experimental-features "nix-command flakes" run github:nix-community/disko -- --mode disko disko.nix

# Use the zfs tmp dataset as /tmp
mount --bind /mnt/tmp /tmp

# Create swap file on /mnt/tmp - we will empty /tmp anyway on reboot...

# Unfortunately it doesn't work with a simple file being used as swap on zfs
#dd if=/dev/zero of=/tmp/swapfile bs=1M count=8192
#chmod 600 /tmp/swapfile
#mkswap /tmp/swapfile
#swapon /tmp/swapfile

# However we can use losetup to "make" it into a block device and then use it as swap... not safe for production but should work for initial setup
dd if=/dev/zero of=/tmp/swapfile bs=1M count=8192
losetup -f /tmp/swapfile
mkswap /tmp/loop1 # The squashfs on the iso is loop0
swapon /tmp/swapfile

# Expand the overlay nix store; 4GB should be enough, rest can be used as system memory
mount -o remount,size=4G /nix/.rw-store

# Install Nixos
nixos-install --flake .#nixos
