extends Node2D

@onready var sfx: AudioStreamPlayer2D = $SFX

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sfx.play()
	await get_tree().create_timer(0.1).timeout
	queue_free()
