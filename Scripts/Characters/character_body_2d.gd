extends CharacterBody2D
class_name Player

# Movement properties
@export var speed: float = 150
@onready var sprite = $AnimatedSprite2D

# Item tracking
var collected_items: Dictionary = {}
var last_direction_x = 1
var input_enabled: bool = true

func _ready():
	add_to_group("player")
	process_mode = Node.PROCESS_MODE_PAUSABLE

func _physics_process(delta):
	if !input_enabled || get_tree().paused:
		handle_disabled_state()
		return
	
	var input_vector = get_input_vector()
	process_movement(input_vector)
	update_animation(input_vector)
	move_and_slide()

func handle_disabled_state():
	velocity = Vector2.ZERO
	sprite.play("Idle")

func get_input_vector() -> Vector2:
	return Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down").normalized()

func process_movement(input_vector: Vector2):
	velocity = input_vector * speed
	
	if input_vector.x != 0:
		last_direction_x = sign(input_vector.x)

func update_animation(input_vector: Vector2):
	if input_vector.length() > 0:
		handle_moving_animations(input_vector)
	else:
		sprite.play("Idle")
		sprite.flip_h = last_direction_x < 0

func handle_moving_animations(input_vector: Vector2):
	if input_vector.x != 0:
		sprite.play("Walk")
		sprite.flip_h = last_direction_x < 0
	elif input_vector.y < 0:
		sprite.play("Up")
		sprite.flip_h = last_direction_x < 0
	elif input_vector.y > 0:
		sprite.play("Down")
		sprite.flip_h = last_direction_x < 0

func track_item(item_id: String, quantity: int):
	if collected_items.has(item_id):
		collected_items[item_id] += quantity
	else:
		collected_items[item_id] = quantity
	print("Item terkumpul:", collected_items)

func set_input_enabled(enabled: bool):
	input_enabled = enabled
	if !enabled:
		velocity = Vector2.ZERO
		sprite.stop()

func _unhandled_input(event):
	if event.is_action_pressed("accept"):
		return
		
	if !input_enabled || get_tree().paused:
		get_viewport().set_input_as_handled()
