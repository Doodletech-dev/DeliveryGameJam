extends Node2D
@onready var smoke_trail: GPUParticles2D = $"SmokeTrail(ParticleGen)"
@onready var flame_trail: GPUParticles2D = $"FlameTrail(ParticleGen)"


# Called when the node enters the scene tree for the first time.
func destroy():
	smoke_trail.emitting = false
	flame_trail.emitting = false


func _on_smoke_trail_finished() -> void:
	queue_free()
