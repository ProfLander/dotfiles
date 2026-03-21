{
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
let sys = "x86_64-linux"; in {
  nixpkgs.overlays = [
    (final: prev: {
      getafix = util-getafix.packages.${sys}.default;
    })
    (final: prev: {
      project = util-project.packages.${sys}.default;
    })
    (final: prev: {
      input-history = util-input-history.packages.${sys}.default;
    })
    (final: prev: {
      niri = niri.packages.${sys}.default.overrideAttrs (oa: {
        doCheck = false;
        doInstallCheck = false;
      });
    })
    (final: prev: util-niri.packages.${sys})
    (final: prev: util-obs.packages.${sys})
    (final: prev: util-nvim.packages.${sys})
    (final: prev: util-desktop.packages.${sys})
    (final: prev: {
      duck-repl = util-toolchain.packages.${sys}.default;
    })
  ];
}
