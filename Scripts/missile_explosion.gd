extends Node2D
@onready var fire: GPUParticles2D = $Explosion_Fire
@onready var smoke: GPUParticles2D = $Explosion_Smoke

func trigger():
	fire.emitting = true
	smoke.emitting = true

func _on_explosion_smoke_finished() -> void:
	queue_free()
