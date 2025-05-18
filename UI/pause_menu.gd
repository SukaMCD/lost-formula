extends Control

func _ready():
	# Supaya node ini tetap aktif walau game paused
	process_mode = Node.PROCESS_MODE_ALWAYS
	hide()  # Sembunyikan menu saat game dimulai
	print("Pause menu initialized.")

func _input(event):
	if event.is_action_pressed("esc"):
		if get_tree().paused:
			resume()
		else:
			pause()

func pause():
	show()
	get_tree().paused = true
	print("Game paused.")
	
	# Mainkan animasi masuk (tidak looping)
	if $AnimationPlayer.has_animation("menu_paused"):
		$AnimationPlayer.play("menu_paused")

func resume():
	# Mainkan animasi keluar
	if $AnimationPlayer.has_animation("menu_unpause"):
		$AnimationPlayer.play("menu_unpause")
		await $AnimationPlayer.animation_finished
	
	get_tree().paused = false
	hide()
	print("Game resumed.")

# Dipanggil saat tombol "Resume" diklik
func _on_resume_pressed() -> void:
	print("Exit clicked.")
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main menu/main_menu.tscn")

# Dipanggil saat tombol "Exit" diklik
func _on_exit_pressed() -> void:
	get_tree().quit()  # Keluar dari game

# Dipanggil saat tombol "Load" diklik
func _on_load_pressed() -> void:
	print("Load clicked.")
	get_tree().paused = false
	get_tree().reload_current_scene()
