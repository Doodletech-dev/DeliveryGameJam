extends CharacterBody2D

@export var move_speed = 700

func _physics_process(delta):
	velocity = move_speed * get_global_transform().basis_xform(Vector2.LEFT)
	move_and_slide()
