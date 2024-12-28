extends CharacterBody2D

@export var move_speed = 700
@export var attack_distance = 500

@export var bullet_scene: PackedScene

@onready var fire_timer = $IdleTime

var target_direction
var move_direction
var can_fire
var can_move

var new_waypoint : Vector2

var ai_paths : Array[Path2D] = []

func _ready():
	can_fire = true

func _physics_process(delta):
	if(can_fire):
		move_direction = target_direction - global_position
		move_direction = move_direction.normalized()
		if(global_position.distance_to(target_direction) <= attack_distance):
			move_direction = Vector2.ZERO
			_fire()
	else:
		if(can_move):
			move_direction = new_waypoint - global_position
			move_direction = move_direction.normalized()
			if(global_position.distance_to(new_waypoint) <= 10):
				look_at(new_waypoint)
				move_direction = Vector2.ZERO
				_reset_can_fire()
			
	velocity = move_direction * move_speed
	move_and_slide()

func _fire():
	can_move = false
	can_fire = false
	fire_timer.start()
	look_at(target_direction)
	var bullet = bullet_scene.instantiate()
	add_child(bullet)
	bullet.global_transform = global_transform
	_set_new_target_position()

func _set_new_target_position():
	var rng = RandomNumberGenerator.new()
	var max_rang = ai_paths.size() - 1
	print(max_rang)
	var rang = rng.randi_range(0, max_rang)
	var max_random_point = ai_paths[rang].curve.point_count - 1
	var rang2 = rng.randi_range(0, max_random_point)
	var new_target_position = ai_paths[rang].curve.get_point_position(rang2)
	new_waypoint = new_target_position

func _reset_can_fire():
	can_fire = true

func _set_target_position(target_pos: Vector2):
	target_direction = target_pos

func _get_ai_paths(paths : Array [Path2D]):
	ai_paths = paths

func _on_fire_rate_timeout():
	can_move = true
