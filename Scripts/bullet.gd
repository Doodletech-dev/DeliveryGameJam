extends CharacterBody2D

@export var speed = 800.0

func _process(delta: float) -> void:
	velocity = speed * get_global_transform().basis_xform(Vector2.RIGHT)
	move_and_slide()


func _on_visible_on_screen_notifier_screen_exited() -> void:
	queue_free()
