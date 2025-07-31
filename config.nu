$env.config.show_banner = false;

def commit-all [message: string] {
  git add .
  git commit -S -m $message
}

def cleanup [] {
  sudo nix-env --delete-generations 7d;
  nix-store --gc
  sudo nix-collect-garbage -d
}

def nix-update [] {
  cd /home/hiarthurbr/nix;
  git pull;
  nix flake update --commit-lock-file;
  git add .
  commit-all (["chore: flake update ", (date now | format date "%Y-%m-%d %H:%M:%S")] | str join);
  push;
  sudo nixos-rebuild switch --show-trace --flake . --refresh;
}

# Define a function to open a project in a nix-shell environment.
def open-project [project: string] {
  let project_path = $"~/Developer/($project)"
  let devenv_path = ($project_path | path join "devenv.json")

  if ($devenv_path | path exists) {
    let devenv = open ($devenv_path | path expand)
    let packages = ($devenv.packages | each {|p| ["-p", $p] } | flatten)
    let editor_cmd = $devenv.editor
    let aliases = if (($devenv | get commands?) != null) {
      ($devenv.commands
        | transpose key value
        | each {|entry| ($"alias ($entry.key) = ($entry.value)") })
    } else { [] }

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
      []
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

source ~/.zoxide.nu
