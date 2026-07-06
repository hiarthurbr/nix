{ pkgs, unstable, ... }:
with pkgs; [
  git
  wget
  curl
  dig
  ripgrep
  fd
  bat
  interception-tools
  interception-tools-plugins.caps2esc
  fselect
  fuzzel
  uutils-coreutils-noprefix
  (unstable.lutris.override {
    extraPkgs = pkgs: [
#               ----
#      ↓ same var ↑ 
#     ---- 
      pkgs.wineWow64Packages.stagingFull
      pkgs.winetricks
    ];
  })
]
