{ pkgs, ... }:

{
  gtk.cursorTheme.package = pkgs.posy-cursors;

  dconf = {
    enable = true;

    settings = {

      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = with pkgs.gnomeExtensions; [
          blur-my-shell.extensionUuid
          just-perfection.extensionUuid
          arc-menu.extensionUuid
          appindicator.extensionUuid
          dash-to-dock.extensionUuid
          applications-menu.extensionUuid
          top-bar-organizer.extensionUuid
          astra-monitor.extensionUuid
        ];
        favorite-apps = [
          "helium.desktop"
          "org.gnome.Nautilus.desktop"
          "com.mitchellh.ghostty.desktop"
          "dev.zed.Zed.desktop"
          "proton-pass.desktop"
        ];
      };

      "org/gnome/desktop/interface".color-scheme = "prefer-dark";

      "org/gnome/shell/extensions/blur-my-shell".hacks-level = 1;
      "org/gnome/shell/extensions/blur-my-shell/appfolder" = {
        brightness = 0.6;
        sigma = 30;
      };

      "org/gnome/shell/extensions/blur-my-shell/applications" = {
        blur = true;
        blur-on-overview = true;
        brightness = 1.0;
        dynamic-opacity = false;
        enable-all = true;
        opacity = 190;
        sigma = 30;
      };

      "org/gnome/shell/extensions/blur-my-shell/dash-to-dock" = {
        blur = true;
        brightness = 1.0;
        override-background = true;
        pipeline = "pipeline_default";
        sigma = 6;
        static-blur = false;
        style-dash-to-dock = 0;
        unblur-in-overview = true;
      };

      "org/gnome/shell/extensions/blur-my-shell/dash-to-panel".blur-original-panel =
        true;

      "org/gnome/shell/extensions/blur-my-shell/hidetopbar".compatibility =
        false;

      "org/gnome/shell/extensions/blur-my-shell/lockscreen".pipeline =
        "pipeline_default";

      "org/gnome/shell/extensions/blur-my-shell/overview" = {
        pipeline = "pipeline_default";
        style-components = 3;
      };

      "org/gnome/shell/extensions/blur-my-shell/panel" = {
        brightness = 0.6;
        pipeline = "pipeline_default";
        sigma = 30;
        static-blur = true;
      };

      "org/gnome/shell/extensions/blur-my-shell/screenshot".pipeline =
        "pipeline_default";

      "org/gnome/shell/extensions/blur-my-shell/window-list" = {
        brightness = 0.6;
        sigma = 30;
      };

      "org/gnome/shell/extensions/dash-to-dock" = {
        apply-custom-theme = false;
        background-color = "rgb(0,0,0)";
        background-opacity = 0.37;
        custom-background-color = true;
        custom-theme-shrink = false;
        customize-alphas = true;
        dash-max-icon-size = 48;
        dock-position = "BOTTOM";
        height-fraction = 0.9;
        intellihide-mode = "FOCUS_APPLICATION_WINDOWS";
        max-alpha = 0.4;
        min-alpha = 0.3;
        preferred-monitor = -2;
        preferred-monitor-by-connector = "HDMI-1";
        require-pressure-to-show = false;
        transparency-mode = "DYNAMIC";
      };
    };
  };
}
