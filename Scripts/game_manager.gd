extends Node

signal game_over
signal update_scraps(amount)

var current_scraps

func _ready():
	current_scraps = 0
 

func _on_game_over():
	get_tree().call_deferred("reload_current_scene")


func _on_update_scraps(amount):
	current_scraps += amount
	print("Player has " + str(current_scraps))
