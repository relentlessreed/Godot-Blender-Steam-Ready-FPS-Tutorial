# Untitled FPS Tutorial

A small 3D FPS made in Godot as a tutorial project. The goal is not to build the biggest game possible. The goal is to learn the full production path: Git, Godot, Blender asset creation, iteration, packaging, and eventually preparing a Steam build.

## Current Game

The first playable slice is a simple target range:

- WASD movement
- Mouse look
- Space to jump
- Left click to fire
- Escape to release the mouse
- Three targets to hit in a small 3D arena

## Toolchain

- Godot 4.x for game development
- Blender for source models and asset creation
- Git for version control
- GitHub for remote backup and collaboration
- Steamworks/SteamPipe later, once the game has a real build target

## Project Layout

```text
assets/              Imported game-ready assets used by Godot
docs/                Tutorial notes and production decisions
scenes/              Godot scenes grouped by feature
scripts/             GDScript grouped by feature
source_assets/       Blender files and other editable source assets
project.godot        Godot project configuration
```

## Development Loop

1. Open the project in Godot.
2. Run the main scene.
3. Make a small change.
4. Test it in Godot.
5. Commit the working change with Git.
6. Push to GitHub.

Keep commits small and named after the behavior they add.

## Tutorial Milestones

1. Create the repo and project structure.
2. Build the first playable FPS controller.
3. Add a test arena and shootable targets.
4. Replace placeholder geometry with Blender-made assets.
5. Add sound, UI, menus, and settings.
6. Package desktop builds.
7. Prepare a Steam-ready release checklist.
