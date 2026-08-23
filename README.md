# Eveningstar

Website for the Eveningstar product.

## Local Development

| Command | Purpose |
| --- | --- |
| `nix develop` | Enter the pinned development shell. |
| `nix run .#setup` | Install exact lockfile dependencies using pinned pnpm. |
| `nix run .#dev -- [Vite options]` | Start Vite and forward options such as host and port. |
| `nix run .#format` | Apply the project-pinned Biome formatter. |
| `nix run .#update-pnpm-hash` | Refresh only the Nix pnpm dependency hash using `nix-update`. |
| `nix build .#website -L` | Build the production website. |
| `nix build .#lint -L` | Run the reproducible Biome check. |
| `nix build .#e2e -L` | Run the reproducible Playwright suite. |
| `nix flake check -L` | Run the complete CI-equivalent gate. |

Run `nix run .#setup` before the development or formatting apps. These apps report the required setup command if dependencies are missing.

## VS Code

Install the recommended workspace extensions, run the `Nix: Setup dependencies` task once, then use the other `Nix:` tasks or the `Debug Eveningstar` Firefox launch configuration. The debugger auto-discovers Firefox; if needed, override `firefox.executable` in your personal VS Code settings.

## Updating dependencies

1. Update `package.json` and `pnpm-lock.yaml` from `nix develop`.
2. Run `nix run .#update-pnpm-hash`.
3. Run `nix flake check -L`.
