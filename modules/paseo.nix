{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:

{
  imports = [
    inputs.paseo.nixosModules.paseo
  ];

  services.paseo = {
    enable = true;
    user = "meghdip";
    listenAddress = "0.0.0.0";
    hostnames = [ ".ts.net" ];
    dataDir = "/home/mkarmakar/.paseo";
    inheritUserEnvironment = true;

    settings = {
      features = {
        webUi = {
          enabled = true;
        };
      };
      log = {
        console = {
          level = "info";
          format = "pretty";
        };
        file = {
          level = "trace";
          path = "/home/mkarmakar/.paseo/daemon.log";
          rotate = {
            maxSize = "10m";
            maxFiles = 2;
          };
        };
      };
    };

    environment = {
      PASEO_PASSWORD = "ilmiieya";
    };
  };
}
