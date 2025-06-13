const starship_config = $nu.data-dir | path join "vendor/autoload"
mkdir $starship_config
starship init nu | save -f ($nu.data-dir | path join ($starship_config | path join "starship.nu"))

zoxide init --cmd cd nushell | save -f ~/.zoxide.nu
