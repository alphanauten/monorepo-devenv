{ pkgs, config, inputs, lib, ... }:

let
  cfg = config.alphanauten;

  vhostConfig = lib.strings.concatStrings [
    ''
      @default {
        not path ${cfg.staticFilePaths}
        not expression header_regexp('xdebug', 'Cookie', 'XDEBUG_SESSION') || query({'XDEBUG_SESSION': '*'})
      }
      @debugger {
        not path ${cfg.staticFilePaths}
        expression header_regexp('xdebug', 'Cookie', 'XDEBUG_SESSION') || query({'XDEBUG_SESSION': '*'})
      }

      root * ${cfg.projectRoot}/${cfg.documentRoot}

      handle_errors {
        respond "{err.status_code} {err.status_text}"
      }

      handle {
        php_fastcgi @default unix/${config.languages.php.fpm.pools.web.socket} {
          index ${cfg.indexFile}
          trusted_proxies private_ranges
        }

        php_fastcgi @debugger unix/${config.languages.php.fpm.pools.xdebug.socket} {
          index ${cfg.indexFile}
          trusted_proxies private_ranges
        }

        file_server

        encode zstd gzip
      }

      log {
        output stderr
        format console
        level ERROR
      }
    ''
    cfg.additionalVhostConfig
  ];

  vhostConfigTls = lib.strings.concatStrings [
    ''
      tls internal
    ''
    vhostConfig
  ];

  vhostDomains = cfg.additionalServerAlias ++ [ "127.0.0.1" ];

  caddyHostConfig = (lib.mkMerge
    (lib.forEach vhostDomains (domain: {
      "http://${toString domain}:${toString cfg.httpPort}" = lib.mkDefault {
        extraConfig = vhostConfig;
      };
      "https://${toString domain}:${toString cfg.httpsPort}" = lib.mkDefault {
        extraConfig = vhostConfigTls;
      };
    }))
  );
in {
  config = lib.mkIf cfg.enable {
    services.caddy = {
      enable = lib.mkDefault true;
      config = ''
        {
          auto_https disable_redirects
          skip_install_trust
        }
      '';
      virtualHosts = caddyHostConfig;
    };
  };
}