extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CanvasLayer/AnimationPlayer/ColorRect.visible = false
	# Inisialisasi atau setup apa pun
	pass

# Called every frame. '_delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	# Jika tidak digunakan, biarkan kosong
	pass

# Fungsi yang dipanggil saat tombol 'Start' ditekan
func _on_start_pressed() -> void:
	$CanvasLayer/AnimationPlayer.play("Fade_in") 

func _on_button_2_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/Player/forest.tscn")

# Fungsi yang dipanggil saat tombol 'Exit' ditekan
func _on_button_3_pressed() -> void:
	get_tree().quit()  # Keluar dari game

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	get_tree().change_scene_to_file("res://Scenes/Worlds/forest.tscn")
