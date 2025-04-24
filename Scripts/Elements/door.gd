extends Area2D
class_name Door

@export var destination_level_path: String
@export var destination_Door_tag: String
@export var spawn_direction = "up"

@onready var spawn = $Spawn
@onready var fade_rect = $CanvasLayer/ColorRect
@onready var anim = $CanvasLayer/AnimationPlayer

var next_scene_path = ""

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		print("Player entered door to:  ", "res://Scenes/Worlds/Level_1.tscn")
		next_scene_path = "res://Scenes/Worlds/Level_1.tscn"
		anim.play("fade_in")

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "fade_in":
		get_tree().change_scene_to_file("res://Scenes/Worlds/Level_1.tscn")
