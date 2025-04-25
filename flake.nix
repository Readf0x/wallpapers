{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }: let
    systems = [
      "aarch64-darwin"
      "aarch64-linux"
      "armv6l-linux"
      "armv7l-linux"
      "i686-linux"
      "powerpc64le-linux"
      "riscv64-linux"
      "x86_64-darwin"
      "x86_64-freebsd"
      "x86_64-linux"
    ];
    lib = nixpkgs.lib;
    perSystem = value: lib.mergeAttrsList (lib.map (system: { "${system}" = value system; }) systems);
    pkgs = nixpkgs.legacyPackages;
  in {
    packages = perSystem (sys: rec {
      default = wallpapers;
      wallpapers = pkgs.${sys}.stdenv.mkDerivation (finalAttrs: {
        pname = "wallpapers";
        version = "1";

        src = ./.;

        dontBuild = true;
        installPhase = ''
          mkdir -p $out
          cp ./*.jpg $out
        '';
        doCheck = false;  

        meta = {
          description = "meow";
          homepage = "";
        };
      });
    });
  };
}
