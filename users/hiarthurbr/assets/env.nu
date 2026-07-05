const starship_config = $nu.data-dir | path join "vendor/autoload"
mkdir $starship_config
starship init nu | save -f ($nu.data-dir | path join ($starship_config | path join "starship.nu"))

zoxide init --cmd cd nushell | save -f ~/.zoxide.nu

hyfetch -p progress,progress,progress,progress,progress,progress,progress,progress,progress,progress,progress,progress,progress,progress,progress,progress,progress,progress,progress,progress,progress,progress,progress,progress,progress,progress,progress,progress,baker,baker,baker,baker,baker,baker,baker,baker,baker,baker,baker,baker,baker,baker,baker,baker,baker,baker,rainbow,rainbow,rainbow,rainbow,rainbow,rainbow,rainbow,rainbow,rainbow,rainbow,rainbow,rainbow,rainbow,rainbow,rainbow,rainbow,rainbow,rainbow,rainbow,rainbow,rainbow,rainbow,rainbow,rainbow,transgender,xenogender,bisexual,genderfluid,pansexual,lesbian,bigender,transmasculine,transfeminine,genderfaun,genderfae,demifaun,demifae,genderflux,finsexual,unlabeled2,pangender.contrast,gendernonconforming1,femboy,voidgirl,plural,femme,twink,veldian,solian,lunian,polyam,sapphic,androgyne,interprogress,progress,drag,pronounfluid,baker,fluidflux1,fluidflux2,transbian,autism,,cenelian,band --args="-c examples/10.jsonc"
