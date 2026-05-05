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

Keep commits small and named after the behavior they add. When another person helps on the project, add them as a GitHub collaborator only if you trust them with write access and agree on a branch workflow first.

This README is the main tutorial document. Supporting files in `docs/` are optional reference notes, but the playable demo walkthrough is included below so the main GitHub page has the important build steps in one place.

## Creating A Godot Projects Folder On Linux

Before importing the project, create a folder to store Godot projects. This tutorial uses a `godot` folder inside the Linux home directory:

```bash
mkdir -p ~/godot
```

Then place or clone this repository inside that folder so the project path looks like this:

```text
~/godot/untitled
```

## Creating A Godot Projects Folder On Mac

On macOS, open **Terminal** and create the same kind of project folder in your home directory:

```bash
mkdir -p ~/godot
```

Then place or clone this repository inside that folder so the project path looks like this:

```text
~/godot/untitled
```

In Finder, the same location is:

```text
Macintosh HD/Users/<mac-user>/godot/untitled
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

## Importing The Project In Godot On Mac

Use the project folder that contains `project.godot`. If the repository is inside a `godot` folder in your macOS home directory, the Terminal path looks like this:

```text
~/godot/untitled
```

In Godot:

1. Open Godot.
2. Click **Import**.
3. Click **Browse**.
4. Navigate to your home folder, then open `godot/untitled`.
5. Select `project.godot`.
6. Click **Open**.
7. Click **Import & Edit**.

If macOS asks for file or folder permission, allow Godot to access the project folder. If Godot asks which renderer to use, choose **Forward+** for modern Apple Silicon or recent Intel Macs. Choose **Compatibility** if Forward+ has graphics issues.

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

## First Playtest

After importing the project, run the first playable scene:

1. Open Godot.
2. Open `scenes/main/main.tscn`.
3. Press **Play**.
4. Confirm that `WASD` moves the player.
5. Confirm that the mouse looks around.
6. Confirm that `Space` jumps.
7. Confirm that left click shoots.
8. Confirm that targets change color when hit.
9. Confirm that the HUD target count increases.
10. Press `Esc` to release the mouse.

If the scene runs correctly, the next tutorial step is to create the first proper FPS arena blockout and commit that work on a feature branch.

If the scene does not run, read the Godot error message and fix that before adding new features. Keeping the project playable is more important than adding more content quickly.

## Fullscreen Test Runs

This project is configured to start test runs in fullscreen by default.

The setting lives in `project.godot`:

```text
display/window/size/mode=3
```

In the Godot editor, the same setting can be changed here:

1. Open **Project**.
2. Open **Project Settings**.
3. Search for `window/size/mode`.
4. Set the window mode to **Fullscreen**.
5. Close Project Settings and press **Play** again.

Fullscreen is useful for FPS testing because mouse capture, aiming, and camera feel are easier to judge in the same screen mode a player would use.

## Build The Current Visible Demo

This section explains how the current playable FPS target-range demo was built after the Godot project was already initialized and synced with GitHub.

The demo contains:

- A fullscreen 3D test window
- A flat gray ground platform
- A blue-gray background
- A directional light
- A first-person player with collision, camera, and placeholder weapon
- Three red targets
- Targets that turn green when hit
- A HUD objective showing `Targets: 0 / 3`
- WASD movement, mouse look, jump, shooting, and mouse release

Reference diagrams:

- [Current demo top-down layout](docs/images/current_demo_topdown.svg)
- [Player node tree](docs/images/player_node_tree.svg)

### 1. Start From A Synced Project

Before building gameplay, confirm the repo is clean:

```bash
git status
```

You should be on `main`, synced with `origin/main`, with no uncommitted changes.

### 2. Create The Main Scene

Create a new 3D scene in Godot.

Root node:

```text
Main (Node3D)
```

Save it as:

```text
scenes/main/main.tscn
```

`Main` owns everything visible in the level: environment, light, ground, player, targets, and HUD.

### 3. Add The Background

Add this child node under `Main`:

```text
WorldEnvironment
```

Create a new `Environment` resource in the Inspector.

Use:

```text
Background Mode: Color
Background Color: Color(0.48, 0.56, 0.62, 1)
Ambient Light Color: Color(0.7, 0.74, 0.78, 1)
```

This gives the demo a simple blue-gray world background instead of a black empty scene.

### 4. Add The Main Light

Add this child node under `Main`:

```text
DirectionalLight3D
```

Use:

```text
Light Energy: 2.0
Position Y: 7
Rotation: angled downward toward the arena
```

This lights the floor, targets, and weapon preview.

### 5. Build The Ground

Add this child node under `Main`:

```text
Ground (StaticBody3D)
```

Add these children under `Ground`:

```text
MeshInstance3D
CollisionShape3D
```

Set `MeshInstance3D`:

```text
Mesh: BoxMesh
Size: 24, 0.25, 24
Material Albedo: Color(0.18, 0.2, 0.21, 1)
```

Set `CollisionShape3D`:

```text
Shape: BoxShape3D
Size: 24, 0.25, 24
```

The mesh is what the player sees. The collision shape is what the player stands on. They use the same size so the visible floor and physical floor match.

### 6. Add A World Boundary

Add this child node under `Main`:

```text
WorldBoundary (StaticBody3D)
```

Add:

```text
CollisionShape3D
```

Set:

```text
Shape: WorldBoundaryShape3D
```

This is invisible support collision. Later, a real level will use proper walls and boundaries.

### 7. Create The Player Scene

Create a new scene.

Root node:

```text
Player (CharacterBody3D)
```

Save it as:

```text
scenes/player/player.tscn
```

Create this node tree:

```text
Player (CharacterBody3D)
|-- CollisionShape3D
`-- Head (Node3D)
    `-- Camera3D
        |-- FireRay (RayCast3D)
        `-- BlasterPreview (MeshInstance3D)
```

