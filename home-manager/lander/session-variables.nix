{
  home.sessionVariables = {
    # Emacsclient as text editor
    EDITOR = "emacsclient -nw";

    # C/++ compilers
    CC = "gcc";
    CXX = "g++";

    # Remove right space padding from zsh
    ZLE_RPROMPT_INDENT = 0;

    # Colored man pages
    LESS_TERMCAP_mb = "$(tput blink; tput setaf 1)";
    LESS_TERMCAP_md = "$(tput bold; tput setaf 1)";
    LESS_TERMCAP_me = "$(tput sgr0)";
    LESS_TERMCAP_us = "$(tput smul)";
    LESS_TERMCAP_ue = "$(tput rmul)";
    LESS_TERMCAP_so = "$(tput smso)";
    LESS_TERMCAP_se = "$(tput rmso)";
  };
}
