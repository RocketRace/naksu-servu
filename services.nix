{ pkgs, inputs, ... }:

{
  systemd.services."oliviabot" = {
    # Test service
    script = "${inputs.oliviabot}/bin/prod";
    # Start automatically on boot after we have network access
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
  };
}