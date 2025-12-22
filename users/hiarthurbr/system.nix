{ pkgs, ... }: {
  isNormalUser = true;
  shell = pkgs.nushell;
  description = "Arthur Bufalo Rodrigues";
  extraGroups = [ "networkmanager" "wheel" "input" ];
}
