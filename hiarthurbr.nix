{ config, pkgs, system, inputs, ... }:

{
  home.packages = with pkgs; [
    kitty ghostty warp-terminal
    inputs.zen-browser.packages."${system}".twilight
    fish protonmail-bridge protonmail-bridge-gui
    proton-pass starship nushell # input-leap
    discord discordo commit-mono
    eza zoxide xh zellij gitui dust dua yazi hyperfine evil-helix
    cargo-info rusty-man tokei just kondo
  ];

  # Fish shell init script
  # programs.bash.initExtra = ''
  #   if [[ $(${pkgs.procps}/bin/ps --no-header --pid=$PPID --format=comm) != "fish" && -z ${BASH_EXECUTION_STRING} && ${SHLVL} == 1 ]]
  #   then
  #     shopt -q login_shell && LOGIN_OPTION='--login' || LOGIN_OPTION=""
  #     exec ${pkgs.fish}/bin/fish $LOGIN_OPTION
  #   fi
  # '';

  programs.fish = {
    enable = true;
    
    interactiveShellInit = ''
      set fish_greeting;
      starship init fish | source;
    '';

    shellAliases = {
      zed = "zeditor";
      rebuild = "sudo nixos-rebuild switch --show-trace";
      update = "nix-channel --update";
      upgrade = "nix-env --upgrade";      
    };

    functions = {
      open_project = ''
        # Construct the project directory (all projects live in ~/Developer)
        set proj_dir ~/Developer/$argv[1]

        # Verify that the config file exists
        if test -f "$proj_dir/setup.nix"
          echo "Launching project $argv[1]…"
          # Start a nix-shell based on the project's setup.nix.
          # The --command option executes a series of commands:
          #   • cd into the project folder
          #   • If a startup script (e.g. startup.fish) exists in the project folder, source it
          #   • Override the exit command so that if an exit script (e.g. exit.fish) exists, it is sourced before actually exiting.
          #   • Finally, launch an interactive fish shell.
          nix-shell "$proj_dir/setup.nix" --command "
            cd '$proj_dir';
            if test -f startup.fish; source startup.fish; end;
              # Override exit within the shell:
              function exit;
                if test -f exit.fish; source exit.fish; end;
                command exit;
              end;
            fish
          "
        else
          echo "No setup.nix found in $proj_dir"
        end
      '';
    };
  };

  programs.nushell = {
    enable = true;

    shellAliases = {
      zed = "zeditor";
      rebuild = "sudo nixos-rebuild switch --show-trace --flake git+https://github.com/hiarthurbr/nix --refresh --no-write-lock-file";
      # update = "nix-channel --update";
      # upgrade = "nix-env --upgrade";
      push = "git push -u (git remote show) ((git branch --no-color | lines | where (str starts-with '*')).0 | str trim -c '*' | str trim)";
      cleanup = "sudo nix-env --delete-generations 7d; sudo nix-collect-garbage -d";
      op = "open-project";
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
