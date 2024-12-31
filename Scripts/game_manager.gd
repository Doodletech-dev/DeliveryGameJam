extends Node

signal game_over
signal stop_enemy_spawners(spawners)
signal update_enemy_count(amount)
signal update_scraps(amount)

var current_scraps
var current_level
@onready var saver_loder: SaverLoader = $SaverLoder

var can_win_level
var total_enemy_count : int

func _ready():
	can_win_level = false
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
	can_win_level = true

func _on_update_enemy_count(amount : int):
	total_enemy_count += amount
	print("Current Enemy Count is " + str(total_enemy_count))
	if(total_enemy_count <= 0 && can_win_level):
		print("Level has been won")

func save_game():
	var savable_objects = get_tree().get_nodes_in_group("savable")
	get_tree().call_group("savable", "_on_save_game")

func load_game():
	saver_loder._load_game()
