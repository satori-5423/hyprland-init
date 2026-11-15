{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { nixpkgs, ... }:
    let
      system = "x86_64-linux";
      inherit (nixpkgs) lib;

      allowUnfreePredicate =
        p:
        lib.elem (lib.getName p) [
          "linux-firmware"
          "amd-ucode"
        ];
      pkgs = import nixpkgs {
        inherit system;
        config.allowUnfreePredicate = allowUnfreePredicate;
      };

      firmwareDirs = [
        "amdgpu"
        "mediatek"
        "rtl_nic"
      ];

      prefix = "ephemeral";
      title = "NixOS Ephemeral";

      mihomoConfigPath = builtins.getEnv "EPHEMERAL_MIHOMO_CONFIG";

      mihomoConfig =
        if mihomoConfigPath == "" then
          null
        else
          builtins.path {
            path = mihomoConfigPath;
            name = "mihomo-config.yaml";
          };

      geodata = pkgs.linkFarm "mihomo-geodata" [
        {
          name = "GeoIP.dat";
          path = "${pkgs.v2ray-geoip}/share/v2ray/geoip.dat";
        }
        {
          name = "GeoSite.dat";
          path = "${pkgs.v2ray-domain-list-community}/share/v2ray/geosite.dat";
        }
      ];

      flypyWords = pkgs.runCommand "flypy-words.scm" { nativeBuildInputs = [ pkgs.python3 ]; } ''
        python3 ${./tools/gen-words.py} \
          ${pkgs.rime-ice}/share/rime-data/cn_dicts/base.dict.yaml 30000 $out
      '';

      flypyScm = pkgs.writeText "flypy-user.scm" ''
        (load "${flypyWords}")
        (load "${./flypy.scm}")
      '';

      uimFep = pkgs.uim.override {
        withAnthy = false;
        withGtk = false;
        withLibnotify = false;
        withNetworking = false;
        withSqlite = false;
      };

      firmware = pkgs.runCommand "ephemeral-firmware" { } ''
        mkdir -p $out/lib/firmware
        cp -r ${
          lib.concatMapStringsSep " " (dir: "${pkgs.linux-firmware}/lib/firmware/${dir}") firmwareDirs
        } $out/lib/firmware/
      '';

      params = [
        "console=tty0"
        "systemd.gpt_auto=0"
      ];

      pacmanStub = pkgs.symlinkJoin {
        name = "pacman-unavailable";
        paths =
          map
            (
              name:
              pkgs.writeShellScriptBin name ''
                echo "$0: pacman is not available in this image, so pacstrap cannot run" >&2
                exit 1
              ''
            )
            [
              "pacman"
              "pacman-conf"
              "pacman-key"
            ];
      };

      cfg = nixpkgs.lib.nixosSystem {
        inherit system;
        modules = [
          "${nixpkgs}/nixos/modules/installer/netboot/netboot.nix"
          ({ config, ... }: {
            system.stateVersion = config.system.nixos.release;

            boot = {
              kernelParams = params;
              initrd.systemd.emergencyAccess = true;
              supportedFilesystems = [
                "btrfs"
                "vfat"
              ];
            };

            hardware = {
              cpu.amd.updateMicrocode = true;
              firmware = lib.mkForce [
                firmware
                pkgs.wireless-regdb
              ];
              bluetooth.enable = true;
            };

            nixpkgs.config.allowUnfreePredicate = allowUnfreePredicate;

            networking = {
              wireless.iwd = {
                enable = true;
                settings = {
                  General.EnableNetworkConfiguration = true;
                  Network = {
                    EnableIPv6 = true;
                    NameResolvingService = "resolvconf";
                  };
                };
              };
              dhcpcd.denyInterfaces = [ "wl*" ];
            };

            environment = {
              systemPackages = with pkgs; [
                testdisk
                ddrescue
                smartmontools
                nvme-cli
                gptfdisk
                parted
                e2fsprogs
                rsync
                (arch-install-scripts.override { pacman = pacmanStub; })
                efibootmgr
                pciutils
                usbutils
                file
                lsof
                strace
                iproute2
                iw
                curl
                tmux
                vim
                less
                zsh
                uimFep
                (writeShellScriptBin "flypy" ''
                  exec ${uimFep}/bin/uim-fep -u py-flypy "$@"
                '')
              ];
              defaultPackages = lib.mkForce [ ];
              sessionVariables.MANPAGER = "vim +MANPAGER --not-a-term -";
              sessionVariables.LIBUIM_USER_SCM_FILE = "${flypyScm}";
            };

            documentation = {
              enable = true;
              man.enable = true;
              man.cache.enable = true;
              doc.enable = false;
              info.enable = false;
              nixos.enable = false;
            };

            nix = {
              enable = true;
              settings.experimental-features = [
                "nix-command"
                "flakes"
              ];
            };

            services = {
              openssh.enable = false;
              getty.autologinUser = "root";
              kmscon = {
                enable = true;
                config = {
                  font-engine = "pango";
                  font-name = "JetBrains Mono";
                  font-size = 0;
                };
              };
            };

            fonts = {
              fontconfig.enable = true;
              packages = [
                pkgs.jetbrains-mono
                pkgs.wqy_zenhei
              ];
            };

            systemd.tmpfiles.rules = [
              "d /mnt 0755 root root -"
            ];

            systemd = {
              suppressedSystemUnits = lib.mkForce [ ];
              services = {
                "kmsconvt@".aliases = lib.mkForce [ ];
              }
              // lib.optionalAttrs (mihomoConfig != null) {
                mihomo.preStart = ''
                  cp -f ${geodata}/GeoIP.dat ${geodata}/GeoSite.dat /var/lib/private/mihomo/
                '';
              };
            };

            services.mihomo = lib.mkIf (mihomoConfig != null) {
              enable = true;
              configFile = mihomoConfig;
              tunMode = true;
            };

            i18n = {
              defaultLocale = "C.UTF-8";
              supportedLocales = [ "C.UTF-8/UTF-8" ];
            };

            users.users.root = {
              password = "";
              shell = pkgs.zsh;
            };
            programs.zsh.enable = true;
            programs.zsh.interactiveShellInit = ''
              if [[ -z ''${UIM_FEP_ACTIVE:-} ]] && [[ -t 0 ]] && [[ -t 1 ]]; then
                export UIM_FEP_ACTIVE=1
                exec flypy -e ${pkgs.zsh}/bin/zsh -l
              fi
            '';
          })
        ];
      };

      grubCfg = pkgs.writeText "grub.cfg" ''
        menuentry "${title}" --class nixos --class gnu-linux --class gnu --class os {
          search --no-floppy --set=root --file /${prefix}/initrd
          linux /${prefix}/vmlinuz init=${build.toplevel}/init ${lib.concatStringsSep " " cfg.config.boot.kernelParams}
          initrd /${prefix}/initrd
        }
      '';

      prefixFile = pkgs.writeText "prefix" "${prefix}\n";

      inherit (cfg.config.system) build;
    in
    {
      formatter.${system} = pkgs.nixfmt;

      devShells.${system}.default = pkgs.mkShell {
        packages = [
          pkgs.nixfmt
          pkgs.statix
        ];
      };

      packages.${system}.default = pkgs.linkFarm "ephemeral" [
        {
          name = "vmlinuz";
          path = "${build.kernel}/${cfg.config.system.boot.loader.kernelFile}";
        }
        {
          name = "initrd";
          path = "${build.netbootRamdisk}/initrd";
        }
        {
          name = "grub.cfg";
          path = grubCfg;
        }
        {
          name = "prefix";
          path = prefixFile;
        }
      ];
    };
}
