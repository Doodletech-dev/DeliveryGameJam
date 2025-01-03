extends Node
class_name AudioController

@onready var music: AudioStreamPlayer = $Music
@export var loopableMusic : AudioStream

func _ready():
	process_mode = PROCESS_MODE_ALWAYS

func play_main_loop_music():
	#if(music.stream.resource_name == loopableMusic.resource_name): return
	music.stream = loopableMusic
	music.play()

func _physics_process(delta: float) -> void:
	var master_modifier = GameManager.master_level / 100
	var volume_db = slider_to_db(GameManager.music_level * master_modifier)
	music.volume_db = volume_db
	
func slider_to_db(slider_value: float) -> float:
	var db_value = -80 + (slider_value * 0.8)
	return db_value
