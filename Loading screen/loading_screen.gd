extends Control

@onready var karakter = $CanvasLayer2/karakter
@onready var loading_bar = $CanvasLayer/LOADING
@onready var anim_player = $CanvasLayer3/AnimationPlayer
@onready var fade = $ColorRect
@onready var loading_label = $CanvasLayer5/LoadingLabel  # Label teks loading

var dot_count := 0
var timer := 0.0
var interval := 0.5

func _ready():
	loading_bar.play("load")
	karakter.play("karakter")
	await get_tree().create_timer(2.0).timeout
	karakter.play("Idle")
	await get_tree().create_timer(0.5).timeout
	anim_player.play("Fade_out")
	await anim_player.animation_finished
	await get_tree().create_timer(0.8).timeout
	get_tree().change_scene_to_file("res://main menu/main_menu.tscn")

func _process(delta):
	timer += delta
	if timer >= interval:
		timer = 0.0
		dot_count = (dot_count + 1) % 4
		var dots = ".".repeat(dot_count)
		loading_label.text = "Loading" + dots
