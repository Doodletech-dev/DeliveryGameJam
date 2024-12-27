extends CharacterBody2D

@export var speed = 800.0

func _physics_process(delta: float) -> void:
	velocity = speed * get_global_transform().basis_xform(Vector2.RIGHT)
	move_and_slide()
