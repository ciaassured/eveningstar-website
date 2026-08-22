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
      packages.default = project.website;
      packages.website = project.website;
    };
}
