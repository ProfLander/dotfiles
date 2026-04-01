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

    initContent = let
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
    in lib.mkMerge [ zshOptions zshFunctions zshBindings ];

    shellAliases = {
      ls = "ls -1 --color=always";
    };

    syntaxHighlighting.enable = true;
  };
}
