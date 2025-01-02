extends Node
class_name SceneController

@onready var level_timer = $LevelTimer
@onready var level_select_screen = $LevelSelectScreen
@onready var level_3_container: VBoxContainer = $"LevelSelectScreen/MarginContainer/Level 3 Container"
@onready var level_2_container: HBoxContainer = $"LevelSelectScreen/MarginContainer/Level 2 Container"
@onready var level_1_container: VBoxContainer = $"LevelSelectScreen/MarginContainer/Level 1 Container"

@export var enemy_spawners : Array[Node2D] = []
@export var level_to_change : Array[PackedScene]
var level_to_load :String
var level_timer_time

func _ready():
	
	call_deferred("set_level_timer")
	if(enemy_spawners == null):
		printerr("No spawners connected to scene controller")
	level_select_screen.hide()
	GameManager._get_local_scene_controller(self)

func set_level_timer():
	level_timer.wait_time = (GameManager.current_level * 60)
	level_timer.start()

func _on_level_timer_timeout():
	GameManager.stop_enemy_spawners.emit(enemy_spawners)
	
func _on_level_complete():
	level_select_screen.show()
	if(GameManager.current_level == 1):
		var buttons = level_1_container.get_children()
		buttons.append_array(level_3_container.get_children())
		for button in buttons:
			if(button is Button):
				button.disabled = true
				print(button.name)
	if(GameManager.current_level == 2):
		var buttons = level_1_container.get_children()
		buttons.append_array(level_2_container.get_children())
		for button in buttons:
			if(button is Button):
				button.disabled = true
				print(button.name)


func _on_level_2_heavy_infantry_selection_pressed() -> void:
	GameManager.current_level = 2
	level_to_load = "res://Scenes/levels/level 2 infantry.tscn"
	GameManager.save_game()
	get_tree().change_scene_to_file(level_to_load)


func _on_level_2_heavy_drones_selection_pressed() -> void:
	GameManager.current_level = 2
	level_to_load = "res://Scenes/levels/level 2 drone.tscn"
	GameManager.save_game()
	get_tree().change_scene_to_file(level_to_load)

func _on_level_1_icon_pressed() -> void:
	GameManager.current_level = 1
	level_to_load = "res://Scenes/levels/level 1.tscn"
	GameManager.save_game()
	get_tree().change_scene_to_file(level_to_load)

func _on_final_level_selection_pressed() -> void:
	GameManager.current_level = 3
	level_to_load = "res://Scenes/levels/level 3 boss.tscn"
	GameManager.save_game()
	get_tree().change_scene_to_file(level_to_load)

func _on_save_game():
	var data = {}
	data["current_level"] = level_to_load
	GameManager.saver_loder._save_game(data)

func _load_saved_level():
	get_tree().change_scene_to_file(level_to_load)

func _on_load_game(data : Dictionary):
	level_to_load = data["current_level"]


func _on_button_pressed() -> void:
	if(GameManager.saver_loder._load_game()):
		call_deferred("_load_saved_level")
