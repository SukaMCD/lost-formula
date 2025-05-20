extends CenterContainer

@onready var tween = $Tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func muncul():
	tween.interpolate_property(self, "rect_position:y", -128, 56, 1, Tween.TRANS_ELASTIC, Tween.EASE_OUT)
	tween.start()

func _on_forest_hero_mati() -> void:
	muncul()
