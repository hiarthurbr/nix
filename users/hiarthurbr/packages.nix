{
  pkgs,
  unstable,
  env,
  inputs,
  ...
}:
with pkgs;
[
  # Terminals
  kitty
  ghostty
  warp-terminal

  # IDEs
  jetbrains.rust-rover
  jetbrains.idea-community
  unstable.zed-editor
  evil-helix

  # Browsers
  inputs.zen-browser.packages."${env.system}".twilight
  nur.repos.Ev357.helium

  # Shells
  fish
  nushell

  # Shell stuff
  eza
  zoxide
  xh
  zellij
  dust
  dua
  yazi
  starship
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
  devenv

  # General CLI/TUI stuff
  htop
  btop
  mprocs
  discordo
  spotify-player

  # Apps
  protonmail-bridge
  protonmail-bridge-gui
  protonvpn-gui
  proton-pass
  discord
  prismlauncher
  chatterino7
  input-leap
  pavucontrol
  easyeffects
  spotify

  # Fonts
  commit-mono

  # Gnome extensions
  gnomeExtensions.blur-my-shell
  gnomeExtensions.just-perfection
  gnomeExtensions.arc-menu
  gnomeExtensions.appindicator
  gnomeExtensions.dash-to-dock
  gnomeExtensions.applications-menu
  gnomeExtensions.top-bar-organizer
  gnomeExtensions.astra-monitor
  gnomeExtensions.dash2dock-lite
  gnomeExtensions.custom-window-controls
]
