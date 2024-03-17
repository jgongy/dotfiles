{ pkgs, ... }:

{
  home.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    (nerdfonts.override {
      fonts = [
        "Agave"
        "Hermit"
        "JetBrainsMono"
        "Noto"
        "ShareTechMono"
        "NerdFontsSymbolsOnly"
        "Terminus"
      ];
    })

    lxappearance
  ];

  home.shellAliases = {
    "lxappearance" = "GDK_BACKEND=x11 lxappearance";
  };

  fonts.fontconfig.enable = true;
  # fonts.fontconfig = {
  #   defaultFonts = {
  #     monospace= [
  #       "Noto Mono"
  #     ];
  #     sansSerif = [
  #       "Noto Sans"
  #     ];
  #     serif = [
  #       "Noto Serif"
  #     ];
  #   };
  # };

	home.pointerCursor = {
		gtk.enable = true;
		package = pkgs.bibata-cursors;
		name = "Bibata-Original-Classic";
		size = 16;
	};

  gtk.enable = true;
	gtk = {
    theme = {
			package = pkgs.orchis-theme;
			name = "Orchis-Green-Dark-Compact";
		};

		iconTheme = {
			package = pkgs.papirus-icon-theme;
			name = "Papirus-Dark";
		};

    # font = {
		# 	name = "Noto Sans";
		# 	size = 11;
		# };
  };
}
