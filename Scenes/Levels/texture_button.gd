extends TextureButton

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("pressed", Callable(self, "_on_pressed"))

func _on_pressed() -> void:
	OS.shell_open("https://www.instagram.com/lostformula.official/")
