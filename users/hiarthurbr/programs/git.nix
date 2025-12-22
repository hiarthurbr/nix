{ ... }: {
  enable = true;
  settings = {
    user = {
      email = "hi@arthurbr.me";
      name = "hiarthurbr";
    };
    init.defaultBranch = "master";
    gpg.format = "ssh";
    user.signingkey = "/home/hiarthurbr/.ssh/id_ed25519.pub";
  };
}
