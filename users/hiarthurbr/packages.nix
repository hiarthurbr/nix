{
  pkgs,
  unstable,
  env,
  inputs,
  ...
}:
with pkgs;
[

  # IDEs
  jetbrains.rust-rover
  jetbrains.idea
  unstable.zed-editor
  evil-helix

  # Browsers
  inputs.zen-browser.packages."${env.system}".twilight
  nur.repos.Ev357.helium

  # Shell stuff
  xh
  dust
  dua
  hyfetch
  fastfetch

  # Git stuff
  git-cliff
  jujutsu
  gitui

  # Dev stuff
  hyperfine
  cargo-info
  rusty-man
  tokei
  just
  kondo

  # General CLI/TUI stuff
  htop
  btop
  mprocs
  spotify-player

  # Apps
  protonmail-bridge
  protonmail-bridge-gui
  proton-vpn
  proton-pass
  discord
  prismlauncher
  chatterino7
  input-leap
  pavucontrol
  easyeffects
  spotify
  unstable.httpie-desktop
  alacritty
  foot
  ncspot

  # Fonts
  commit-mono
  nerd-fonts.commit-mono
  nerd-fonts.caskaydia-mono
  nerd-fonts.caskaydia-cove
  nerd-fonts.geist-mono
  nerd-fonts.jetbrains-mono

  # extensions
  valent
]
