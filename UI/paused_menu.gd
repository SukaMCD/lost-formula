extends Control

# Node references
@onready var pause_button = get_node_or_null("CanvasLayer/TouchScreenButtonButton")

func _ready():
	if pause_button:
		pause_button.pressed.connect(_on_touch_screen_button_pressed)
		print("TouchScreenButton ditentukan.")
	else:
		print("ERROR: TouchScreenButton tidak ditentukan!")
	
	hide()  # Hide the pause menu when the game starts
	process_mode = Node.PROCESS_MODE_ALWAYS  # Ensure input is processed even when paused

	# Debugging: Verify that the pause menu is initialized correctly
	print("Pause menu initialized")

func resume():
	hide()  # Hide the pause menu
	$AnimationPlayer.play("menu_paused", -1, -1, true)  # Play blur animation (looping)
	await $AnimationPlayer.animation_finished  # Wait for the animation to finish
	get_tree().paused = false  # Unpause the game
	print("Game resumed")  # Debugging

func pause():
	show()  # Show the pause menu
	get_tree().paused = true  # Pause the game
	$AnimationPlayer.play("menu_paused")  # Play blur animation
	print("Game paused")  # Debugging

func _input(event):
	if event.is_action_pressed("esc"):  # Default action for Escape key
		if get_tree().paused:
			resume()
		else:
			pause()

func _on_touch_screen_button_pressed():
	if get_tree().paused:
		resume()
	else:
		pause()

func _on_resume_pressed() -> void:
	print("Resume clicked")  # Debugging
	resume()


func _on_exit_pressed() -> void:
	print("Quit clicked")  # Debugging
	get_tree().paused = false  # Unpause the game
	get_tree().change_scene_to_file("res://main_menu.tscn") 

func _on_load_pressed() -> void:
	print("Restart clicked")  # Debugging
	get_tree().paused = false  # Unpause the game
	get_tree().reload_current_scene()  # Reload the current scene


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/paused_menu.tscn") 
