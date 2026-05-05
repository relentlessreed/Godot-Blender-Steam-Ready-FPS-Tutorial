# Production Plan

## Game Scope

We are building a tiny 3D FPS target-range game. The finished tutorial version should be small enough for beginners to understand, but complete enough to teach a real production path.

Core loop:

1. Player enters a compact arena.
2. Player moves, jumps, aims, and fires.
3. Targets react when hit.
4. The game tracks completion.
5. The player can restart or move to another short challenge.

## Best-Practice Rules For This Repo

- Keep the game playable at the end of each major step.
- Commit only working checkpoints.
- Use clear folder ownership: scenes in `scenes/`, code in `scripts/`, Godot-ready assets in `assets/`, Blender source files in `source_assets/`.
- Prefer simple, readable Godot nodes before custom systems.
- Build placeholder gameplay first, then replace placeholders with Blender assets.
- Do not commit generated Godot cache folders such as `.godot/`.
- Keep asset source files, exported models, and imported Godot resources separate.
- If controller playability is intended, keep a controller connected while building and testing input.
- Every input tutorial step should document keyboard/mouse and controller bindings together.

## First Vertical Slice

The first vertical slice is already started:

- A main scene
- A player scene
- A reusable target scene
- FPS movement and look for keyboard/mouse and controller
- Hitscan firing through a raycast
- Basic HUD score

Definition of done:

- The game starts from `scenes/main/main.tscn`.
- The player can move, look, jump, and fire with keyboard/mouse and controller.
- The player can hit all targets.
- The repo has clear docs for what each folder is for.

## Later Steam Path

Steam should come after the game has a stable local build. The future Steam checklist will include:

- App name and store metadata
- Windows and Linux export presets
- Icon, capsule art, screenshots, and trailer
- Controller/input review
- Basic settings menu
- Save/config location review
- SteamPipe upload process
- Clean version tagging in Git
