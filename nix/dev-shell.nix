{ self, ... }:
{
  perSystem = { pkgs, ... }:
    let
      project = import ./project.nix {
        inherit pkgs;
        src = self;
      };
    in
    {
      devShells.default = pkgs.mkShell {
        packages = [
          project.nodejs
          project.pnpm
          project.playwrightBrowsers
        ];
        PLAYWRIGHT_BROWSERS_PATH = project.playwrightBrowsers;
        PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
      };
    };
}
