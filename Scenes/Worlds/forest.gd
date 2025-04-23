extends Node2D

@onready var transition = $CanvasLayer2/AnimationPlayer

func _ready():
	$CanvasLayer2/AnimationPlayer.play("Fade_out")
