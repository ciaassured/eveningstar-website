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
      checks = {
        build = project.website;
        inherit (project) e2e lint;
      };
    };
}
