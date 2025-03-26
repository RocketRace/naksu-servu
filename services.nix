{ pkgs, inputs, ... }:

let we-have-derivations-at-home = {
  name,
  git-url,
  script,
  base ? "/home/olivia/services",
  path ? [],
}: {
  name = name;
  service = {
    # Start automatically at the appropriate time
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    # Git is used to set up
    path = path ++ [ pkgs.git ];
    preStart = ''
      cd ${base}
      if [ -d ${name} ]; then
        cd ${name}
        git pull --rebase
      else
        git clone ${git-url}
      fi
    '';
    script = ''
      cd ${base}/${name}
      ${script}
    '';
  };

  # Remote update script
  updater = pkgs.writeShellScriptBin "update-${name}" ''
    cd ${base}/${name}
    sudo ${pkgs.git}/bin/git pull --rebase
    sudo systemctl restart ${name}
  '';
};

merge = sets: {
  systemd.services = builtins.listToAttrs (builtins.map (s: { name = s.name; value = s.service; }) sets);
  environment.systemPackages = builtins.map (s: s.updater) sets;
};

services = [
  {
    name = "oliviabot";
    git-url = "https://github.com/RocketRace/oliviabot.git";
    script = "nix run";
    path = [ pkgs.nix ];
    # Additional setup: scp oliviabot.db, config.py and discord.log into /home and move it to the appropriate folder 
  }
];

in (merge (builtins.map we-have-derivations-at-home services))