extends Area2D

signal turret_selected

@export var missile: PackedScene


var selected: bool = false
var can_shoot: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(selected):
		shoot()
		
func shoot():
	if(Input.is_action_pressed("Shoot") and can_shoot):
		var missile_instance = missile.instantiate()
		missile_instance.target = get_global_mouse_position()
		missile_instance.global_transform = global_transform
		get_parent().add_child(missile_instance)
		can_shoot = false
		await get_tree().create_timer(0.5).timeout
		can_shoot = true


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if(event.is_action_pressed("Select")):
		turret_selected.emit(self)
