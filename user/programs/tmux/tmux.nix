{pkgs, ...}: {
  # https://github.com/NixOS/nixpkgs/pull/262607
  nixpkgs.overlays = [
    (self: super: {
      tmuxPlugins =
        super.tmuxPlugins
        // {
          extrakto = super.tmuxPlugins.mkTmuxPlugin {
            pluginName = "extrakto";
            version = "unstable-2023-10-21";
            src = super.fetchFromGitHub {
              owner = "laktak";
              repo = "extrakto";
              rev = "f69af5fb5e5ff6a4ae7e30ec91c7e15146ebdf07";
              sha256 = "sha256-mAe2J81VVrWQKxG3rrAH6oIq47ZFfJtv8OzBiqrr6m8=";
            };
            nativeBuildInputs = [super.pkgs.makeWrapper];
            postInstall = ''
              for f in extrakto.sh open.sh; do
                wrapProgram $target/scripts/$f \
                  --prefix PATH : ${with super.pkgs; lib.makeBinPath [super.pkgs.fzf super.pkgs.python3 super.pkgs.xclip]}
              done
            '';
            meta = {
              homepage = "https://github.com/laktak/extrakto";
              description = "Fuzzy find your text with fzf instead of selecting it by hand";
              license = super.lib.licenses.mit;
              platforms = super.lib.platforms.unix;
              maintainers = with super.lib.maintainers; [kidd];
            };
          };
        };
    })
  ];

  programs.tmux = {
    enable = true;
    extraConfig = builtins.readFile ./tmux.conf;
    terminal = "tmux-256color";
    plugins = with pkgs.tmuxPlugins; [
      yank
      vim-tmux-navigator
      extrakto
    ];
  };
}
