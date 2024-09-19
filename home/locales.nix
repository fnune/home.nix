let
  en_default = "en_US.UTF-8";
  en_metric = "en_DK.UTF-8";
  en_yymmdd = "en_GB.UTF-8";
  euro = "de_DE.UTF-8";
in {
  LC_CTYPE = en_default;
  LC_MESSAGES = en_default;
  LC_IDENTIFICATION = en_default;
  LC_COLLATE = en_default;

  LC_MEASUREMENT = en_metric;

  LC_TIME = en_yymmdd;

  LC_ADDRESS = euro;
  LC_MONETARY = euro;
  LC_NAME = euro;
  LC_NUMERIC = euro;
  LC_PAPER = euro;
  LC_TELEPHONE = euro;
}
