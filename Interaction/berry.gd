extends Area2D

var showInteractLabel = false
var hasShownDialogue = false

func _process(delta: float) -> void:
	$Label.visible = showInteractLabel
	
	if showInteractLabel && Input.is_action_just_pressed("interact"):
		DialogueManager.show_example_dialogue_balloon(load("res://addons/dialogue_manager/Berry_pop up.dialogue"))
		queue_free()

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		showInteractLabel = true
		if not hasShownDialogue:
			DialogueManager.show_example_dialogue_balloon(load("res://addons/berry.dialogue"))
			hasShownDialogue = true  # Supaya hanya muncul sekali

func _on_body_exited(body: Node2D) -> void:
	if body is Player:
		showInteractLabel = false

# OPTIONAL: jika kamu ingin pemain tetap bisa men-trigger dialog manual
func _unhandled_input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("dialog"):
		DialogueManager.show_example_dialogue_balloon(load("res://addons/berry.dialogue"))
