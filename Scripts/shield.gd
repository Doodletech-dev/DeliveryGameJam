extends Node2D
@onready var sfx: AudioStreamPlayer2D = $Sfx


func play():
	sfx.play()
	
func stop():
	sfx.stop()
