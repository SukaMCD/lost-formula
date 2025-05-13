extends Node2D

func show_popup(text: String) -> void:
	var popup = get_node("/root/forest/CanvasLayer/PopupPanel")  # ganti path sesuai nama node kamu
	var label = popup.get_node("PopupLabel")
	label.text = text
	popup.visible = true
	
	await get_tree().create_timer(2.0).timeout
	popup.visible = false
