extends Area2D

var showInteractLabel = false

func _process(delta: float) -> void:
	$Label.visible = showInteractLabel
	
	if showInteractLabel and Input.is_action_just_pressed("interact"):
		get_tree().change_scene_to_file("res://brewing/TestScene.tscn")  # Ganti path dengan path scene tujuan kamu

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		showInteractLabel = true

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		showInteractLabel = false
