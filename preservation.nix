{
  boot.tmp.cleanOnBoot = true;

  preservation = {
    enable = true;

    preserveAt."/data" = {
      directories = [
        "/etc/nixos"
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
