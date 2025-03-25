{ pkgs, inputs, ... }:

{
  systemd.services."oliviabot" = {
    # Test service
    path = [ pkgs.coreutils ];
    script = "${pkgs.coreutils}/bin/echo hi!";
    # Start automatically on boot after we have network access
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
  };
}