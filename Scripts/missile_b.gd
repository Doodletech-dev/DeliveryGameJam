extends CharacterBody2D
class_name Missile
@onready var effect_location: Node2D = $Effect_Location
@onready var timer: Timer = $Timer
@onready var explosion_collision: CollisionShape2D = $Explosion_Collision

@export var max_speed: float = 20
@export var initial_speed: float = 5
@export var acceleration: float = 0.3
@export var steering_speed: float = 5
@export var turning_delay: float = 0.3

@export var damage = 5
@export var max_explosion_radius = 200
@export var explotion_effect_size = 3
@export var trail_effect: PackedScene
@export var explosion_effect: PackedScene

var target: Vector2
var trail_instance: Node2D
var current_speed: float = initial_speed
var exploded = false

func _ready():
	trail_instance = trail_effect.instantiate()
	get_tree().get_root().add_child(trail_instance)
	
	# Match the rotation of the launcher
	rotation = deg_to_rad(-26.5)
	explosion_collision.shape.radius = 0.1
	

func _process(delta: float) -> void:
	trail_instance.global_transform = effect_location.global_transform
	
func _physics_process(delta: float) -> void:
	if(exploded):
		velocity = Vector2.ZERO
		explosion_collision.shape.radius += 20
		if(explosion_collision.shape.radius > max_explosion_radius):
			queue_free()
	else:
		# Update position and rotation
		current_speed += acceleration
		if(current_speed > max_speed):
			current_speed = max_speed
			
		var current_direction = Vector2(cos(rotation), sin(rotation))
		var new_direction = current_direction
		if(timer.wait_time - timer.time_left > turning_delay):
			
			var desired_direction = (target - position).normalized()
			var steering_force = desired_direction - current_direction
			new_direction = (current_direction + steering_force * steering_speed * delta).normalized()
			
			
		position += new_direction * current_speed
		rotation = new_direction.angle()
	
	
func cartesian_to_isometric(cartesian):
	return Vector2(cartesian.x - cartesian.y, (cartesian.x + cartesian.y) / 2)
	
func seek():
	var steer = Vector2.ZERO
	if target:
		var target_direction = (target - position).normalized()
		steer = (target_direction - velocity).normalized()
	return steer
	
func hit_detected():
	if !exploded:
		create_explosion()
		exploded = true

func _on_visible_on_screen_notifier_screen_exited() -> void:
	queue_free()

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_PREDELETE:
			on_predelete()

func on_predelete() -> void:
	if(is_instance_valid(trail_instance)):
		trail_instance.destroy()

func create_explosion():
	var explosion_instance = explosion_effect.instantiate()
	get_tree().get_root().add_child(explosion_instance)
	explosion_instance.global_transform = global_transform
	explosion_instance.scale = Vector2(explotion_effect_size,explotion_effect_size)
	explosion_instance.trigger()

func _on_timer_timeout() -> void:
	create_explosion()
	queue_free()
