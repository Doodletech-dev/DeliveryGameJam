extends Control

class_name Options

@onready var music_slider: HSlider = $Container/Music/TextureRect/Music_Slider
@onready var effects_slider: HSlider = $Container/Effects/TextureRect/Effects_Slider
@onready var master_slider: HSlider = $Container/Master/TextureRect/Master_Slider

var music_initial
var effects_initial
var master_initial

func open():
	visible = true
	process_mode = PROCESS_MODE_ALWAYS
	music_initial = GameManager.music_level
	effects_initial = GameManager.effects_level
	master_initial = GameManager.master_level
	music_slider.value = music_initial
	effects_slider.value = effects_initial
	master_slider.value = master_initial

func _on_music_slider_value_changed(value: float) -> void:
	GameManager.music_level = music_slider.value

func _on_effects_slider_value_changed(value: float) -> void:
	GameManager.effects_level = effects_slider.value

func _on_master_slider_value_changed(value: float) -> void:
	GameManager.master_level = master_slider.value

func _on_apply_button_pressed() -> void:
	GameManager.music_level = music_slider.value
	GameManager.effects_level = effects_slider.value
	GameManager.master_level = master_slider.value
	visible = false

func _on_back_button_pressed() -> void:
	GameManager.music_level = music_initial
	GameManager.effects_level = effects_initial
	GameManager.master_level = master_initial
	visible = false
