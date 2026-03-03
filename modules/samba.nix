{ config, pkgs, ... }:

{
  # Enable Samba for Windows network file sharing (SMB/CIFS)
  services.samba = {
    enable = true;
    # Open firewall ports 137,138 (UDP) and 139,445 (TCP) automatically
    openFirewall = true;

    settings = {
      global = {
        # Workgroup must match what Windows uses (default is WORKGROUP)
        workgroup = "WORKGROUP";
        "server string" = "nixos";
        "netbios name" = "nixos";
        security = "user";

        # Restrict access to local network only
        "hosts allow" = "192.168. 127.0.0.1 localhost";
        "hosts deny" = "0.0.0.0/0";
      };

      # Share the home directory of meghdip
      homes = {
        browseable = false;
        "read only" = false;
        "guest ok" = false;
        "create mask" = "0644";
        "directory mask" = "0755";
        "valid users" = "%S";
        comment = "Home directory";
      };
    };
  };

  # wsdd makes the machine show up in Windows "Network" explorer without
  # needing to type the hostname manually
  services.samba-wsdd = {
    enable = true;
    openFirewall = true;
  };

  # mDNS: advertise this machine as nixos.local on the local network.
  # Windows 10/11 resolves .local hostnames natively, so you can
  # ssh meghdip@nixos.local from your laptop without knowing the IP.
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
    publish = {
      enable = true;
      addresses = true;
      workstation = true;
    };
  };
}
