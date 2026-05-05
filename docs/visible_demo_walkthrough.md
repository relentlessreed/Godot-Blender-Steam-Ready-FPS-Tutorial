# Visible Demo Walkthrough

This guide explains every visible part of the current Godot demo and how it was built. It starts after the project already exists, has been opened in Godot, and has been synced with GitHub.

The demo contains:

- A fullscreen 3D test window.
- A flat gray ground platform.
- A sky/background color.
- A directional light.
- A first-person player with a collision body, camera, and placeholder weapon.
- Three red targets.
- Targets that turn green when hit.
- A HUD label showing `Targets: 0 / 3`.
- WASD movement, mouse look, jump, shooting, and mouse release.

## Screenshot Note

Actual Godot editor screenshots could not be captured from this environment because the Godot executable is not available on the command line here. The repo includes visual reference diagrams instead:

- [Current demo top-down layout](images/current_demo_topdown.svg)
- [Player node tree](images/player_node_tree.svg)

When creating the tutorial screenshots manually, capture these moments:

```text
01_project_filesystem.png       Godot FileSystem after folders are created
02_input_map.png                Project Settings > Input Map
03_player_scene_tree.png        Player scene node tree
04_player_camera_weapon.png     Camera view with BlasterPreview visible
05_target_scene_tree.png        Target scene node tree
06_main_scene_tree.png          Main scene node tree
07_three_targets_editor.png     Main scene viewport showing three targets
08_first_playtest.png           Running game with HUD visible
09_target_hit_green.png         Running game after one target is hit
10_all_targets_complete.png     Running game after all targets are hit
```

Save tutorial screenshots in:

```text
docs/screenshots/
```

Then link them from this document when they exist.

## The Visible Scene Layout

The current arena is intentionally simple. It is a target range, not a finished level.

Top-down layout:

```text
                  TargetB
                    |

      TargetA       |       TargetC




                  Player
```

Current positions in the main scene:

```text
Player   position:  0, 1.2,  6
TargetA  position: -5, 1.25, -4
TargetB  position:  0, 1.25, -7
TargetC  position:  5, 1.25, -4
Ground   size:     24, 0.25, 24
```

The player starts near the front of the arena and faces toward the targets. The three targets are spread left, center, and right so the player must aim around the view instead of shooting only one spot.

## Step 1: Create The Main Scene Root

Create a new 3D scene.

Rename the root node:

```text
Main
```

Node type:

```text
Node3D
```

Save it as:

```text
scenes/main/main.tscn
```

Why this exists:

`Main` is the root of the playable level. It owns the arena, player instance, target instances, lighting, environment, and HUD.

Attach this script to `Main` later:

```text
scripts/game/game.gd
```

## Step 2: Add The Background Color

Add a child node to `Main`:

```text
WorldEnvironment
```

In the Inspector:

1. Create a new `Environment` resource.
2. Set the background mode to a solid color.
3. Set the background color to a muted blue-gray.
4. Enable ambient light.
5. Use a light gray ambient color.

The current scene file stores these values:

```text
background_color = Color(0.48, 0.56, 0.62, 1)
ambient_light_color = Color(0.7, 0.74, 0.78, 1)
```

What the player sees:

The empty world behind the arena appears as a calm blue-gray color instead of black.

## Step 3: Add The Main Light

Add a child node to `Main`:

```text
DirectionalLight3D
```

Set:

```text
Light Energy: 2.0
Position Y:   7
Rotation:     angled downward toward the arena
```

Why this exists:

`DirectionalLight3D` acts like sunlight. It lights the ground, targets, and weapon preview so the scene is readable.

What the player sees:

The arena is evenly lit instead of appearing flat or dark.

## Step 4: Build The Ground

Add a child node to `Main`:

```text
Ground
```

Node type:

```text
StaticBody3D
```

Add these children under `Ground`:

```text
MeshInstance3D
CollisionShape3D
```

Set the `MeshInstance3D` mesh:

```text
BoxMesh
Size: 24, 0.25, 24
```

Set the `CollisionShape3D` shape:

```text
BoxShape3D
Size: 24, 0.25, 24
```

Give the mesh a simple material:

