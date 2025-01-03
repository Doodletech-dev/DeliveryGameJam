extends Node2D
@onready var button_load_game: Button = $TextureRect/HBoxContainer/Button_LoadGame
@onready var options_screen: Options = $Options_Screen

@export var intro_scene : PackedScene

func _ready() -> void:
	if(GameManager.saver_loder._has_save_file()):
		button_load_game.disabled = false
	else:
		button_load_game.disabled = true
	

func _on_button_new_game_pressed() -> void:
	GameManager.saver_loder._delete_save_game()
	GameManager.reset_game_state()
	call_deferred("_scene_change")

func _scene_change():
	get_tree().change_scene_to_packed(intro_scene)

func _on_button_exit_pressed() -> void:
	get_tree().quit()


func _on_button_audio_pressed() -> void:
	options_screen.open()
