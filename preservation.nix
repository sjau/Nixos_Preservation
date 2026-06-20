{
  boot.tmp.cleanOnBoot = true;

  preservation = {
    enable = true;

    preserveAt."/persistent" = {
      directories = [
        "/etc/nixos"
        "/tmp"
        "/var/lib/bluetooth"
        {
          directory = "/var/lib/nixos";
          inInitrd = true;
        }
      ];

      files = [
        {
          file = "/etc/machine-id";
          inInitrd = true;
        }
      ];

      # Preserve user files
      # users.hyper = {
      #   directories = [
      #     ".ssh"
      #     ".mozilla"
      #   ];
      #
      #   files = [
      #
      #   ];
      # };
    };
  };
}