Attach this script to `Player`:

```text
scripts/player/player_controller.gd
```

### 8. Give The Player A Collision Body

Select:

```text
Player/CollisionShape3D
```

Set:

```text
Shape: CapsuleShape3D
Radius: 0.35
Height: 1.8
```

The capsule is the player body. It is not meant to be seen in first person, but it lets the player stand on the ground and collide correctly.

### 9. Add The Head And Camera

Select:

```text
Player/Head
```

Set:

```text
Position: 0, 0.75, 0
```

Select:

```text
Player/Head/Camera3D
```

Set:

```text
Current: On
FOV: 75
```

The player body rotates left and right. The `Head` node rotates up and down. This is the standard simple FPS camera setup.

### 10. Add The Firing Ray

Select:

```text
Player/Head/Camera3D/FireRay
```

Set:

```text
Target Position: 0, 0, -60
```

The ray is invisible during gameplay. When the player clicks, the script checks what the ray is touching. If it touches a target, that target gets hit.

### 11. Add The Placeholder Weapon

Select:

```text
Player/Head/Camera3D/BlasterPreview
```

Set:

```text
Mesh: CylinderMesh
Top Radius: 0.08
Bottom Radius: 0.08
Height: 0.45
Position: 0.32, -0.22, -0.55
Rotation: angled forward
```

This creates the small visible blaster in the lower-right of the screen. It is temporary and should later be replaced by a Blender-made weapon model.

### 12. Add Input Actions

Open:

```text
Project > Project Settings > Input Map
```

Add:

```text
move_forward  W
move_back     S
move_left     A
move_right    D
jump          Space
fire          Left Mouse Button
ui_cancel     Escape
```

These names are used by the player script so gameplay code does not need to care about raw key codes.

### 13. Make The Player Move

The movement script reads WASD:

```gdscript
var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
var direction := (global_transform.basis * Vector3(input_dir.x, 0.0, input_dir.y)).normalized()

velocity.x = direction.x * move_speed
velocity.z = direction.z * move_speed
```

