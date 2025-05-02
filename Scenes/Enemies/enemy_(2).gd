extends CharacterBody2D

var speed = 40
var player_chase = false
var player = null

func _physics_process(delta):
	if player_chase and player:
		position += (player.position - position) / speed
		get_node("AnimatedSprite2D").play("Walk")

		if player.position.x - position.x < 0:
			get_node("AnimatedSprite2D").flip_h = true
		else:
			get_node("AnimatedSprite2D").flip_h = false
	else:
		get_node("AnimatedSprite2D").play("Idle")

func _on_decative_body_entered(body: Node2D) -> void:
	player = body
	player_chase = true

func _on_decative_body_exited(body: Node2D) -> void:
	player = null
	player_chase = false
