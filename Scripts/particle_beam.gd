extends Node2D

@onready var collector: GPUParticles2D = $Collector
@onready var beam: GPUParticles2D = $Beam

func _ready() -> void:
	collector.emitting = true
	beam.emitting = true
