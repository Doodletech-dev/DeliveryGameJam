extends Node2D
@onready var fire: GPUParticles2D = $Explosion_Fire
@onready var smoke: GPUParticles2D = $Explosion_Smoke
@onready var sfx: AudioStreamPlayer2D = $SFX

var muted = false

func trigger():
	fire.emitting = true
	smoke.emitting = true
	if(!muted):
		sfx.pitch_scale = randf_range(0.2,1.0)
		sfx.play()

func _on_explosion_smoke_finished() -> void:
	queue_free()
