{ ... }: {
	enable = true;
	enableNushellIntegration = true;
	nix-direnv.enable = true;

	config = {
		global = {
			hide_env_diff = true;
			log_format = "\u001B[2mdirenv: %s\u001B[0m";
		};
	};
}
