{ config, lib, pkgs, ... }:

let
  zsh = pkgs.zsh;
in
{
  programs.zellij = {
    enable = true;
    enableZshIntegration = true;
    exitShellOnExit = true;

    settings = {
      show_startup_tips = false;
      theme = "dracula";

      ui = {
        pane_frames = {
          rounded_corners = true;
        };
      };
    };

    layouts = {
      dev = {
        layout = {
          _children = [
            {
              default_tab_template = {
                _children = [
                  {
                    pane = {
                      size = 1;
                      borderless = true;
                      plugin = {
                        location = "zellij:tab-bar";
                      };
                    };
                  }
                  { "children" = { }; }
                  {
                    pane = {
                      size = 2;
                      borderless = true;
                      plugin = {
                        location = "zellij:status-bar";
                      };
                    };
                  }
                ];
              };
            }
            {
              tab = {
                _props = {
                  name = "Project";
                  focus = true;
                };
                _children = [
                  {
                    pane = {
                      command = "nvim";
                    };
                  }
                ];
              };
            }
            {
              tab = {
                _props = {
                  name = "Git";
                };
                _children = [
                  {
                    pane = {
                      command = "gitu";
                    };
                  }
                ];
              };
            }
            {
              tab = {
                _props = {
                  name = "Files";
                };
                _children = [
                  {
                    pane = {
                      command = "broot";
                    };
                  }
                ];
              };
            }
            {
              tab = {
                _props = {
                  name = "Shell";
                };
                _children = [
                  {
                    pane = {
                      command = "zsh";
                    };
                  }
                ];
              };
            }
          ];
        };
      };

      nixos = {
        layout = {
          _children = [
            {
              default_tab_template = {
                _children = [
                  {
                    pane = {
                      size = 1;
                      borderless = true;
                      plugin = {
                        location = "zellij:tab-bar";
                      };
                    };
                  }
                  { "children" = { }; }
                  {
                    pane = {
                      size = 2;
                      borderless = true;
                      plugin = {
                        location = "zellij:status-bar";
                      };
                    };
                  }
                ];
              };
            }
            {
              tab = {
                _props = {
                  name = "Remote";
                };

                _children = [
                  {
                    pane = {
                      split_direction = "horizontal";
                      _children = [
                        {
                          pane = {
                            split_direction = "vertical";
                            _children = [
                              {
                                pane = {
                                  command = "nixos-rebuild";
                                  args = [
                                    "--flake"
                                    "${config.home.homeDirectory}/src/dotfiles#calliope"
                                    "--target-host"
                                    "calliope"
                                    "--sudo"
                                    "--ask-sudo-password"
                                    "switch"
                                  ];
                                  start_suspended = true;
                                };
                              }
                              {
                                pane = {
                                  command = "nixos-rebuild";
                                  args = [
                                    "--flake"
                                    "${config.home.homeDirectory}/src/dotfiles#artemis"
                                    "--target-host"
                                    "artemis"
                                    "--sudo"
                                    "--ask-sudo-password"
                                    "switch"
                                  ];
                                  start_suspended = true;
                                };
                              }
                            ];
                          };
                        }
                        {
                          pane = {
                            split_direction = "vertical";
                            _children = [
                              {
                                pane = {
                                  command = "nixos-rebuild";
                                  args = [
                                    "--flake"
                                    "${config.home.homeDirectory}/src/dotfiles#aeolus"
                                    "--target-host"
                                    "aeolus"
                                    "--sudo"
                                    "--ask-sudo-password"
                                    "switch"
                                  ];
                                  start_suspended = true;
                                };
                              }
                              {
                                pane = {
                                  command = "nixos-rebuild";
                                  args = [
                                    "--flake"
                                    "${config.home.homeDirectory}/src/dotfiles#theia"
                                    "--target-host"
                                    "theia"
                                    "--sudo"
                                    "--ask-sudo-password"
                                    "switch"
                                  ];
                                  start_suspended = true;
                                };
                              }
                            ];
                          };
                        }
                      ];
                    };
                  }
                ];
              };
            }
          ];
        };
      };
    };
  };

  programs.zsh = {
    enable = true;
    package = zsh;

    enableCompletion = true;
    enableVteIntegration = true;

    autocd = true;

    autosuggestion.enable = true;

    history.append = true;
    history.expireDuplicatesFirst = true;
    history.findNoDups = true;
    history.ignoreAllDups = true;
    history.ignoreDups = true;
    history.save = 10000;
    history.saveNoDups = true;
    history.size = 10000;

    initContent =
      let
        zshOptions = lib.mkOrder 950 ''
          # Set shell options
          setopt beep
          setopt no_match
          setopt notify
          setopt hist_verify
          setopt hist_beep
          setopt interactive_comments
          setopt inc_append_history
          unsetopt extended_history
        '';
        zshFunctions = lib.mkOrder 975 ''
          precmd () {
            echo $(oh-my-posh --config ${./return-code.json} --status $? --shell universal print primary)

            print -Pn "\e]0;zsh %(1j,%j job%(2j|s|); ,)%~\a"
          }

          preexec () {
            printf "\033]0;%s\a" "$1"
          }
        '';
        zshBindings = lib.mkOrder 1000 ''
          # Set shell keybinds
          bindkey "^[[3~" delete-char
          bindkey "^[[H" beginning-of-line
          bindkey "^[[F" end-of-line
          bindkey "^[[1;5C" forward-word
          bindkey "^[[1;5D" backward-word
        '';
      in
      lib.mkMerge [
        zshOptions
        zshFunctions
        zshBindings
      ];

    shellAliases = {
      ls = "ls -1 --color=always";
    };

    syntaxHighlighting.enable = true;
  };
}
