extends Node2D

class_name Laser

@onready var collector: GPUParticles2D = $Collector
@onready var beam: MeshInstance2D = $Beam
@onready var beam_hit_effect: Node2D = $BeamHitEffect

var alive_timer: float
var length = 2000
var target_rotation
var ray_length = 5000

var ray_start
var ray_end 

func _ready() -> void:
	alive_timer = Time.get_ticks_msec()
	collector.emitting = true
	var end_location = Vector2(length,0)
	beam.mesh.size = end_location
	beam.position = Vector2(length/2 + 10,0)
	beam_hit_effect.position = Vector2(length + 10,0)
	target_rotation = rotation
	await get_tree().create_timer(0.2).timeout
	beam_hit_effect.queue_free()
	queue_free()
	
func _physics_process(delta: float) -> void:
	var run_time = Time.get_ticks_msec() - alive_timer
	beam.mesh.size = Vector2(length,run_time/20)
	
