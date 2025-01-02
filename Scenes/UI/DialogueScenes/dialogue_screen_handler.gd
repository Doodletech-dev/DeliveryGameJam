extends TextureRect

@onready var button: Button = $Button
@export var transition_scene : PackedScene


func _on_button_pressed() -> void:
	get_tree().change_scene_to_packed(transition_scene)
