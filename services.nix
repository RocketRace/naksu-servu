{ pkgs, inputs, ... }:

{
  systemd.services."oliviabot" = {
    # Start automatically on boot after we have network access
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    path = [ pkgs.git pkgs.nix ];
    # Additional setup: scp oliviabot.db, config.py and discord.log into /home and move it to the appropriate folder 
    preStart = ''
      cd /home/olivia/services
      if [ -d oliviabot ]; then
        cd oliviabot
        git pull --rebase
      else
        git clone https://github.com/RocketRace/oliviabot.git
      fi
    '';
    script = ''
      cd /home/olivia/services/oliviabot
      nix run
    '';
  };

  # Remote update script
  environment.systemPackages = with pkgs; [
    (pkgs.writeShellScriptBin "update-oliviabot" ''
      cd /home/olivia/services
      ${git}/bin/git pull --rebase
      sudo systemctl restart oliviabot
    '')
  ];
}