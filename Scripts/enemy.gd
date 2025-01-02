extends CharacterBody2D
class_name Enemy

@export var move_speed = 700
@export var attack_distance = 500
@export var scraps_given = 1
@export var min_wait_time = 1.0
@export var max_wait_time = 1.4

@export var animation_player : AnimationPlayer
@export var bullet_scene: PackedScene
@export var damage_type := DamageTypes.type.bullet

@onready var idle_timer : Timer = $IdleTime
@onready var sprite = $Sprite2D


var target_location
var move_direction
var reactor_position

var can_fire
var can_move

var new_waypoint : Vector2

var ai_paths : Array[Path2D] = []

func _ready():
	animation_player.play("move")
	can_fire = true
	can_move = true

func _physics_process(delta):
	sprite.rotation = -get_parent().rotation
	if(can_move && target_location):
		move_direction = target_location - global_position
		move_direction = move_direction.normalized()
		if(global_position.distance_to(reactor_position) <= attack_distance && target_location == reactor_position && can_fire):
			can_fire = false
			move_direction = Vector2.ZERO
			var random_wait_time = randf_range(min_wait_time, max_wait_time)
			idle_timer.wait_time = random_wait_time
			idle_timer.start()
			_fire()
		else: if(global_position.distance_to(target_location) <= 10):
			#look_at(target_location)
			move_direction = Vector2.ZERO
			var random_wait_time = randf_range(min_wait_time, max_wait_time)
			idle_timer.wait_time = random_wait_time
			idle_timer.start()
			can_move = false
			
	velocity = move_direction * move_speed
	move_and_slide()

func _fire():
	can_move = false
	var fire_direction = reactor_position - global_position
	fire_direction.normalized()
	var bullet = bullet_scene.instantiate()
	get_parent().add_child(bullet)
	bullet.global_transform = global_transform
	bullet._set_fire_direction(fire_direction)

func _set_new_target_position():
	var choice_rng = randi_range(0,1)
	if(choice_rng == 0):
		new_waypoint = reactor_position
		animation_player.play("move_attack")
		can_fire = true
	else:
		can_fire = false
		var rng = RandomNumberGenerator.new()
		var max_rang = ai_paths.size() - 1
		var rang = rng.randi_range(0, max_rang)
		var max_random_point = ai_paths[rang].curve.point_count - 1
		var rang2 = rng.randi_range(0, max_random_point)
		var new_target_position = ai_paths[rang].curve.get_point_position(rang2)
		new_waypoint = new_target_position
		animation_player.play("move")
	return new_waypoint

func _set_reactor_position(target_pos: Vector2):
	reactor_position = target_pos
	target_location = _set_new_target_position()

func _get_ai_paths(paths : Array [Path2D]):
	ai_paths = paths

func _on_idle_time_timeout():
	target_location = _set_new_target_position()
	can_move = true
func _death():
	GameManager.update_scraps.emit(scraps_given)
	GameManager.update_enemy_count.emit(-1)
