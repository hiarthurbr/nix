{ config, pkgs, unstable, system, inputs, ... }:

{
  home.packages = with pkgs; [
    kitty ghostty warp-terminal # Terminals
    
    jetbrains.rust-rover unstable.zed-editor evil-helix # IDEs
    
    inputs.zen-browser.packages."${system}".twilight # Browsers

    fish nushell # Shells

    eza zoxide xh zellij dust dua yazi starship # Shell stuff
    
    git-cliff jujutsu gitui # Git stuff

    hyperfine cargo-info rusty-man tokei just kondo devenv # Dev stuff

    htop btop mprocs # General CLI/TUI stuff

    protonmail-bridge protonmail-bridge-gui proton-pass discord prismlauncher chatterino7 input-leap pavucontrol easyeffects spotify # Apps

    discordo spotify-player # CLI/TUI Apps

    commit-mono # Fonts
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
