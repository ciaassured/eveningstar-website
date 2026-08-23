{ self, ... }:
{
  perSystem = { pkgs, ... }:
    let
      project = import ./project.nix {
        inherit pkgs;
        src = self;
      };

      requireDependencies = executable: ''
        if [[ ! -x node_modules/.bin/${executable} ]]; then
          echo "Dependencies are not installed. Run 'nix run .#setup' first." >&2
          exit 1
        fi
      '';

      setup = pkgs.writeShellApplication {
        name = "eveningstar-setup";
        runtimeInputs = [
          project.nodejs
          project.pnpm
        ];
        text = ''
          exec pnpm install --frozen-lockfile
        '';
      };

      dev = pkgs.writeShellApplication {
        name = "eveningstar-dev";
        runtimeInputs = [
          project.nodejs
          project.pnpm
        ];
        text = ''
          ${requireDependencies "vite"}
          exec pnpm run dev "$@"
        '';
      };

      format = pkgs.writeShellApplication {
        name = "eveningstar-format";
        runtimeInputs = [
          project.nodejs
          project.pnpm
        ];
        text = ''
          ${requireDependencies "biome"}
          exec pnpm run format
        '';
      };

      updatePnpmHash = pkgs.writeShellApplication {
        name = "eveningstar-update-pnpm-hash";
        runtimeInputs = [ pkgs.nix-update ];
        text = ''
          exec nix-update website --flake --version=skip --no-src
        '';
      };
    in
    {
      apps = {
        setup = {
          type = "app";
          program = "${setup}/bin/eveningstar-setup";
          meta.description = "Install exact pnpm lockfile dependencies";
        };
        dev = {
          type = "app";
          program = "${dev}/bin/eveningstar-dev";
          meta.description = "Start the Vite development server";
        };
        format = {
          type = "app";
          program = "${format}/bin/eveningstar-format";
          meta.description = "Format the project with its pinned Biome version";
        };
        update-pnpm-hash = {
          type = "app";
          program = "${updatePnpmHash}/bin/eveningstar-update-pnpm-hash";
          meta.description = "Refresh the website pnpm dependency hash";
        };
      };
    };
}
