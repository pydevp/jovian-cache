{
  description = "Prebuilt Jovian-NixOS packages for zero-two-deck, pushed to Cachix";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    jovian-nixos = {
      url = "github:Jovian-Experiments/Jovian-NixOS/development";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    { nixpkgs, jovian-nixos, ... }:
    let
      system = "x86_64-linux";
      inherit (nixpkgs) lib;

      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfree = true; # steam, firmware blobs
        overlays = [ jovian-nixos.overlays.default ];
      };

      names = [
        "cecd"
        "dmemcg-booster"
        "galileo-mura"
        "gamescope"
        "gamescope-session"
        "gamescope-wsi"
        "holo-polkit-helpers"
        "holo-session-selection"
        "inputattach-cec-units"
        "inputplumber"
        "jovian-steam-protocol-handler"
        "jovian-stubs"
        "jovian-updater-logo-helper"
        "jupiter-dock-updater-bin"
        "jupiter-fan-control"
        "jupiter-hw-support"
        "linux-firmware-holo"
        "mangohud"
        "mesa-radeonsi"
        "mesa-radv"
        "noisetorch-ladspa"
        "pipewire"
        "powerbuttond"
        "scx-scheds"
        "steam"
        "steam-run"
        "steam-unwrapped"
        "steam_notif_daemon"
        "steamdeck-bios-fwupd"
        "steamdeck-dsp"
        "steamdeck-firmware"
        "steamdeck-hw-theme"
        "steamos-manager"
        "vpower"
        "wireplumber"
        "xdg-desktop-portal-gamescope"
        "xdg-desktop-portal-holo"
      ];

      jovian = lib.genAttrs names (n: pkgs.jovianPackages.${n});
    in
    {
      packages.${system} = jovian // {
        # `nix build` builds every package above in one go.
        default = pkgs.linkFarm "jovian-packages" (
          lib.mapAttrsToList (name: path: { inherit name path; }) jovian
        );
      };

      formatter.${system} = pkgs.nixpkgs-fmt;
    };
}
