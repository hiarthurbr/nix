{ pkgs, ... }:
with pkgs; [
  git wget curl dig
  ripgrep fd bat interception-tools
  interception-tools-plugins.caps2esc
  fselect uutils-coreutils-noprefix
]