Gravity and jump:

```gdscript
if not is_on_floor():
	velocity.y -= gravity * delta
elif Input.is_action_just_pressed("jump"):
	velocity.y = jump_velocity
```

`move_and_slide()` applies the final movement.

### 14. Make Mouse Look Work

The script captures the mouse when play starts:

```gdscript
Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
```

Mouse movement turns the player:

```gdscript
rotate_y(-event.relative.x * mouse_sensitivity)
head.rotate_x(-event.relative.y * mouse_sensitivity)
head.rotation.x = clamp(head.rotation.x, deg_to_rad(-85.0), deg_to_rad(85.0))
```

Escape releases the mouse:

```gdscript
if event.is_action_pressed("ui_cancel"):
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
```

Horizontal mouse movement rotates the whole player. Vertical mouse movement rotates only the head/camera.

### 15. Create The Target Scene

Create a new scene.

Root node:

```text
Target (StaticBody3D)
```

Save it as:

```text
scenes/props/target.tscn
```

Create:

```text
Target (StaticBody3D)
|-- MeshInstance3D
`-- CollisionShape3D
```

Attach:

```text
scripts/props/target.gd
```

### 16. Make One Target Visible

Set `Target/MeshInstance3D`:

```text
Mesh: BoxMesh
Size: 1, 1, 0.25
```

Set `Target/CollisionShape3D`:

```text
Shape: BoxShape3D
Size: 1, 1, 0.25
```

The mesh makes the target visible. The collision shape lets the firing ray hit it.

### 17. Make Targets Change Color

The target starts red:

```gdscript
@export var active_color := Color(0.95, 0.2, 0.15)
```

It turns green after being hit:

```gdscript
@export var hit_color := Color(0.15, 0.65, 0.25)
```

The target only counts once:

```gdscript
func take_hit() -> bool:
	if is_hit:
		return false

	is_hit = true
	_apply_color(hit_color)
	return true
```

Returning `false` on repeat hits prevents the score from increasing multiple times on the same target.

### 18. Place Three Targets

Open:

```text
scenes/main/main.tscn
```

Add:

```text
Targets (Node3D)
```

Instance `scenes/props/target.tscn` three times under `Targets`.

Rename:

```text
TargetA
TargetB
TargetC
```

Set positions:

```text
TargetA: -5, 1.25, -4
TargetB:  0, 1.25, -7
TargetC:  5, 1.25, -4
```

Rotate `TargetA` and `TargetC` slightly inward so they face the player.

Top-down layout:

```text
                  TargetB
                    |

      TargetA       |       TargetC




                  Player
```

### 19. Instance The Player In The Main Scene

Open:

```text
scenes/main/main.tscn
```

Instance:

```text
scenes/player/player.tscn
```

Rename the instance:

```text
Player
```

Set:

```text
Position: 0, 1.2, 6
```

The camera starts from this player instance.

### 20. Add The Onscreen Objective

In `scenes/main/main.tscn`, add:

```text
HUD (CanvasLayer)
```

Under `HUD`, add:

```text
StatusLabel (Label)
```

Set:

```text
Left: 16
Top: 16
Right: 240
Bottom: 48
Font Size: 22
Text: Targets: 0 / 3
```

This creates the visible objective text in the top-left of the screen.

### 21. Make The HUD Update

Attach this script to `Main`:

```text
scripts/game/game.gd
```

It finds the HUD label:

```gdscript
@onready var hud_label: Label = $HUD/StatusLabel
```

It finds the targets:

```gdscript
@onready var targets: Array[Node] = $Targets.get_children()
```

It connects to the player hit signal:

```gdscript
$Player.target_hit.connect(_on_target_hit)
```

It updates the objective:

```gdscript
func _update_hud() -> void:
	hud_label.text = "Targets: %d / %d" % [hits, targets.size()]
