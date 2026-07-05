{ pkgs, ... }: {
  enable = true;

  shellAliases = {
    zed = "zeditor";
    rebuild =
      "sudo nixos-rebuild switch --show-trace --flake git+https://github.com/hiarthurbr/nix --refresh --no-write-lock-file";
    # update = "nix-channel --update";
    # upgrade = "nix-env --upgrade";
    push =
      "git push -u (git remote show) ((git branch --no-color | lines | where (str starts-with '*')).0 | str trim -c '*' | str trim)";
    op = "open-project";
    ls = "${pkgs.eza}/bin/eza";
    _ls = "${pkgs.uutils-coreutils-noprefix}/bin/ls";
  };

  configFile.source = ../assets/config.nu;
  envFile.source = ../assets/env.nu;
}
