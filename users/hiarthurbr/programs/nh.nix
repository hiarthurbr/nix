{ config, ... }: {
	enable = true;
	clean = {
		enable = true;
		extraArgs = "--keep-since 2w --keep 10 --optimise";
		dates = "daily";
	};
	flake = "${config.home.homeDirectory}/nix";
}
