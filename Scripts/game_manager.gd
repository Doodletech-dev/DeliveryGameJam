extends Node

signal game_over

func _ready():
	pass


func _on_game_over():
	get_tree().call_deferred("reload_current_scene")
