{ pkgs, inputs, ... }:

{
  systemd.services."oliviabot" = {
    # Start automatically on boot after we have network access
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    preStart = ''
      cd /home/olivia/services
      if [ -d oliviabot ]; then
        cd oliviabot
        ${pkgs.git}/bin/git pull --rebase
      else
        ${pkgs.git}/bin/git clone https://github.com/RocketRace/oliviabot.git
      fi
    '';
    script = ''
      cd /home/olivia/services/oliviabot
      nix run
    '';
  };
}