{
	fileSystems."/nix".neededForBoot = true;
	fileSystems."/data".neededForBoot = true; # sometimes needed too

	disko.devices.nodev = {
		"/" = {
			fsType = "tmpfs";
			mountOptions = [
				"size=25%"
				"mode=755"
			];
		};
	};

	disko.devices = {
		disk.main = {
			device = "/dev/sda"; # MAKE SURE TOO SELECT CORRECT DISK HERE
			type = "disk";
			content = {
				type = "gpt";
				partitions = {
					boot = {
						name = "BOOT";
						size = "1M";
						type = "EF02";
					};
					esp = {
						name = "ESP";
						size = "1G";
						type = "EF00";
						content = {
							type = "filesystem";
							format = "vfat";
							mountpoint = "/boot";
							mountOptions = [ "nofail" ];
						};
					};
					swap = {
						name = "SWAP";
						size = "4G";
						content = {
							type = "swap";
							resumeDevice = true;
						};
					};
					zfs = {
						size = "100%";
						content = {
							type = "zfs";
							pool = "tankTest";
						};
					};
				};
			};
		};
		zpool = {
			tankTest = {
				type = "zpool";
				rootFsOptions = {
					mountpoint = "none";
					compression = "zstd-3";
					acltype = "posixacl";
					xattr = "sa";
					normalization = "formD";
					atime = "off";
					relatime = "on";
				};
				options.ashift = "12";
				datasets = {
					"Nixos" = {
						type = "zfs_fs";
						options = {
						};
					};
					"Nixos/encZFS" = {
						type = "zfs_fs";
						options = {
							encryption = "aes-256-gcm";
							keyformat = "passphrase";
							#keylocation = "file:///tmp/secret.key";
							keylocation = "prompt";
						};
					};
					"Nixos/encZFS/data" = {
						type = "zfs_fs";
						options = {
							mountpoint = "/data";
							"easysnap:hourly" = "720";
							"easysnap:daily" = "365";
						};
						mountpoint = "/data";
					};
					"Nixos/encZFS/v" = {
						type = "zfs_fs";
						options = {
						};
					};
					"Nixos/encZFS/v/containers" = {
						type = "zfs_fs";
						options = {
							mountpoint = "/var/lib/containers";
							"easysnap:hourly" = "336";
							"easysnap:daily" = "90";
						};
						mountpoint = "/var/lib/containers";
					};
					"Nixos/encZFS/v/nix" = {
						type = "zfs_fs";
						options = {
							mountpoint = "/nix";
							"easysnap:hourly" = "336";
							"easysnap:daily" = "90";
						};
						mountpoint = "/nix";
					};
					# README MORE: https://wiki.archlinux.org/title/ZFS#Swap_volume
					"Nixos/encZFS/v/swap" = {
						type = "zfs_volume";
						size = "10M";
						content = {
							type = "swap";
						};
						options = {
							volblocksize = "4096";
							compression = "zle";
							logbias = "throughput";
							sync = "always";
							primarycache = "metadata";
							secondarycache = "none";
						};
					};
				};
			};
		};
	};
}
