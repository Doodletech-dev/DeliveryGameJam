extends Node

signal game_over
signal stop_enemy_spawners(spawners)
signal update_enemy_count(amount)
signal update_scraps(amount)

var current_scraps
var current_level
var scene_controller : SceneController
@onready var saver_loder: SaverLoader = $SaverLoder
var can_win_level
var total_enemy_count : int

func _ready():
	if(saver_loder._load_game()):
		print("Current level is " + str(current_level))
	else:
		current_scraps = 0
		current_level = 1
	can_win_level = false
	print("Current Scrap Count is " + str(current_scraps))

func _on_game_over():
	_reset_level()
	saver_loder._delete_save_game()
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
		scene_controller._on_level_complete()
		
func _get_local_scene_controller(controller : SceneController):
	scene_controller = controller
		
func _reset_level():
	total_enemy_count = 0

func save_game():
	var savable_objects = get_tree().get_nodes_in_group("savable")
	get_tree().call_group("savable", "_on_save_game")
	_on_save_game()

func load_game():
	saver_loder._load_game()

func _on_save_game():
	var data = {}
	data["current_scrap_count"] = current_scraps
	data["current_level_reached"] = current_level
	saver_loder._save_game(data)

func _on_load_game(data : Dictionary):
	current_scraps = data["current_scrap_count"]
	current_level = data["current_level_reached"]
