extends CharacterBody2D

class_name player
@export var speed: float = 150
@onready var sprite = $AnimatedSprite2D

var last_direction_x = 1  # 1 = kanan, -1 = kiri

func _physics_process(_delta):
	var input_vector = Vector2.ZERO

	if Input.is_action_pressed("ui_right"):
		input_vector.x += 1
	if Input.is_action_pressed("ui_left"):
		input_vector.x -= 1
	if Input.is_action_pressed("ui_down"):
		input_vector.y += 1
	if Input.is_action_pressed("ui_up"):
		input_vector.y -= 1

	input_vector = input_vector.normalized()

	velocity = input_vector * speed
	move_and_slide()

	# Gerak update arah terakhir
	if input_vector.length() > 0:
		if input_vector.x != 0:
			last_direction_x = input_vector.x

		# WALK Animasi
		if input_vector.x != 0:
			sprite.play("Walk")
			# Walk default ke kiri, jadi flip kalau ke kanan
			sprite.flip_h = last_direction_x < 0
		
		elif input_vector.y < 0:
			sprite.play("Up")
			sprite.flip_h = last_direction_x > 0
		
		elif input_vector.y > 0:
			sprite.play("Down")
			sprite.flip_h = last_direction_x > 0
		
	else:
		# IDLE Animasi
		sprite.play("Idle")
		# Idle default ke kanan, jadi flip kalau ke kiri
		sprite.flip_h = last_direction_x < 0
