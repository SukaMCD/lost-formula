extends Node2D

@onready var label = $Label

var velocity = Vector2.ZERO
var duration = 1.0

func _ready():
	velocity = Vector2(randf_range(-50, 50), -100)  # Random horizontal spread, upward movement

func _process(delta):
	position += velocity * delta
	velocity.y += 200 * delta  # Add gravity effect
	
	duration -= delta
	if duration <= 0:
		queue_free()
	else:
		# Fade out
		label.modulate.a = duration

func set_text(text: String, color: Color = Color.RED):
	label.text = text
	label.modulate = color 