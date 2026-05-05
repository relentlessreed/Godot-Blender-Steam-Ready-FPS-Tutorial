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