```text
Albedo Color: Color(0.18, 0.2, 0.21, 1)
```

Why this exists:

The visible `BoxMesh` is what the player sees. The `BoxShape3D` is what the player collides with. Both need the same size so the visible ground matches the physical ground.

What the player sees:

A flat dark-gray platform large enough to move around on.

## Step 5: Add A World Boundary

Add a child node to `Main`:

```text
WorldBoundary
```

Node type:

```text
StaticBody3D
```

Add this child:

```text
CollisionShape3D
```

Set the shape:

```text
WorldBoundaryShape3D
```

Why this exists:

This is a simple safety collision boundary. It gives the world a fallback collision plane. For a future game, this would be replaced with proper level geometry and boundaries.

What the player sees:

Nothing. This is invisible collision support.

## Step 6: Build The Player Scene

Create a new scene.

Root node:

```text
Player
```

Node type:

```text
CharacterBody3D
```

Save it as:

```text
scenes/player/player.tscn
```

Attach:

```text
scripts/player/player_controller.gd
```

Create this exact node tree:

```text
Player (CharacterBody3D)
|-- CollisionShape3D
`-- Head (Node3D)
    `-- Camera3D
        |-- FireRay (RayCast3D)
        `-- BlasterPreview (MeshInstance3D)
```

The `Camera3D` is a child of `Head`. The `FireRay` and `BlasterPreview` are children of `Camera3D`, which makes them follow the first-person view.

## Step 7: Give The Player A Body

Select:

```text
Player/CollisionShape3D
```

Set shape:

```text
CapsuleShape3D
Radius: 0.35
Height: 1.8
```

Why this exists:

The player needs collision so they do not fall through the ground. A capsule is standard for FPS controllers because it slides smoothly along floors and walls.

What the player sees:

Nothing directly. In first person, the player body is mostly invisible. The collision body controls how the camera moves through the world.

## Step 8: Add The Head And Camera

Select:

```text
Player/Head
```

Set position:

```text
Position: 0, 0.75, 0
```

Add:

```text
Camera3D
```

Set:

```text
Current: On
FOV:     75
```

Why this exists:

The `Player` node rotates left and right. The `Head` node rotates up and down. Separating them keeps FPS mouse look clean and prevents the whole body from tilting forward.

What the player sees:

The game view comes from this camera.

## Step 9: Add The Firing Ray

Add this node under `Camera3D`:

```text
FireRay
```

Node type:

```text
RayCast3D
```

Set:

```text
Target Position: 0, 0, -60
```

Why this exists:

This project uses hitscan firing. When the player clicks, the script checks what the ray is touching. If the ray touches a target, the target receives `take_hit()`.

What the player sees:

Nothing. The ray is invisible during play. The visible result is that targets turn green when hit.

## Step 10: Add The Placeholder Weapon

Add this node under `Camera3D`:

```text
BlasterPreview
```

Node type:

```text
MeshInstance3D
```

Set the mesh:

```text
CylinderMesh
Top Radius:    0.08
Bottom Radius: 0.08
Height:        0.45
```

Move it into the lower-right part of the camera view:

```text
Position: 0.32, -0.22, -0.55
Rotation: angled so it points forward
```

Why this exists:

The placeholder weapon gives the FPS view an immediate visual cue that the player can shoot. Later, this should be replaced with a proper Blender-made weapon model.

What the player sees:

A small cylinder in the lower-right of the screen, acting as a temporary blaster.

## Step 11: Make The Player Move

Create input actions in **Project > Project Settings > Input Map**:

```text
move_forward  W
move_back     S
move_left     A
move_right    D
jump          Space
fire          Left Mouse Button
ui_cancel     Escape
```

The movement is handled in:

```text
scripts/player/player_controller.gd
```

Important movement code:

```gdscript
var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
var direction := (global_transform.basis * Vector3(input_dir.x, 0.0, input_dir.y)).normalized()

velocity.x = direction.x * move_speed
velocity.z = direction.z * move_speed
```

What this does:

- `Input.get_vector()` reads WASD as a 2D direction.
- `global_transform.basis` converts that direction into the player's facing direction.
- `velocity.x` and `velocity.z` move the character across the ground.

Jump and gravity:

```gdscript
if not is_on_floor():
	velocity.y -= gravity * delta
