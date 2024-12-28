extends CharacterBody2D
class_name Missile
@onready var effect_location: Node2D = $Effect_Location

@export var speed = 1000.0
@export var damage = 5
@export var trail_effect: PackedScene

var rotation_speed = 2

var start_time
var time_alive: float
var target: Vector2
var effect_instance: Node2D
var target_direction
func _ready():
	start_time = Time.get_ticks_msec()
	effect_instance = trail_effect.instantiate()
	get_tree().get_root().add_child(effect_instance)
	

	target_direction = (target - get_global_position()).normalized()
	rotation = deg_to_rad(-26.5)
	
	#rotation = get_angle_to(target)
	velocity = speed * get_global_transform().basis_xform(Vector2.RIGHT)
	#velocity = speed * cartesian_to_isometric(get_global_transform().basis_xform(Vector2.UP))

func _process(delta: float) -> void:
	time_alive = (Time.get_ticks_msec() - start_time) / 100
	effect_instance.global_transform = effect_location.global_transform
	velocity = speed * get_global_transform().basis_xform(Vector2.RIGHT)
	if(target):
		rotation = lerp_angle(rotation, get_angle_to(target), rotation_speed * delta)
	
	var target_velocity = speed * target_direction
	#velocity = lerp(velocity, target_velocity, 10 * delta)
	#if(time_alive>10):
		#velocity = speed/2 * get_global_transform().basis_xform(Vector2.RIGHT)
	move_and_slide()

func cartesian_to_isometric(cartesian):
	return Vector2(cartesian.x - cartesian.y, (cartesian.x + cartesian.y) / 2)
	

func _on_visible_on_screen_notifier_screen_exited() -> void:
	queue_free()


func _notification(what: int) -> void:
	match what:
		NOTIFICATION_PREDELETE:
			on_predelete()

func on_predelete() -> void:
	if(!effect_instance.is_queued_for_deletion()):
		effect_instance.destroy()
