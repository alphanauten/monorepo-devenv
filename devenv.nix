{ pkgs, config, inputs, lib, ... }:
let
  cfg = config.alphanauten;

  currentVersion = "v1.0.0";

  listEntries = path:
    map (name: path + "/${name}") (builtins.attrNames (builtins.readDir path));
in {
  imports = (listEntries ./modules);

  config = lib.mkIf cfg.enable {
    packages = [
      pkgs.jq
      pkgs.gnupatch
    ] ++ cfg.additionalPackages;

    languages.javascript = {
      enable = lib.mkDefault true;
      package = lib.mkDefault pkgs.nodejs-18_x;
    };

    services.adminer.enable = lib.mkDefault true;
    services.adminer.listen = lib.mkDefault "127.0.0.1:${toString cfg.adminerPort}";

    services.mailhog.enable = true;
    services.mailhog.apiListenAddress = lib.mkDefault "127.0.0.1:${toString cfg.mailhogApiPort}";
    services.mailhog.smtpListenAddress = lib.mkDefault "127.0.0.1:${toString cfg.mailhogSmtpPort}";
    services.mailhog.uiListenAddress = lib.mkDefault "127.0.0.1:${toString cfg.mailhogUiPort}";

    dotenv.disableHint = true;

    # Environment variables
    env = lib.mkMerge [
      (lib.mkIf cfg.enable {
        DATABASE_URL = lib.mkDefault "mysql://neos:neos@127.0.0.1:${toString cfg.mysqlPort}/neos";
        MAILER_URL = lib.mkDefault "smtp://127.0.0.1:${toString cfg.mailhogSmtpPort}?encryption=&auth_mode=";
        MAILER_DSN = lib.mkDefault "smtp://127.0.0.1:${toString cfg.mailhogSmtpPort}?encryption=&auth_mode=";

        APP_URL = lib.mkDefault "http://127.0.0.1:${toString cfg.httpPort}";
        CYPRESS_baseUrl = lib.mkDefault "http://127.0.0.1:${toString cfg.httpPort}";

        SQL_SET_DEFAULT_SESSION_VARIABLES = lib.mkDefault "0";

        NODE_OPTIONS = "--openssl-legacy-provider --max-old-space-size=2000";
        NPM_CONFIG_ENGINE_STRICT = "false"; # hotfix for npm10
      })
    ];
  };
}