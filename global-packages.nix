{ pkgs, ... }:
with pkgs; [
  vim git wget curl htop btop bat
  ripgrep fd bat interception-tools
  interception-tools-plugins.caps2esc
  fselect uutils-coreutils-noprefix mprocs
]
