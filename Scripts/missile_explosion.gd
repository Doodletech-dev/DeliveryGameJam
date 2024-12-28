extends Node2D

func _on_explosion_smoke_finished() -> void:
	queue_free()
