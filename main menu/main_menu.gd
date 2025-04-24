extends Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$CanvasLayer/AnimationPlayer/ColorRect.visible = false
	# Pastikan ColorRect mengisi seluruh layar
	$CanvasLayer/AnimationPlayer/ColorRect.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)

# Fungsi yang dipanggil saat tombol 'Start' ditekan
func _on_start_pressed() -> void:
	# Aktifkan ColorRect sebelum memainkan animasi
	$CanvasLayer/AnimationPlayer/ColorRect.visible = true
	$CanvasLayer/AnimationPlayer.play("Fade_in")

func _on_button_2_pressed() -> void:
	$CanvasLayer/AnimationPlayer.play("Fade_out")
	get_tree().change_scene_to_file("res://Scenes/Player/forest.tscn")

# Fungsi yang dipanggil saat tombol 'Exit' ditekan
func _on_button_3_pressed() -> void:
	get_tree().quit()  # Keluar dari game

func _on_transition_animation_finished(anim_name: StringName) -> void:
	get_tree().change_scene_to_file("res://Scenes/Worlds/forest.tscn")
