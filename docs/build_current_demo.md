# Build The Current Demo

This guide starts after the Godot project already exists, the local Git repository is initialized, and the first commit has been pushed to GitHub. The goal is to recreate the playable FPS target-range demo that exists in this repository right now.

## Starting Point

You should already have:

- A Godot project folder.
- A `project.godot` file.
- A Git repository initialized in the project folder.
- A GitHub remote named `origin`.
- A clean `main` branch synced with `origin/main`.

Check the Git state before starting:

```bash
git status
```

The output should show that there are no uncommitted changes.

## Open The Project In Godot

1. Open Godot.
2. Import or open the project by selecting `project.godot`.
3. Let Godot scan and import the project.
4. If Godot asks which renderer to use, choose **Forward+** for modern hardware or **Compatibility** for older hardware.

## Create The Project Folders

In the Godot FileSystem panel, create this structure:

```text
assets/
assets/audio/
assets/materials/
assets/models/
assets/textures/
docs/
scenes/
scenes/main/
scenes/player/
scenes/props/
scripts/
scripts/game/
scripts/player/
scripts/props/
source_assets/
source_assets/blender/
```

Folder purpose:

- `assets/` stores game-ready files Godot uses directly.
- `source_assets/` stores editable source files such as Blender `.blend` files.
- `scenes/` stores Godot scenes.
- `scripts/` stores GDScript files.
- `docs/` stores tutorial notes and workflow documentation.

## Set The Main Scene And Fullscreen Test Mode

Open **Project > Project Settings**.

Set the main scene:

1. Open the **Application > Run** settings.
2. Set **Main Scene** to `res://scenes/main/main.tscn` after that scene exists.

Set fullscreen test runs:

1. Search for `window/size/mode`.
2. Set the window mode to **Fullscreen**.

In `project.godot`, this fullscreen setting appears as:

```text
window/size/mode=3
```

Fullscreen testing is useful for FPS games because mouse capture and camera feel are easier to judge in a player-like screen mode.

## Add Input Actions

Open **Project > Project Settings > Input Map**.

Best practice: connect a controller now if controller playability is part of the goal. Add keyboard/mouse and controller bindings at the same time so both input paths stay equal.

Create these actions:

```text
move_forward
move_back
move_left
move_right
look_left
look_right
look_up
look_down
jump
fire
ui_cancel
```

Bind them like this:

```text
move_forward  W                  Left stick up
move_back     S                  Left stick down
move_left     A                  Left stick left
move_right    D                  Left stick right
look_left     Right stick left
look_right    Right stick right
look_up       Right stick up
look_down     Right stick down
jump          Space              South face button
fire          Left Mouse Button  Right trigger or right shoulder
ui_cancel     Escape             Start/Menu
```

These actions let scripts ask for game intent, such as `move_forward`, instead of checking raw keyboard keys or raw controller axes everywhere.

## Create The Player Script

Create:

```text
scripts/player/player_controller.gd
```

The player script should:

- Extend `CharacterBody3D`.
- Capture the mouse when the game starts.
- Rotate the body left and right from mouse movement.
- Rotate the camera head up and down from mouse movement.
- Rotate the camera from controller right-stick movement.
- Use `Input.get_vector()` for keyboard and controller movement.
- Apply gravity and jumping.
- Use a `RayCast3D` for hitscan firing.
- Emit a signal when a target is hit.

The current script is:

```gdscript
extends CharacterBody3D

signal target_hit

@export var move_speed := 7.0
@export var jump_velocity := 4.5
@export var mouse_sensitivity := 0.0025
@export var controller_look_sensitivity := 3.0
@export var gravity := 18.0
@export var fire_range := 60.0

@onready var head: Node3D = $Head
@onready var raycast: RayCast3D = $Head/Camera3D/FireRay

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	raycast.target_position = Vector3(0.0, 0.0, -fire_range)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(-event.relative.x * mouse_sensitivity)
		head.rotate_x(-event.relative.y * mouse_sensitivity)
		head.rotation.x = clamp(head.rotation.x, deg_to_rad(-85.0), deg_to_rad(85.0))

	if event.is_action_pressed("ui_cancel"):
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

func _physics_process(delta: float) -> void:
	_apply_controller_look(delta)

	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (global_transform.basis * Vector3(input_dir.x, 0.0, input_dir.y)).normalized()

	velocity.x = direction.x * move_speed
	velocity.z = direction.z * move_speed

	if not is_on_floor():
		velocity.y -= gravity * delta
	elif Input.is_action_just_pressed("jump"):
		velocity.y = jump_velocity

	if Input.is_action_just_pressed("fire"):
		if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			_fire()

	move_and_slide()

func _apply_controller_look(delta: float) -> void:
	var look_dir := Input.get_vector("look_left", "look_right", "look_up", "look_down")
	if look_dir.is_zero_approx():
		return

	rotate_y(-look_dir.x * controller_look_sensitivity * delta)
	head.rotate_x(-look_dir.y * controller_look_sensitivity * delta)
	head.rotation.x = clamp(head.rotation.x, deg_to_rad(-85.0), deg_to_rad(85.0))

func _fire() -> void:
	raycast.force_raycast_update()
	if not raycast.is_colliding():
		return

	var collider := raycast.get_collider()
	if collider != null and collider.has_method("take_hit"):
		if collider.take_hit():
			target_hit.emit()
```

