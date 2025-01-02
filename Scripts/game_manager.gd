extends Node

@export var level_1 : PackedScene

signal game_over
signal stop_enemy_spawners(spawners)
signal update_enemy_count(amount)
signal update_scraps(amount)

var game_UI : GameUI
var current_scraps
var current_level
var current_health

var progress_bar_amount : float
var max_time : float
var current_time : float
@onready var progress_bar_calculation: Timer = $ProgressBarCalculation

## For upgrade cards
var turret_upgrades = 0
var missile_upgrades = 0
var laser_upgrades = 0
var walker_upgrades = 0

## For calldown cards
var shield_purchased
var repair_purchased
var missile_power_purchased
var screen_wipe_purchased
var repairing: bool = false

var scene_controller : SceneController
@onready var saver_loder: SaverLoader = $SaverLoder
var can_win_level
var total_enemy_count : int

var can_get_good_ending

func _ready():
	if(saver_loder._load_game()):
		print("Current level is " + str(current_level))
	else:
		current_scraps = 0
		current_health = 100
		current_level = 1
	can_win_level = false
	current_scraps = 0
	current_level = 1
	can_get_good_ending = false
 
	print("Current Scrap Count is " + str(current_scraps))

func _on_game_over():
	_reset_level()
	saver_loder._delete_save_game()
	print("call reset level")
	call_deferred("level_reset")

func level_reset():
	get_tree().change_scene_to_packed(level_1)
	print("reset level")

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
	max_time = current_level * 60
	current_time = 0
	progress_bar_calculation.start()
		
func _reset_level():
	total_enemy_count = 0

func save_game():
	var savable_objects = get_tree().get_nodes_in_group("savable")
	get_tree().call_group("savable", "_on_save_game")
	print("Number of savable objects" + str(savable_objects))
	_on_save_game()

func load_game():
	saver_loder._load_game()

func _on_save_game():
	var data = {}
	data["current_scrap_count"] = current_scraps
	data["current_level_reached"] = current_level
	data["turret_upgrades"] = turret_upgrades
	data["missile_upgrades"] = missile_upgrades
	data["laser_upgrades"] = laser_upgrades
	data["walker_upgrades"] = walker_upgrades
	data["ending"] = can_get_good_ending
	saver_loder._save_game(data)

func _on_load_game(data : Dictionary):
	current_scraps = data["current_scrap_count"]
	current_level = data["current_level_reached"]
	turret_upgrades = data["turret_upgrades"]
	missile_upgrades = data["missile_upgrades"] 
	laser_upgrades = data["laser_upgrades"]
	walker_upgrades = data["walker_upgrades"]
	can_get_good_ending = data["ending"]


func _on_progress_bar_calculation_timeout() -> void:
	current_time += 1
	progress_bar_amount = (current_time / max_time) * 100
	progress_bar_amount = ceilf(progress_bar_amount)
	if(game_UI == null ): return
	game_UI.update_progress_bar()
	print("Level Progress is " + str(progress_bar_amount))
	
func _get_game_overlay(ui : GameUI):
	game_UI = ui
