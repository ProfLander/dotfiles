{ config, pkgs, lib, inputs, ... }:

{
  programs.oh-my-posh = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      "$schema" =
        "https://raw.githubusercontent.com/JanDeDobbeleer/oh-my-posh/main/themes/schema.json";
      "palette" = {
        "Background" = "#282A36";
        "Black" = "#21222C";
        "BrightGreen" = "#69FF94";
        "BrightPink" = "#FF92DF";
        "BrightPurple" = "#D6ACFF";
        "BrightRed" = "#FF6E6E";
        "BrightYellow" = "#FFFFA5";
        "Cyan" = "#8BE9FD";
        "Foreground" = "#F8F8F2";
        "Green" = "#50FA7B";
        "Highlight" = "#6272A4";
        "Orange" = "#FFB86C";
        "Pink" = "#FF79C6";
        "Purple" = "#BD93F9";
        "Red" = "#FF5555";
        "Selection" = "#44475A";
        "White" = "#FFFFFF";
        "Yellow" = "#F1FA8C";
      };
      "secondary_prompt" = {
        "template" = "<p:Highlight>╶╴</>󰧂  ";
        "foreground" = "p:Pink";
      };
      "transient_prompt" = {
        "template" = "<p:Highlight>╶╴</>󰜴 ";
        "foreground" = "p:Pink";
        "newline" = true;
      };
      "console_title_template" = "{{ .Shell }} in {{ .Folder }}";
      "blocks" = [
        {
          "type" = "prompt";
          "alignment" = "left";
          "segments" = [
            {
              "template" = "<p:Highlight>╭╴</>";
              "type" = "text";
            }
            {
              "template" = "<p:Purple> <p:BrightPurple>{{ .HostName }}</>";
              "type" = "session";
              "style" = "plain";
            }
            {
              "template" = "<p:Highlight>╶╴</>";
              "type" = "text";
            }
            {
              "template" =
                "<p:Cyan> {{ if .SSHSession }} {{ end }}{{ .UserName }}</>";
              "type" = "session";
              "style" = "plain";
            }
            {
              "template" = "<p:Highlight>╶</>";
              "type" = "text";
            }
          ];
          "newline" = true;
        }
        {
          "type" = "prompt";
          "alignment" = "right";
          "filler" = "<p:Highlight>─</>";
          "segments" = [
            {
              "template" = "<p:Highlight>╴</>";
              "type" = "text";
            }
            {
              "properties" = {
                "display_mode" = "files";
                "fetch_package_manager" = false;
                "home_enabled" = false;
              };
              "template" = " ";
              "foreground" = "p:Green";
              "type" = "node";
              "style" = "plain";
            }
            {
              "properties" = { "fetch_version" = false; };
              "template" = " ";
              "foreground" = "p:Cyan";
              "type" = "go";
              "style" = "plain";
            }
            {
              "properties" = {
                "display_mode" = "files";
                "fetch_version" = false;
                "fetch_virtual_env" = false;
              };
              "template" = " ";
              "foreground" = "p:Yellow";
              "type" = "python";
              "style" = "plain";
            }
            {
              "template" = ''
                <p:BrightPurple>{{ .CurrentDate | date "3:04am" }}</> <p:Purple> </>'';
              "type" = "time";
              "style" = "plain";
            }
            {
              "template" = "<p:Highlight>╶╮</>";
              "type" = "text";
            }
          ];
        }
        {
          "type" = "prompt";
          "alignment" = "left";
          "segments" = [
            {
              "template" = "<p:Highlight>│ </>";
              "type" = "text";
            }
            {
              "properties" = { "style" = "full"; };
              "template" = "<p:Orange> {{ .Path }}</>";
              "type" = "path";
            }
            {
              "template" = "<p:Highlight>╶</>";
              "type" = "text";
            }
          ];
          "newline" = true;
        }
        {
          "type" = "prompt";
          "alignment" = "right";
          "filler" = "<p:Highlight>─</>";
          "segments" = [
            {
              "properties" = {
                "branch_template" = "{{ trunc 25 .Branch }}";
                "fetch_status" = true;
                "fetch_upstream_icon" = true;
              };
              "template" =
                "<p:Highlight>╴</><p:Yellow>{{ if .Working.Changed }} {{ .Working.String }}{{ end }}{{ if .Staging.Changed }} {{ .Staging.String }}{{ end }}</><p:Highlight>╶╴</><p:Orange>{{ if .UpstreamURL }}{{ url .UpstreamIcon .UpstreamURL }} {{ end }}{{if .BranchStatus }}{{ .BranchStatus }} {{ end }}{{ .HEAD }}  </><p:Highlight></><p:Highlight>╶</>";
              "type" = "git";
            }
            {
              "template" = " ";
              "foreground" = "p:Red";
              "type" = "root";
              "style" = "plain";
            }
            {
              "template" = "<p:Highlight>╯</>";
              "type" = "text";
            }
          ];
        }
        {
          "type" = "prompt";
          "alignment" = "left";
          "segments" = [
            {
              "template" = "<p:Highlight>╰╴</>";
              "type" = "text";
            }
            {
              "template" = "󰜴 ";
              "foreground" = "p:BrightPink";
              "type" = "text";
            }
          ];
          "newline" = true;
        }
      ];
      "version" = 3;
    };
  };
}