```

The target handles whether it was hit. The player handles shooting. The main game script handles objective progress.

### 22. Connect Shooting To Targets

When the player clicks, `_fire()` checks the ray:

```gdscript
raycast.force_raycast_update()
if not raycast.is_colliding():
	return
```

If the ray hits something with `take_hit()`, the target is hit:

```gdscript
var collider := raycast.get_collider()
if collider != null and collider.has_method("take_hit"):
	if collider.take_hit():
		target_hit.emit()
```

The full loop is:

1. Player left clicks.
2. `FireRay` checks what is in front of the camera.
3. A target receives `take_hit()`.
4. The target turns green.
5. The player emits `target_hit`.
6. `Main` receives the signal.
7. The HUD changes from `Targets: 0 / 3` toward `Targets: 3 / 3`.

### 23. Set The Main Scene

Open:

```text
Project > Project Settings > Application > Run
```

Set:

```text
Main Scene: res://scenes/main/main.tscn
```

Now pressing **Play** starts the target range.

### 24. Test The Visible Result

Press **Play**.

Expected result:

- The game opens fullscreen.
- The mouse is captured.
- The gray arena floor is visible.
- The small weapon preview is visible in the lower-right.
- The HUD shows `Targets: 0 / 3`.
- WASD moves the player.
- Mouse movement looks around.
- Space jumps.
- Left click fires.
- Red targets turn green when hit.
- The HUD reaches `Targets: 3 / 3`.
- Escape releases the mouse.

### 25. Commit And Push The Demo

Check changes:

```bash
git status
```

Stage files:

```bash
git add project.godot scenes scripts assets source_assets README.md docs
```

Commit:

```bash
git commit -m "Add FPS tutorial starter"
```

Push:

```bash
git push
```

This saves the first playable vertical slice to GitHub.

### Screenshot Checklist

Real Godot screenshots still need to be captured manually from the editor. Save them in:

```text
docs/screenshots/
```

Capture:

| File | What To Capture |
| --- | --- |
| `01_project_filesystem.png` | Godot FileSystem with folders expanded |
| `02_input_map.png` | Project Settings > Input Map |
| `03_player_scene_tree.png` | Player scene node tree |
| `04_player_camera_weapon.png` | Camera view with weapon preview |
| `05_target_scene_tree.png` | Target scene node tree |
| `06_main_scene_tree.png` | Main scene node tree |
| `07_three_targets_editor.png` | Editor viewport showing three targets |
| `08_first_playtest.png` | Running game with HUD visible |
| `09_target_hit_green.png` | Running game after one target is hit |
| `10_all_targets_complete.png` | Running game after all targets are hit |

### Visible Objects Summary

| Thing | Node Or Script | Visible To Player | Purpose |
| --- | --- | --- | --- |
| Background color | `WorldEnvironment` | Yes | Makes the world readable |
| Light | `DirectionalLight3D` | Indirectly | Lights the arena |
| Ground | `Ground` | Yes | Gives the player a floor |
| Player collision | `CollisionShape3D` | No | Lets the player stand and move |
| Camera | `Camera3D` | Yes, through view | Provides first-person view |
| Weapon placeholder | `BlasterPreview` | Yes | Shows a temporary blaster |
| Firing ray | `FireRay` | No | Detects what the player shoots |
| Targets | `TargetA`, `TargetB`, `TargetC` | Yes | Main shooting objective |
| HUD label | `StatusLabel` | Yes | Shows target progress |
| Player script | `player_controller.gd` | Through behavior | Movement, mouse look, shooting |
| Target script | `target.gd` | Through behavior | Red-to-green hit feedback |
| Game script | `game.gd` | Through HUD | Tracks objective progress |

## Tutorial Milestones

1. Create the repo and project structure.
2. Build the first playable FPS controller.
3. Add a test arena and shootable targets.
4. Replace placeholder geometry with Blender-made assets.
5. Add sound, UI, menus, and settings.
6. Package desktop builds.
7. Prepare a Steam-ready release checklist.
