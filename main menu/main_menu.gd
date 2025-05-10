extends Control

@onready var main_buttons: HBoxContainer = $"main buttons"
@onready var settings: Panel = $settings

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	main_buttons.visible = true
	settings.visible = false
	
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
	get_tree().change_scene_to_file("res://Assets/CUT SCENE.tscn")

# Fungsi yang dipanggil saat tombol 'Exit' ditekan
func _on_button_3_pressed() -> void:
	get_tree().quit()  # Keluar dari game

func _on_transition_animation_finished(anim_name: StringName) -> void:
	get_tree().change_scene_to_file("res://Scenes/Worlds/forest.tscn")


func _on_button_pressed() -> void:
	print("Settings pressed")
	main_buttons.visible = false
	settings.visible = true


func _on_back_settings_pressed() -> void:
	_ready()