## Create The Player Scene

Create:

```text
scenes/player/player.tscn
```

Use this node structure:

```text
Player (CharacterBody3D)
CollisionShape3D
Head (Node3D)
Camera3D
FireRay (RayCast3D)
BlasterPreview (MeshInstance3D)
```

Attach `scripts/player/player_controller.gd` to the `Player` node.

Recommended setup:

- Give `CollisionShape3D` a capsule shape.
- Put `Head` around eye height.
- Put `Camera3D` under `Head`.
- Put `FireRay` under `Camera3D` and point it forward.
- Add a small cylinder mesh as `BlasterPreview` so the player has a placeholder weapon on screen.

This scene is reusable. The main level can instance it without rebuilding the player every time.

## Create The Target Script

Create:

```text
scripts/props/target.gd
```

The target script should:

- Extend `StaticBody3D`.
- Start with an active color.
- Change color when hit.
- Return `true` only the first time it is hit.
- Return `false` for repeat hits so the score does not increase twice.

The current script is:

```gdscript
extends StaticBody3D

@export var active_color := Color(0.95, 0.2, 0.15)
@export var hit_color := Color(0.15, 0.65, 0.25)

@onready var mesh: MeshInstance3D = $MeshInstance3D

var is_hit := false

func _ready() -> void:
	_apply_color(active_color)

func take_hit() -> bool:
	if is_hit:
		return false

	is_hit = true
	_apply_color(hit_color)
	return true

func reset_target() -> void:
	is_hit = false
	_apply_color(active_color)

func _apply_color(color: Color) -> void:
	var material := StandardMaterial3D.new()
	material.albedo_color = color
	mesh.set_surface_override_material(0, material)
```

## Create The Target Scene

Create:

```text
scenes/props/target.tscn
```

Use this node structure:

```text
Target (StaticBody3D)
MeshInstance3D
CollisionShape3D
```

Attach `scripts/props/target.gd` to the `Target` node.

Recommended setup:

- Use a `BoxMesh` for `MeshInstance3D`.
- Use a matching `BoxShape3D` for `CollisionShape3D`.
- Make it thin enough to read as a target plate.

This scene is also reusable. The level can instance several targets.

## Create The Game Script

Create:

```text
scripts/game/game.gd
```

The game script should:

- Find the HUD label.
- Find the target nodes.
- Connect to the player's `target_hit` signal.
- Increase the score when a new target is hit.
- Update the HUD.

The current script is:

```gdscript
extends Node3D

@onready var hud_label: Label = $HUD/StatusLabel
@onready var targets: Array[Node] = $Targets.get_children()

var hits := 0

func _ready() -> void:
	$Player.target_hit.connect(_on_target_hit)
	_update_hud()

func _on_target_hit() -> void:
	hits += 1
	_update_hud()

func _update_hud() -> void:
	hud_label.text = "Targets: %d / %d" % [hits, targets.size()]
```

## Create The Main Scene

Create:

```text
scenes/main/main.tscn
```

Use this high-level node structure:

```text
Main (Node3D)
WorldEnvironment
DirectionalLight3D
Ground (StaticBody3D)
WorldBoundary (StaticBody3D)
Player
Targets (Node3D)
HUD (CanvasLayer)
StatusLabel (Label)
```

Attach `scripts/game/game.gd` to `Main`.

Recommended setup:

- Add a `WorldEnvironment` with a simple background color.
- Add a `DirectionalLight3D`.
- Create a large box mesh and matching collision shape for the ground.
- Instance `scenes/player/player.tscn` as `Player`.
- Create a `Targets` node and instance three copies of `scenes/props/target.tscn`.
- Position targets in front of the player.
- Add a `CanvasLayer` named `HUD`.
- Add a `Label` named `StatusLabel` under `HUD`.
- Start the label text as `Targets: 0 / 3`.

## Save And Set The Main Scene

Save all scenes and scripts.

Set the main scene if it is not already set:

1. Open **Project > Project Settings**.
2. Open **Application > Run**.
3. Set **Main Scene** to `res://scenes/main/main.tscn`.

## Playtest The Demo

Connect a controller, then press **Play**.

Check this behavior:

- `WASD` and left stick both move the player.
- Mouse movement and right stick both look around.
- `Space` and the controller south face button both jump.
- Left click, right trigger, and right shoulder can fire.
- `Esc` and Start/Menu release the mouse.
- Targets change color when hit.
- The HUD count increases only once per target.

If anything fails, stop and fix that issue before adding more features.

## Commit The Demo

Check the changed files:

```bash
git status
```

Stage the intended files:

```bash
git add project.godot scenes scripts docs assets source_assets README.md
```

Commit the playable checkpoint:

```bash
git commit -m "Add FPS tutorial starter"
```

Push it:

```bash
git push
```

This commit is the first playable vertical slice. It proves the project can open, run, move, shoot, hit targets, and display a HUD score.

## Current Demo Definition Of Done

The current demo is done when:

- The project opens in Godot.
- `scenes/main/main.tscn` runs.
- The player can move, look, jump, and shoot.
- Three targets can be hit.
- The HUD reaches `Targets: 3 / 3`.
- The work is committed and pushed to `origin/main`.
