{ config, pkgs, unstable, system, inputs, ... }:

{
  home.packages = with pkgs; [
    # Terminals
    kitty ghostty warp-terminal

    # IDEs
    jetbrains.rust-rover unstable.zed-editor evil-helix

    # Browsers
    inputs.zen-browser.packages."${system}".twilight nur.repos.Ev357.helium

    # Shells
    fish nushell

    # Shell stuff
    eza zoxide xh zellij dust dua yazi starship hyfetch

    # Git stuff
    git-cliff jujutsu gitui

    # Dev stuff
    hyperfine cargo-info rusty-man tokei just kondo devenv

    # General CLI/TUI stuff
    htop btop mprocs discordo spotify-player

    # Apps
    protonmail-bridge protonmail-bridge-gui proton-pass discord prismlauncher chatterino7 input-leap pavucontrol easyeffects spotify

    # Fonts
    commit-mono

    # Gnome extensions
    gnomeExtensions.blur-my-shell gnomeExtensions.just-perfection gnomeExtensions.arc-menu gnomeExtensions.appindicator
  ];

  programs.nushell = {
    enable = true;

    shellAliases = {
      zed = "zeditor";
      rebuild = "sudo nixos-rebuild switch --show-trace --flake git+https://github.com/hiarthurbr/nix --refresh --no-write-lock-file";
      # update = "nix-channel --update";
      # upgrade = "nix-env --upgrade";
      push = "git push -u (git remote show) ((git branch --no-color | lines | where (str starts-with '*')).0 | str trim -c '*' | str trim)";
      op = "open-project";
      ls = "${pkgs.eza}/bin/eza";
      _ls = "${pkgs.uutils-coreutils-noprefix}/bin/ls";
    };

    configFile.source = ./config.nu;
    envFile.source = ./env.nu;
  };

  programs.git = {
    enable = true;
    settings = {
      user = {
        email = "hi@arthurbr.me";
        name = "hiarthurbr";
      };
      init.defaultBranch = "master";
      gpg.format = "ssh";
      user.signingkey = "/home/hiarthurbr/.ssh/id_ed25519.pub";
    };
  };
}
