extends TextureRect

@onready var button: Button = $Button
@export var transition_scene : PackedScene
@onready var scene_controller: SceneController = $SceneController

@export var good_ending : PackedScene
@export var bad_ending : PackedScene
@onready var complete_good_ending: Button = $VBoxContainer/CompleteGoodEnding


func _ready() -> void:
	if(GameManager.current_level == 3 && GameManager.can_get_good_ending && complete_good_ending != null):
		complete_good_ending.disabled = false
	elif(GameManager.current_level == 3 && complete_good_ending != null):
		complete_good_ending.disabled = true


func _on_button_pressed() -> void:
	GameManager._swap_music()
	get_tree().change_scene_to_packed(transition_scene)
	
func _unhandled_input(event: InputEvent) -> void:
	if(event.is_action_pressed("confirm") && scene_controller != null):
		scene_controller._on_post_dialogue()


func _on_good_ending_button_pressed() -> void:
	GameManager.can_get_good_ending = true
	scene_controller._on_post_dialogue()

func _on_bad_ending_button_pressed() -> void:
	GameManager.can_get_good_ending = false
	scene_controller._on_post_dialogue()


func _on_complete_bad_ending_pressed() -> void:
	get_tree().change_scene_to_packed(bad_ending)


func _on_complete_good_ending_pressed() -> void:
	get_tree().change_scene_to_packed(good_ending)


func _on_return_to_main_menu_pressed() -> void:
	get_tree().change_scene_to_packed(transition_scene)
