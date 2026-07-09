{ ... }: {
	enable = true;
	enableNushellIntegration = true;
	nix-direnv.enable = true;

	config = {
		global = {
			hide_env_diff = true;
			log_format = ''
				\033[2mdirenv: %s\033[0m
			'';
		};
	};
}
