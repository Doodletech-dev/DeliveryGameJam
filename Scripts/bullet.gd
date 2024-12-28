extends CharacterBody2D
class_name Bullet

@export var speed = 1500.0
@export var damage = 1
@export var trail_effect: PackedScene

var effect_instance
func _ready():
	effect_instance = trail_effect.instantiate()
	get_tree().get_root().add_child(effect_instance)

func _process(delta: float) -> void:
	effect_instance.global_transform = global_transform
	velocity = speed * get_global_transform().basis_xform(Vector2.RIGHT)
	move_and_slide()


func _on_visible_on_screen_notifier_screen_exited() -> void:
	queue_free()
