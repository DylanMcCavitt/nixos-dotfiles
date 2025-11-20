{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [inputs.sops-nix.nixosModules.sops];

  sops = {
    defaultSopsFile = ../../secrets.yaml;
    defaultSopsFormat = "yaml";

    age.keyFile = "/home/dylan/.config/sops/age/keys.txt";

    secrets = {
      hello = {};
      user_password = {
        neededForUsers = true;
      };
    };
  };
}
