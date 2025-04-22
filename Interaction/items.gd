extends Area2D

@export var value:int = 1 

func _on_body_entered(body: Node2D) -> void:
	print(value)
	queue_free()
