extends AnimatedSprite2D

var animation_offset = 10

func _on_frame_changed() -> void:
	# Alternates between -1 and 1 for even and odd frames then multiplies by the animation offset
	var location_offset = (frame%2*2-1) * animation_offset
	for child in get_parent().get_children():
		if(child is Turret or child is Cargo):
			child.position = child.position + Vector2.DOWN * location_offset
