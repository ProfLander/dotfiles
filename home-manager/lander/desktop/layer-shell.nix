{ pkgs, inputs, ... }:

{
  home.packages = [
    # Obelix
    inputs.obelix.packages.${pkgs.system}.default
  ];

  # Aylur's GTK Shell

  ## Enable home-manager module
  imports = [
      inputs.ags.homeManagerModules.default
  ];

  programs.ags = {
    enable = true;
    extraPackages = with pkgs; [
        #inputs.astal.packages.${pkgs.system}.battery
    ];
  };
}
