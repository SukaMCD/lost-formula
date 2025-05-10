extends ProgressBar


@onready var timer = $Timer
@onready var damage_bar = $Damagebar


var health = 0 : set = _set_health


func _set_health(new_healt):
	var prev_health = health
	health = min(max_value, new_healt)
	value = health
	
	if health <= 0:
		queue_free()
	
	if health < prev_health:
		timer.start()
	else:
		damage_bar.value = health


func init_health(_healt):
	health = _healt
	max_value = health
	value = health
	damage_bar.max_value = health
	damage_bar.value = health

func _on_timer_timeout() -> void:
	damage_bar.value = health
