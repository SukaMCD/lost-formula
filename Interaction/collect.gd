extends Area2D

var showInteractLabel = false

func _process(delta: float) -> void:
	$Label.visible = showInteractLabel
	
	if showInteractLabel && Input.is_action_just_pressed("interact"):
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body is Player: showInteractLabel = true

func _on_body_exited(body: Node2D) -> void:
	if body is Player: showInteractLabel = false
	
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("dialog"):
		DialogueManager.show_example_dialogue_balloon(load("res://addons/tanaman.dialogue"))
		return
		
