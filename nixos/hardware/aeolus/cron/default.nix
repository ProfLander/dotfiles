{
  environment.etc."duck.sh" = {
    source = ./duck.sh;
    mode = "0755";
  };

  # Enable cron service
  services.cron = {
    enable = true;
    systemCronJobs = [
      "*/5 * * * *  root  /etc/duck.sh > /dev/null 2>&1"
    ];
  };
}
