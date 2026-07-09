{ ... }: {
	enable = true;
	enableNushellIntegration = true;
	nix-direnv.enable = true;

	config = {
		global = {
			hide_env_diff = true;
			log_format = builtins.fromJSON "\u001B[2m" + "direnv: %s" + builtins.fromJSON "\u001B[0m";
		};
	};
}
