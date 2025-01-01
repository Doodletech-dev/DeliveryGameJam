extends CharacterBody2D
class_name Bullet

@export var speed = 1500.0
@export var damage = 1
@export var damage_type := DamageTypes.type.bullet
@export var trail_effect: PackedScene

var effect_instance
var fire_direciton = Vector2.ZERO
func _ready():
	effect_instance = trail_effect.instantiate()
	get_tree().get_root().add_child(effect_instance)

func _process(delta: float) -> void:
	effect_instance.global_transform = global_transform
	if(fire_direciton != Vector2.ZERO):
		fire_direciton = fire_direciton.normalized()
		velocity = speed * fire_direciton
	else:
		velocity = speed * get_global_transform().basis_xform(Vector2.RIGHT)
	move_and_slide()

func hit_detected():
	queue_free()

func _on_visible_on_screen_notifier_screen_exited() -> void:
	queue_free()
	
func _set_fire_direction(direction : Vector2):
	fire_direciton = direction
