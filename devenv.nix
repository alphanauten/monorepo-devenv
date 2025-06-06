{ pkgs, config, inputs, lib, ... }:
let
  cfg = config.alphanauten;

  listEntries = path:
    map (name: path + "/${name}") (builtins.attrNames (builtins.readDir path));
in {
  imports = (listEntries ./modules);

  config = lib.mkIf cfg.enable {
    packages = [
      pkgs.jq
      pkgs.gnupatch
      pkgs.corepack
    ] ++ cfg.additionalPackages;

    languages.javascript = {
      enable = lib.mkDefault true;
      package = lib.mkDefault pkgs.nodejs_20;
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
        FLOW_CONTEXT = lib.mkDefault "Development";
        FLOW_REWRITEURLS = "1";
        NEOS_IMAGINE_DRIVER = lib.mkDefault "imagick";
        NEOS_DB_DRIVER = lib.mkDefault "pdo_mysql";
        NEOS_DB_HOST = lib.mkDefault "127.0.0.1";
        NEOS_DB_PORT = lib.mkDefault "${toString cfg.mysqlPort}";
        NEOS_DB_NAME = lib.mkDefault "neos";
        NEOS_DB_USER = lib.mkDefault "neos";
        NEOS_DB_PASSWORD = lib.mkDefault "neos";

        # TODO: Check Settings
        POSTFIX_HOST = lib.mkDefault "127.0.0.1";
        POSTFIX_PORT = "${toString cfg.mailhogSmtpPort}";
        POSTFIX_USER_NAME= "";
        POSTFIX_USER_PASSWORD= "";

        NEOS_BASE_URL = lib.mkDefault "http://127.0.0.1:${toString cfg.httpPort}";
        PUBLIC_BASE_URL = "http://localhost:3000";

        SQL_SET_DEFAULT_SESSION_VARIABLES = lib.mkDefault "0";

        NODE_OPTIONS = "--openssl-legacy-provider --max-old-space-size=2000";
        NPM_CONFIG_ENGINE_STRICT = "false"; # hotfix for npm10
      })
    ];
  };
}
