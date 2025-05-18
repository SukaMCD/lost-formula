extends Area2D

var showInteractLabel = false
var hasShownDialogue = false

func _process(delta: float) -> void:
	$Label.visible = showInteractLabel
	
	if showInteractLabel && Input.is_action_just_pressed("interact"):
		DialogueManager.show_example_dialogue_balloon(load("res://addons/daun jambu biji.dialogue"))
		$CollectSound.play()  # Gunakan nama node yg sesuai
		await get_tree().create_timer(0.5).timeout
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		showInteractLabel = true
		if not hasShownDialogue:
			DialogueManager.show_example_dialogue_balloon(load("res://addons/daun jambu biji.dialogue"))
			hasShownDialogue = true  # Supaya hanya muncul sekali

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		showInteractLabel = false
