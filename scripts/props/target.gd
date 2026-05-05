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
