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

For the full GitHub, SSH, repository setup, commit, push, and branch workflow, read [docs/git_workflow.md](docs/git_workflow.md).

## Creating A Godot Projects Folder On Linux

Before importing the project, create a folder to store Godot projects. This tutorial uses a `godot` folder inside the Linux home directory:

```bash
mkdir -p ~/godot
```

Then place or clone this repository inside that folder so the project path looks like this:

```text
~/godot/untitled
```

## Importing The Project In Godot On Linux

Use the project folder that contains `project.godot`. For example, if the repository is inside a `godot` folder in your Linux home directory, the path may look like this:

```text
~/godot/untitled
```

In Godot:

1. Open Godot.
2. Click **Import**.
3. Click **Browse**.
4. Navigate to the project folder.
5. Select `project.godot`.
6. Click **Open**.
7. Click **Import & Edit**.

If Godot asks which renderer to use, choose **Forward+** for modern desktop hardware. Choose **Compatibility** for older or weaker hardware.

## Importing From Windows Godot When The Project Is In WSL

If you are running the Windows version of Godot but the project files are inside WSL/Linux, paths like `~/godot/untitled` or `/home/...` may not work in Godot's file picker. Use the WSL network path instead.

The path usually follows this pattern:

```text
//wsl.localhost/Ubuntu/home/<linux-user>/godot/untitled
```

On some Windows setups, this older form may also work:

```text
//wsl$/Ubuntu/home/<linux-user>/godot/untitled
```

In Godot:

1. Click **Import**.
2. Click **Browse**.
3. Paste the WSL path into the file picker path bar.
4. Replace `<linux-user>` with your Linux username.
5. Select `project.godot`.
6. Click **Open**.
7. Click **Import & Edit**.

Use the WSL path only when Godot is running on Windows and the project is stored inside WSL.

## Tutorial Milestones

1. Create the repo and project structure.
2. Build the first playable FPS controller.
3. Add a test arena and shootable targets.
4. Replace placeholder geometry with Blender-made assets.
5. Add sound, UI, menus, and settings.
6. Package desktop builds.
7. Prepare a Steam-ready release checklist.
