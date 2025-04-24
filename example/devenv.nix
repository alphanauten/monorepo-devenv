{ pkgs, config, inputs, lib, ... }:

{
  alphanauten.additionalPhpConfig = ''
    memory_limit = 512M
  '';
}
