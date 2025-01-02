extends MarginContainer

@onready var main_menu_time: Timer = $MainMenuTime
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@export var main_menu : PackedScene

var shown_team_image = false
func _ready() -> void:
	animation_player.play("splash_screen 1")
	main_menu_time.start()
	


func _on_main_menu_time_timeout() -> void:
	get_tree().change_scene_to_packed(main_menu)
