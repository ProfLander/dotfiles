{
  services.nginx = {
    enable = true;
    virtualHosts."prof-lander.duckdns.org" = {
      addSSL = true;
      enableACME = true;

      locations."/" = {
        return = "200 '<html><body>It works</body></html>'";
        extraConfig = ''
          default_type text/html;
        '';
      };
    };
  };

  networking.firewall.allowedTCPPorts = [
    80
    443
  ];

  security.acme = {
    # Accept the CA’s terms of service. The default provider is Let’s Encrypt, you can find their ToS at https://letsencrypt.org/repository/.
    acceptTerms = true;
    # Optional: You can configure the email address used with Let's Encrypt.
    # This way you get renewal reminders (automated by NixOS) as well as expiration emails.
    defaults.email = "jpalmerwatkins@gmail.com";
  };
}
