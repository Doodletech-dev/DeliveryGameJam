extends Node2D

class_name Laser

@onready var collector: GPUParticles2D = $Collector
@onready var beam: MeshInstance2D = $Beam

var alive_timer: float
var length = 2000
var target_rotation

func _ready() -> void:
	alive_timer = Time.get_ticks_msec()
	collector.emitting = true
	beam.mesh.size = Vector2(length,0)
	beam.position = Vector2(length/2 + 10,0)
	target_rotation = rotation
	collector.rotation = deg_to_rad(-26.5) - target_rotation
	await get_tree().create_timer(0.3).timeout
	queue_free()
	
func _physics_process(delta: float) -> void:
	var run_time = Time.get_ticks_msec() - alive_timer
	#beam.rotation = target_rotation
	beam.mesh.size = Vector2(length,run_time/50)
