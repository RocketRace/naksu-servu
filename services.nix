{ pkgs, inputs, ... }:

{
  systemd.services."oliviabot" = {
    # Test service
    script = "echo ${inputs.oliviabot}";
    # Start automatically on boot after we have network access
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
  };
}