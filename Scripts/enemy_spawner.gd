extends Node2D
class_name Enemy_Spawner

@export var enemy_to_spawn : Array[PackedScene] = []
@export var spawn_weight : Array[float] = []

@export var target : Node2D

@export var min_spawn_time = 3
@export var max_spawn_time = 6

@export var ai_paths : Array[Path2D] = []

@onready var spawn_timer = $SpawnTimer

var spawn_weightf
var target_position
var can_spawn

func _ready():
	can_spawn = true
	if(enemy_to_spawn.size() != spawn_weight.size()):
		printerr("Enemy to spawn and spawn weights are not equal. Please check that each spawned enemy has a weight assigned")
	
	target_position = target.global_position
	_begin_spawn_timer()
	
func _begin_spawn_timer():
	spawn_timer.wait_time = randf_range(min_spawn_time, max_spawn_time) 
	spawn_timer.start()

func _on_spawn_timer_timeout():
	if(!can_spawn):
		return
	var rng = RandomNumberGenerator.new()
	var rang = rng.randf_range(0, 1.0)
	var sum_of_weight = 0
	for i in enemy_to_spawn.size():
		spawn_weightf = spawn_weight[i] / 100
		sum_of_weight += spawn_weightf
	for i in enemy_to_spawn.size():
		if(rang < spawn_weightf):
			var enemy_spawned = enemy_to_spawn[i].instantiate()
			enemy_spawned._get_ai_paths(ai_paths)
			enemy_spawned._set_reactor_position(target_position)
			enemy_spawned.global_position = global_position
			add_child(enemy_spawned)
			_begin_spawn_timer()
			spawn_weightf = 0
			return
		rang -= spawn_weightf
	spawn_weightf = 0
	_begin_spawn_timer()
func _end_spawn():
	print("No More Spawn")
	can_spawn = false
