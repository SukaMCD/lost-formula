extends ProgressBar

@onready var timer = $Timer
@onready var damage_bar = $Damagebar

var health = 0 : set = _set_health

func _ready():
	# Set timer properties
	timer.wait_time = 0.4
	timer.one_shot = true
	
	# Set initial properties
	damage_bar.max_value = max_value
	damage_bar.min_value = min_value
	damage_bar.value = value
	print("Healthbar ready: max_value =", max_value)

func _set_health(new_health):
	var prev_health = health
	health = min(max_value, new_health)
	
	# Update main progress bar
	value = health
	print("Health updated to:", health)
	
	# Update damage bar with delay if damaged
	if health < prev_health:
		timer.start()
	else:
		damage_bar.value = health
	
	# Handle death
	if health <= 0:
		modulate = Color(1, 0, 0, 1)  # Red tint when dead
		await get_tree().create_timer(0.5).timeout
		queue_free()

func init_health(max_hp):
	# Set max values
	max_value = max_hp
	damage_bar.max_value = max_hp
	
	# Set initial health to max
	value = max_hp
	damage_bar.value = max_hp
	health = max_hp
	
	# Make sure values are correct
	print("Healthbar initialized: Max Health =", max_hp, ", Current Health =", health)

func _on_timer_timeout() -> void:
	# Smoothly update damage bar
	var tween = create_tween()
	tween.tween_property(damage_bar, "value", health, 0.2) 