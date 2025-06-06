{ config, pkgs, system, inputs, ... }:

let 
  udevmon_config = pkgs.writeTextFile {
    name = "udevmon.yaml";
    text = ''
      - JOB: "${pkgs.interception-tools}/bin/intercept -g $DEVNODE | ${pkgs.interception-tools-plugins.caps2esc}/bin/caps2esc | ${pkgs.interception-tools}/bin/uinput -d $DEVNODE"
        DEVICE:
          EVENTS:
            EV_KEY: [KEY_CAPSLOCK, KEY_ESC]
    '';
  };
in {
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
      rebuild = "sudo nixos-rebuild switch --show-trace --flake git+https://github.com/hiarthurbr/nix --refresh";
      # update = "nix-channel --update";
      # upgrade = "nix-env --upgrade";
      push = "git push -u (git remote show) ((git branch --no-color | lines | where (str starts-with '*')).0 | str trim -c '*' | str trim)";
    };

    configFile.text = ''
      $env.config.show_banner = false;

      def update [] {
        let _old_cwd = $env.PWD
        cd /etc/nixos
        sudo nix flake update
        nix-channel --update
        nix-env --upgrade
        cd $_old_cwd
      }

      def commit-all [message: string] {
        git add .
        git commit -S -m $message
      }

      # Define a function to open a project in a nix-shell environment.
      def open-project [project: string] {
        let project_path = $"~/Developer/($project)"
        let devenv_path = ($project_path | path join "devenv.json")

        if ($devenv_path | path exists) {
          let devenv = open ($devenv_path | path expand)
          let packages = ($devenv.packages | each {|p| ["-p", $p] } | flatten)
          let editor_cmd = $devenv.editor
          let aliases = ($devenv.commands
                        | transpose key value
                        | each {|entry| ($"alias ($entry.key) = ($entry.value)") })

          # Build functions from the `functions` field if present
          let functions = if (($devenv | get functions?) != null) {
            ($devenv.functions
              | transpose key value
              | each {|entry|
                  let cmd = ($entry.value | get 1)
                  # Generate parameter names as _1, _2, etc.
                  let param_names = $entry.value | get 0 | enumerate | each {|i| ($"_($i.index + 1): ($i.item)")} | str join ", ";
                  ($"def ($entry.key) [($param_names)] { ($cmd) }")
              })
          } else {
            ""
          }

          print ($aliases | wrap "Aliases")
          print ($functions | wrap "Functions")

          nix-shell --show-trace -p ...$packages "--command" $"nu -e 'cd ($project_path); run-external ($editor_cmd) ($project_path | path expand); ($aliases | str join '; '); ($functions | str join '; ')'"
        } else {
          if ($project_path | path expand | path exists) {
            print $"Error: devenv.json not found in `($project_path)`, creating one..."
            ({
              "$schema": "https://gist.githubusercontent.com/hiarthurbr/70943959bc52a3dd8afd79a3f9e79128/raw/nu-open-project-devenv-schema.json",
              "packages": ["bun", "biome", "nodejs_18"],
              "editor": "zeditor",
              "commands": {
                "install": "bun install",
                "dev": "bun run dev"
              },
              "functions": {
                "start": [[], "bun run build; bun run -b start"],
                "add": [["string"], "bun run add $_1"]
              }
            }) | save -p $devenv_path
            print "Done!"
          } else { print $"Error: `($project_path)` does not exist." }
        }
      }

      alias op = open-project

      const starship_config = $nu.data-dir | path join "vendor/autoload"
      if (not (($starship_config | path join "starship.nu") | path exists)) {
        mkdir $starship_config
        starship init nu | save -f ($nu.data-dir | path join ($starship_config | path join "starship.nu"))
      }
    '';
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
