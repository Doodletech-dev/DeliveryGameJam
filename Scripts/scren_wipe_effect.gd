extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for child in get_children():
		var random_delay = randf() * 0.05
		await get_tree().create_timer(random_delay).timeout
		child.trigger()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
