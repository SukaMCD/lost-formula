extends Button


var level_path: String = "res://Assets/CUT SCENE.tscn" 

" This is for the loading text text mentioned in the HUD.gd "
" You can leave this out "
signal loading_level

func _ready():
	connect("loading_level", Callable(get_tree().root.get_node("level_selection"), "print_loading_level"))


func _on_pressed():
	" Emitting the connected signal from the ready function "
	" And creating 1 sec wait for the label to print "
	" You can leave this out and add only line 20 "
	emit_signal("loading_level")
	await get_tree().create_timer(1).timeout
	
	get_tree().change_scene_to_file(level_path)
