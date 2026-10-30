{ pkgs-unstable, ... }: {
  programs.mise = {
    enable = true;
    package = pkgs-unstable.mise;
    enableZshIntegration = true;
    globalConfig.settings = {
      experimental = true;
      idiomatic_version_file_enable_tools = [ "node" ];
    };
  };
}
