{ pkgs, src }:
let
  nodejs = pkgs.nodejs_22;
  pnpm = pkgs.pnpm_11.override {
    nodejs-slim = pkgs.nodejs-slim_22;
    version = "11.9.0";
    hash = "sha256-K1Z6pmAmI4B4rC4KM77D/r1g6WKYeqxpdFbzGAgZsoc=";
  };

  pnpmDeps = pkgs.fetchPnpmDeps {
    pname = "eveningstar-website";
    version = "0.0.0";
    inherit src pnpm;
    fetcherVersion = 4;
    pnpmInstallFlags = [ "--no-force" ];
    hash = "sha256-n7rDmvhwxljO8Gk38RLRBGzW5f2RRig/wyhcAGWC84M=";
  };

  playwrightBrowsers = pkgs.playwright-driver.selectBrowsers {
    withChromium = false;
    withChromiumHeadlessShell = true;
    withFirefox = false;
    withWebkit = false;
    withFfmpeg = false;
  };

  common = {
    inherit src pnpmDeps;
    nativeBuildInputs = [
      nodejs
      pnpm
      pkgs.pnpmConfigHook
    ];
  };

  website = pkgs.stdenvNoCC.mkDerivation (
    common
    // {
      pname = "eveningstar-website";
      version = "0.0.0";

      buildPhase = ''
        runHook preBuild
        pnpm build
        runHook postBuild
      '';

      installPhase = ''
        runHook preInstall
        cp -r dist "$out"
        runHook postInstall
      '';
    }
  );

  lint = pkgs.stdenvNoCC.mkDerivation (
    common
    // {
      pname = "eveningstar-website-lint";
      version = "0.0.0";
      nativeBuildInputs = common.nativeBuildInputs ++ [ pkgs.autoPatchelfHook ];
      buildInputs = [ pkgs.stdenv.cc.cc.lib ];

      preBuild = ''
        autoPatchelf node_modules/.pnpm/@biomejs+cli-linux-x64@2.5.1/node_modules/@biomejs/cli-linux-x64
      '';

      buildPhase = ''
        runHook preBuild
        pnpm lint
        runHook postBuild
      '';

      installPhase = ''
        touch "$out"
      '';
    }
  );

  e2e = pkgs.stdenvNoCC.mkDerivation (
    common
    // {
      pname = "eveningstar-website-e2e";
      version = "0.0.0";
      nativeBuildInputs = common.nativeBuildInputs ++ [ playwrightBrowsers ];
      PLAYWRIGHT_BROWSERS_PATH = playwrightBrowsers;
      PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS = "true";
      CI = "true";

      buildPhase = ''
        runHook preBuild
        ln -s ${website} dist
        pnpm test:e2e
        runHook postBuild
      '';

      installPhase = ''
        touch "$out"
      '';
    }
  );
in
{
  inherit
    e2e
    lint
    nodejs
    playwrightBrowsers
    pnpm
    website
    ;
}
