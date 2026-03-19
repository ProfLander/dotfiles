{
  system,
  niri,
  util-niri,
  util-obs,
  util-nvim,
  util-desktop,
  util-toolchain,
  util-getafix,
  util-project,
  util-input-history,
  ...
}:
{
  nixpkgs.overlays = [
    (final: prev: {
      getafix = util-getafix.packages.${system}.default;
    })
    (final: prev: {
      project = util-project.packages.${system}.default;
    })
    (final: prev: {
      input-history = util-input-history.packages.${system}.default;
    })
    (final: prev: {
      niri = niri.packages.${system}.default;
    })
    (final: prev: util-niri.packages.${system})
    (final: prev: util-obs.packages.${system})
    (final: prev: util-nvim.packages.${system})
    (final: prev: util-desktop.packages.${system})
    (final: prev: {
      duck-repl = util-toolchain.packages.${system}.default;
    })
  ];
}
