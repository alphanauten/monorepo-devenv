
{ pkgs, config, inputs, lib, ... }:

let
  cfg = config.alphanauten;
in {
  config = lib.mkIf cfg.enable {
    services.mysql = {
      enable = lib.mkDefault true;
      package = lib.mkDefault pkgs.mysql80;
      initialDatabases = lib.mkDefault [{ name = "neos"; }];
      ensureUsers = lib.mkDefault [{
        name = "neos";
        password = "neos";
        ensurePermissions = { "*.*" = "ALL PRIVILEGES"; };
      }];
      settings = {
        mysqld = lib.mkMerge [
          (lib.mkIf cfg.enable {
            group_concat_max_len = 32000;
            key_buffer_size = 16777216;
            max_allowed_packet = 134217728;
            table_open_cache = 1024;
            port = cfg.mysqlPort;
            sql_mode = "STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION";
          })
          (lib.mkIf (cfg.enableMysqlBinLog) {
            sync_binlog = 0;
            log_bin_trust_function_creators = 1;
          })
          (lib.mkIf (!cfg.enableMysqlBinLog) {
            skip_log_bin = 1;
          })
        ];
        mysql = {
          user = "neos";
          password = "neos";
          host = "127.0.0.1";
        };
        mysqldump = {
          user = "neos";
          password = "neos";
          host = "127.0.0.1";
        };
        mysqladmin = {
          user = "neos";
          password = "neos";
          host = "127.0.0.1";
        };
      };
    };
  };
}
