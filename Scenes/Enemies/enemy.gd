extends CharacterBody2D

@export var speed = 50

var player_chase = false
var player = null

@onready var sprite = $AnimatedSprite2D

func _physics_process(delta):
	if player_chase and player != null:
		var direction = (player.global_position - global_position).normalized()
		global_position += direction * speed * delta
		_play_animation(direction)
	else:
		sprite.play("Idle")

func _play_animation(direction: Vector2):
	if abs(direction.x) > abs(direction.y):
		sprite.play("Walk")
		sprite.flip_h = direction.x > 0
	elif direction.y < 0:
		sprite.play("Down")
	else:
		sprite.play("Up")

func _on_decative_body_entered(body: Node2D) -> void:
	player = body
	player_chase = true
	print("Player detected:", player.name)

func _on_decative_body_exited(body: Node2D) -> void:
	player = null
	player_chase = false
	print("Player lost!")

func enemy():
	pass
