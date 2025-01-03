extends CharacterBody2D
class_name Missile
@onready var effect_location: Node2D = $Effect_Location
@onready var timer: Timer = $Timer
@onready var explosion_collision: CollisionShape2D = $Explosion_Collision
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var sfx: AudioStreamPlayer2D = $SFX

@export var seconds_alive: float = 2
@export var max_speed: float = 20
@export var initial_speed: float = 5
@export var acceleration: float = 0.3
@export var steering_speed: float = 5
@export var turning_delay: float = 0.3


@export var damage = 1
@export var damage_mod = 0.25
@export var damage_type := DamageTypes.type.missile
@export var max_explosion_radius = 200
@export var explotion_effect_size = 3
@export var trail_effect: PackedScene
@export var explosion_effect: PackedScene
@export var enemy_missle = false

var target: Vector2
var trail_instance: Node2D
var fire_direciton = Vector2.ZERO
var current_speed: float = initial_speed
var exploded = false
var never_upgraded = true



func _ready():
	sfx.play()
	timer.wait_time = seconds_alive
	timer.start()
	damage += damage * damage_mod * GameManager.missile_upgrades
	# Match the rotation of the launcher
	rotation = deg_to_rad(-26.5)
	explosion_collision.shape.radius = 0.1
	z_index = 0

func _process(delta: float) -> void:
	if(trail_instance):
		trail_instance.global_transform = effect_location.global_transform
	
func _physics_process(delta: float) -> void:
	var d_max_speed = max_speed
	var d_steering_speed = steering_speed
	if(GameManager.missile_power_purchased and never_upgraded):
		never_upgraded = false
		d_max_speed *= 2
		d_steering_speed *= 2
	if(exploded):
		velocity = Vector2.ZERO
		explosion_collision.shape.radius += 20
		if(explosion_collision.shape.radius > max_explosion_radius):
			queue_free()
	else:
		# Update position and rotation
		current_speed += acceleration
		if(current_speed > d_max_speed):
			current_speed = d_max_speed
		var current_direction = Vector2(cos(rotation), sin(rotation))
		var new_direction = current_direction
		if(seconds_alive - timer.time_left > turning_delay):
			if(!trail_instance):
				trail_instance = trail_effect.instantiate()
				get_tree().get_root().add_child(trail_instance)
			z_index = 50
			trail_instance.z_index = 49
			var desired_direction = (target - position).normalized()
			var steering_force = desired_direction - current_direction
			new_direction = (current_direction + steering_force * d_steering_speed * delta).normalized()
			
			
		position += new_direction * current_speed
		rotation = new_direction.angle()
	
func _set_fire_direction(direction : Vector2):
	target = direction
	
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
		sprite_2d.visible = false
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
	hit_detected()
	queue_free()
