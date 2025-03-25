{ pkgs, inputs, ... }:

{
  system.packages = [];

  systemd.services."oliviabot" = {
    path = [ pkgs.coreutils ];
    script = "${pkgs.coreutils}/bin/echo hi!";
  };
}