elif Input.is_action_just_pressed("jump"):
	velocity.y = jump_velocity
```

What this does:

- If the player is in the air, gravity pulls them down.
- If the player is on the floor and presses Space, they jump.

## Step 12: Make Mouse Look Work

The script captures the mouse when play starts:

```gdscript
Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
```

Mouse movement rotates the player and camera head:

```gdscript
rotate_y(-event.relative.x * mouse_sensitivity)
head.rotate_x(-event.relative.y * mouse_sensitivity)
head.rotation.x = clamp(head.rotation.x, deg_to_rad(-85.0), deg_to_rad(85.0))
```

What this does:

- Horizontal mouse movement rotates the whole player body.
- Vertical mouse movement rotates only the head.
- `clamp()` prevents the camera from rotating too far up or down.

Escape releases the mouse:

```gdscript
if event.is_action_pressed("ui_cancel"):
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
```

Left click captures the mouse again if it was released.

## Step 13: Build The Target Scene

Create a new scene.

Root node:

```text
Target
```

Node type:

```text
StaticBody3D
```

Save it as:

```text
scenes/props/target.tscn
```

Attach:

```text
scripts/props/target.gd
```

Create this node tree:

```text
Target (StaticBody3D)
|-- MeshInstance3D
`-- CollisionShape3D
```

## Step 14: Make One Target Visible

Select:

```text
Target/MeshInstance3D
```

Set mesh:

```text
BoxMesh
Size: 1, 1, 0.25
```

Select:

```text
Target/CollisionShape3D
```

Set shape:

```text
BoxShape3D
Size: 1, 1, 0.25
```

Why this exists:

The target is a simple rectangular plate. The mesh makes it visible. The collision shape lets the raycast hit it.

What the player sees:

A red square target. When hit, it turns green.

## Step 15: Make Targets Change Color

The target starts red:

```gdscript
@export var active_color := Color(0.95, 0.2, 0.15)
```

The target turns green when hit:

```gdscript
@export var hit_color := Color(0.15, 0.65, 0.25)
```

The hit function:

```gdscript
func take_hit() -> bool:
	if is_hit:
		return false

	is_hit = true
	_apply_color(hit_color)
	return true
```

Why this returns `bool`:

The player script only increases the score when `take_hit()` returns `true`. Shooting the same target again returns `false`, so the score does not count the same target twice.

## Step 16: Place Three Targets In The Main Scene

Open:

```text
scenes/main/main.tscn
```

Create a child node:

```text
Targets
```

Node type:

```text
Node3D
```

Instance `scenes/props/target.tscn` three times under `Targets`.

Rename them:

```text
TargetA
TargetB
TargetC
```

Set their transforms:

```text
TargetA position: -5, 1.25, -4
TargetB position:  0, 1.25, -7
TargetC position:  5, 1.25, -4
```

Rotate the side targets slightly toward the player:

```text
TargetA: rotate about Y so it faces inward
TargetC: rotate about Y so it faces inward
```

Why there are three targets:

Three targets are enough to prove the core loop: aim, shoot, get feedback, update objective progress, and finish a small challenge.

What the player sees:

Three red target plates spread across the arena.

## Step 17: Instance The Player In The Main Scene

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

Set position:

```text
0, 1.2, 6
```

Why this exists:

The player scene is built once and instanced into the level. This is a standard Godot workflow: reusable scenes become building blocks.

What the player sees:

The game camera starts from this player instance.

## Step 18: Add The Onscreen Objective HUD

In `scenes/main/main.tscn`, add:

```text
HUD
```

Node type:

```text
CanvasLayer
```

Under `HUD`, add:

```text
StatusLabel
```

Node type:

```text
Label
```

Set the label rectangle:

```text
Left:   16
Top:    16
Right:  240
Bottom: 48
```

Set font size:

```text
22
```

Set starting text:

```text
Targets: 0 / 3
```

Why this exists:

The HUD tells the player what the objective is and shows progress. Without it, the player can shoot targets but has no clear completion feedback.

What the player sees:

Text in the top-left corner of the screen.

