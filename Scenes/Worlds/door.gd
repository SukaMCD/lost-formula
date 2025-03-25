extends Area2D

class_name Door

@export var destination_level_tag: String
@export var destination_Door_tag: String
@export var spawn_direction = "up"

@onready var spawn = $Spawn


func _on_body_entered(body):
	if body is player:
		NavigationManager.go_to_level(destination_level_tag, destination_Door_tag)
