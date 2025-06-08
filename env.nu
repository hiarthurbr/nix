zoxide init nushell | save -f ~/.zoxide.nu
starship init nu | save -f ($nu.data-dir | path join ($starship_config | path join "starship.nu"))
