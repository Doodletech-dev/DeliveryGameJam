extends Node
class_name AudioController

@onready var music: AudioStreamPlayer = $Music
@export var loopableMusic : AudioStream

func play_main_loop_music():
	#if(music.stream.resource_name == loopableMusic.resource_name): return
	music.stream = loopableMusic
	music.volume_db = -20
	music.play()
