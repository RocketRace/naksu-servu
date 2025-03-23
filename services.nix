{ pkgs, inputs, state-version, ... }:

let services = with builtins;
  map (filename: import (./services + "/${filename}") { inherit pkgs; })
    (filter (filename: ! isNull (match ".*\.nix" filename))
      (attrNames (readDir ./services)));

in {
  containers = builtins.listToAttrs
    (builtins.map ({name, config}: 
      {
        name = name;
        value = {
          autoStart = true;
          privateNetwork = true;
          config = config // {
            boot.isContainer = true;
            system.stateVersion = state-version;
          };
        }
      }
    ) services)
}