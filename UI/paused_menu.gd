extends Control

@export var game_manager : GameManager

func _ready() -> void:
	hide()
	game_manager.connect("toggle_game_paused", _on_game_manager_toggle_game_paused)


func _process(delta): 
	pass

func _on_game_manager_toggle_game_paused(is_paused : bool):
	if(is_paused):
		show()
	else: 
		hide()


func _on_resume_button_pressed() -> void:
	game_manager.game_paused = false
	
	
func _on_exit_button_pressed() -> void:
	get_tree().quit()
	
