extends Node2D

@export var enemy_scene: PackedScene
@export var spawn_points: Array[Node2D]
@export var central_enemy: Node2D

var enemies_spawned = false

func _ready():
	if central_enemy:
		# Tunggu sampai central enemy mati
		central_enemy.connect("tree_exited", _on_central_enemy_defeated)

func _on_central_enemy_defeated():
	if !enemies_spawned:
		spawn_new_enemies()
		enemies_spawned = true

func spawn_new_enemies():
	if !enemy_scene or spawn_points.is_empty():
		print("Warning: Missing enemy scene or spawn points!")
		return
		
	for spawn_point in spawn_points:
		var new_enemy = enemy_scene.instantiate()
		get_parent().add_child(new_enemy)
		new_enemy.global_position = spawn_point.global_position 