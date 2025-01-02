extends Node

@export var dialogue_text : Array[String] = []
@onready var label: Label = $MarginContainer/VBoxContainer/Label

@export var transition_scene : PackedScene

var max_dialogue_count
var current_dialogue_count

func _ready() -> void:
	label.text = dialogue_text[0]
	current_dialogue_count = 0
	max_dialogue_count = dialogue_text.size() -1
	
func _unhandled_input(event: InputEvent) -> void:
	if(event.is_action_pressed("confirm")):
		change_dialogue()

func change_dialogue():
	current_dialogue_count += 1
	if(current_dialogue_count > max_dialogue_count):
		get_tree().change_scene_to_packed(transition_scene)
	else:
		label.text = dialogue_text[current_dialogue_count]
	
