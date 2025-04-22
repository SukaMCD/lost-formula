extends Area2D
class_name Door

@export var destination_level_tag: String
@export var destination_Door_tag: String
@export var spawn_direction = "up"

@onready var spawn = $Spawn

# Corrected function name (was missing the 'd' in 'entered')
func _on_body_entered(body: Node2D) -> void:
	# Pengecekan yang lebih robust
	if body.is_in_group("player") or body.get_class() == "Player" or body is Player:
		print("Player entered door to: ", destination_level_tag)