## Step 19: Make The HUD Update

Attach this script to `Main`:

```text
scripts/game/game.gd
```

The script finds the label and targets:

```gdscript
@onready var hud_label: Label = $HUD/StatusLabel
@onready var targets: Array[Node] = $Targets.get_children()
```

The script connects to the player:

```gdscript
$Player.target_hit.connect(_on_target_hit)
```

When a target is hit, the score increases:

```gdscript
func _on_target_hit() -> void:
	hits += 1
	_update_hud()
```

The HUD text is rebuilt:

```gdscript
func _update_hud() -> void:
	hud_label.text = "Targets: %d / %d" % [hits, targets.size()]
```

Why this exists:

The target only knows it was hit. The player only knows it shot something. The `Main` game script owns the overall objective progress.

## Step 20: Make Shooting Connect To Targets

The player fires from:

```text
Player/Head/Camera3D/FireRay
```

On left click, `_fire()` runs:

```gdscript
raycast.force_raycast_update()
if not raycast.is_colliding():
	return
```

If the ray is touching a collider, the script checks for `take_hit()`:

```gdscript
var collider := raycast.get_collider()
if collider != null and collider.has_method("take_hit"):
	if collider.take_hit():
		target_hit.emit()
```

What happens in order:

1. Player left clicks.
2. The raycast checks what is in front of the camera.
3. If the ray hits a target, the target turns green.
4. The target returns `true`.
5. The player emits `target_hit`.
6. The main script receives the signal.
7. The HUD count increases.

This is the complete shoot-target-score loop.

## Step 21: Set The Main Scene

Open:

```text
Project > Project Settings > Application > Run
```

Set:

```text
Main Scene: res://scenes/main/main.tscn
```

Why this exists:

When the player presses **Play**, Godot needs to know which scene starts the game.

## Step 22: Test The Visible Result

Press **Play**.

Expected result:

- The game opens fullscreen.
- The mouse is captured.
- You see the gray arena floor.
- You see the small weapon preview in the lower-right view.
- You see `Targets: 0 / 3` in the top-left.
- You can look around with the mouse.
- You can move with WASD.
- You can jump with Space.
- You can shoot with left click.
- Red targets turn green when hit.
- The HUD changes to `Targets: 1 / 3`, then `2 / 3`, then `3 / 3`.
- Pressing Escape releases the mouse.

## Step 23: Commit The Finished Demo

Check what changed:

```bash
git status
```

Review changes when needed:

```bash
git diff
```

Stage the project files:

```bash
git add project.godot scenes scripts docs assets source_assets README.md
```

Commit the playable demo:

```bash
git commit -m "Add FPS tutorial starter"
```

Push to GitHub:

```bash
git push
```

Why this matters:

This saves a working version of the game. If a future change breaks movement, shooting, or the HUD, this commit is the clean checkpoint to compare against.

## What To Screenshot For The Tutorial

When capturing real screenshots from Godot, use this checklist:

| File | What To Capture | Why It Matters |
| --- | --- | --- |
| `01_project_filesystem.png` | Godot FileSystem with folders expanded | Shows project organization |
| `02_input_map.png` | Input Map actions | Shows control setup |
| `03_player_scene_tree.png` | Player scene tree | Shows the FPS character structure |
| `04_player_inspector.png` | Player collision/head/camera values | Shows exact player setup |
| `05_target_scene_tree.png` | Target scene tree | Shows how one target is built |
| `06_target_inspector.png` | Target mesh/collision values | Shows visible target dimensions |
| `07_main_scene_tree.png` | Main scene tree | Shows all level objects |
| `08_three_targets_editor.png` | Editor viewport with three targets | Shows target placement |
| `09_first_playtest.png` | Running game before shooting | Shows HUD and starting view |
| `10_target_hit_green.png` | Running game after one hit | Shows target feedback |
| `11_all_targets_complete.png` | Running game with `Targets: 3 / 3` | Shows completion state |

Store them in:

```text
docs/screenshots/
```

After screenshots exist, update this guide to embed them with Markdown:

```markdown
![Player scene tree](screenshots/03_player_scene_tree.png)
```

## Current Visible Objects Summary

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
