extends CharacterBody2D
class_name Missile

@export var speed = 2000.0
@export var damage = 1
var rotation_speed = 2

var start_time
var time_alive: float
var target: Vector2

func _ready():
	start_time = Time.get_ticks_msec()

func _process(delta: float) -> void:
	time_alive = (Time.get_ticks_msec() - start_time) / 100
	if(target):
		print(time_alive)
		rotation = lerp_angle(rotation, get_angle_to(target), rotation_speed * delta * time_alive)
	velocity += speed * get_global_transform().basis_xform(Vector2.RIGHT) * delta
	if(time_alive>20):
		velocity = speed/2 * get_global_transform().basis_xform(Vector2.RIGHT)
	move_and_slide()


func _on_visible_on_screen_notifier_screen_exited() -> void:
	queue_free()
