{ pkgs, inputs, ... }:

{
  systemd.services."oliviabot" = {
    # Start automatically on boot after we have network access
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    path = [ pkgs.openssh pkgs.git pkgs.nix ];
    preStart = ''
      cd /home/olivia/services
      if [ -d oliviabot ]; then
        cd oliviabot
        git pull --rebase
      else
        git clone git@github.com:RocketRace/oliviabot.git
      fi
    '';
    script = ''
      cd /home/olivia/services/oliviabot
      nix run
    '';
  };
}