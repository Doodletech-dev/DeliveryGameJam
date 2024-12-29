extends Node

signal game_over
signal stop_enemy_spawners(spawners)
signal update_scraps(amount)

var current_scraps
var current_level

func _ready():
	current_scraps = 0
	current_level = 1
 

func _on_game_over():
	get_tree().call_deferred("reload_current_scene")


func _on_update_scraps(amount):
	current_scraps += amount
	print("Player has " + str(current_scraps) + "scraps")


func _on_stop_enemy_spawners(spawners):
	for spawner in spawners:
		if(spawner is Enemy_Spawner):
			spawner._end_spawn()
	print("Stop Enemy Spawners")
