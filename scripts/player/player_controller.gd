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
