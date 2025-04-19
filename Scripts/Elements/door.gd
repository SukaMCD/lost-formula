extends Area2D
class_name Door

@export var destination_level_tag: String
@export var destination_Door_tag: String
@export var spawn_direction = "up"

@onready var spawn = $Spawn

func _on_body_entered(body):
	# Pengecekan yang lebih robust
	if body.is_in_group("player") or body.get_class() == "Player" or body is Player:
		print("Player entered door to: ", destination_level_tag)
		NavigationManager.go_to_level(destination_level_tag, destination_Door_tag)
