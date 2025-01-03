extends AudioStreamPlayer2D

class_name SFX
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = PROCESS_MODE_ALWAYS

func _physics_process(delta: float) -> void:
	var master_modifier = GameManager.master_level / 100
	var new_volume = slider_to_db(GameManager.effects_level * master_modifier)
	volume_db = new_volume

func slider_to_db(slider_value: float) -> float:
	var db_value = -80 + (slider_value * 0.8)
	return db_value
