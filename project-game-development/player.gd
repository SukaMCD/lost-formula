extends CharacterBody2D

@export var speed: float = 200

func _physics_process(delta):
	var input_vector = Vector2(
		Input.get_axis("left", "right"),
		Input.get_axis("up", "down")
	)

	# Normalisasi supaya diagonal nggak lebih cepat
	if input_vector.length() > 0:
		input_vector = input_vector.normalized()

	velocity = input_vector * speed

	move_and_slide()

	# (Optional) Untuk debug arah / animasi
	# if velocity.length() > 0:
	# 	print("Moving", velocity)
