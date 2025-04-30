extends Control

@onready var karakter = $CanvasLayer2/karakter  # AnimatedSprite2D
@onready var loading_bar = $CanvasLayer/LOADING  # AnimatedSprite2D
@onready var anim_player = $CanvasLayer3/AnimationPlayer  # Sesuaikan path
@onready var fade = $ColorRect  # Pastikan ada node ini (untuk transisi hitam)

func _ready():
	# Mainkan animasi loading bar
	loading_bar.play("load")

	# Mainkan karakter jalan selama 1 detik
	karakter.play("karakter")
	await get_tree().create_timer(1.0).timeout
	karakter.play("Idle")

	# Mainkan transisi fade out
	anim_player.play("Fade_out")
	await anim_player.animation_finished

	# Ganti scene ke main menu
	get_tree().change_scene_to_file("res://main menu/main_menu.tscn")
