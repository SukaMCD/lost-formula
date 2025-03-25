extends Node

const scene_World_percobaan = preload("res://Scenes/Worlds/World_percobaan.tscn")
const scene_desa = preload("res://Scenes/Worlds/desa.tscn")

var spawn_door_tag

func go_to_level(level_tag, destination_tag):
	var scene_to_load
	
	match level_tag:
		"World_percobaan":
			scene_to_load = scene_World_percobaan
		"desa":
			scene_to_load = scene_desa
			
			if scene_to_load != null:
				spawn_door_tag = destination_tag
				get_tree().change_scene_to_packed(scene_to_load)
