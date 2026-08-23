# AGENTS

## Project

Single-page Vite/React/Three product display for the Eveningstar PCB. The page centers the interactive GLB model, uses the supplied HDR for lighting, and borrows the Merrell reference direction through Tektur/VT323 typography, kinetic text, scrolling model motion, drifting cloud fields, and a pale grid stage.

## Local Commands

- Nix development shell: `nix develop`
- Install dependencies: `nix run .#setup`
- Dev server: `nix run .#dev -- [Vite options]`
- Biome format/fix: `nix run .#format`
- Refresh the Nix pnpm dependency hash: `nix run .#update-pnpm-hash`
- Nix build: `nix build .#website -L`
- Biome check: `nix build .#lint -L`
- Browser check: `nix build .#e2e -L`
- Nix checks: `nix flake check -L`

## GitHub Actions

- `.github/workflows/ci.yml` runs Biome checks plus production build/browser render checks on pull requests and pushes to `main`.
- The same workflow uploads and deploys the GitHub Pages artifact only for pushes to `main` after checks pass.

## Assets

- PCB model variants: `public/models/eveningstar-*.glb`
- HDR environment: `public/hdr/aircraft_workshop_01_1k.hdr`
- Reference screenshots: `reference/screenshots/`

## Debugging

VS Code has a Firefox launch configuration named `Debug Eveningstar`. It starts `nix run .#dev -- --host 127.0.0.1 --port 5173 --strictPort --force --clearScreen false` through `.vscode/tasks.json`, waits for Vite on `127.0.0.1:5173`, then launches Firefox through the `firefox-devtools.vscode-firefox-debug` extension. The debugger auto-discovers Firefox; developers can override `firefox.executable` in personal settings if necessary.

## Variants

The app picks a random PCB variant on normal page loads. Use `?variant=blue`, `?variant=green`, `?variant=purple`, `?variant=red`, `?variant=yellow`, `?variant=white`, or `?variant=black` for deterministic local QA.

## Model Path Editing

`src/modelPath.ts` is intentionally structured so a user can tune the scrolling GLB path without digging through rendering code. Keep path stages clearly named and commented, especially for magnetic settle or hold moments. Prefer obvious data edits, such as repeated poses for scroll holds, over hiding motion behavior in separate timelines unless there is a strong reason.
