extends Area2D
class_name Collectible

@export var item_id: String = "item_generic"
@export var quantity: int = 1
@export var interaction_text: String = "[E] Ambil"

@onready var interaction_label = $CanvasLayer/InteractionLabel
@onready var detection_timer = $DetectionTimer
@onready var collect_sound = $CollectSound  # AudioStreamPlayer

var player_in_range: bool = false

func _ready():
	if interaction_label:
		interaction_label.visible = false
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)
	detection_timer.timeout.connect(_update_interaction_status)  # <- Ini bener

func _process(_delta):
	if player_in_range && Input.is_action_just_pressed("interact"):
		collect()

func _on_body_entered(body: Node):
	if body.is_in_group("player"):
		if interaction_label:
			interaction_label.text = interaction_text
			interaction_label.visible = true
		detection_timer.start()

func _on_body_exited(body: Node):
	if body.is_in_group("player"):
		if interaction_label:
			interaction_label.visible = false
		detection_timer.stop()
		player_in_range = false

func _update_interaction_status():  # <- PERHATIKAN "interaction" (dengan "t")
	# Cek apakah player masih di area
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("player"):
			player_in_range = true
			return
	
	player_in_range = false
	if interaction_label:
		interaction_label.visible = false

func collect():
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.track_item(item_id, quantity)
	
	# Mainkan suara sebelum menghilang
	if collect_sound:
		collect_sound.play()
	
	# Animasi hilang (langsung tanpa await)
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2.ZERO, 0.2)
	tween.tween_callback(queue_free)  # Pastikan ini terpanggil
	
	print("Collected:", item_id, " x", quantity)
