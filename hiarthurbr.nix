{ config, pkgs, system, inputs, ... }:

{
  home.packages = with pkgs; [
    kitty ghostty warp-terminal
    inputs.zen-browser.packages."${system}".twilight
    fish protonmail-bridge protonmail-bridge-gui
    proton-pass starship nushell # input-leap
    discord discordo commit-mono
    eza zoxide xh zellij gitui dust dua yazi hyperfine evil-helix
    cargo-info rusty-man tokei just kondo htop btop mprocs
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
    userName = "hiarthurbr";
    userEmail = "hi@arthurbr.me";
    extraConfig = {
      init.defaultBranch = "master";
      gpg.format = "ssh";
      user.signingkey = "/home/hiarthurbr/.ssh/id_ed25519.pub";
    };
  };
}
