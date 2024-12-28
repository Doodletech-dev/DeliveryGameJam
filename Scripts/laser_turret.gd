extends Area2D

signal turret_selected

@export var bullet: PackedScene

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D


var selected: bool = false
var can_shoot: bool = true
var bullet_spawn_locations = [Vector2(100,38),Vector2(-130,38),Vector2(-123,-78),Vector2(77,-78)]
var current_spawn_location: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animated_sprite.set_frame(6)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if(selected):
		# Get angle and convert to degrees
		var angle = rad_to_deg(get_angle_to(get_global_mouse_position()))
		# Normalize the angle to a range of 0-360 degrees
		angle = angle if angle >= 0 else angle + 360
		# Determine which quadrant the angle falls into and set the animation frame
		if(angle < 90):
			current_spawn_location = bullet_spawn_locations[0]
			animated_sprite.frame = 0
		elif(angle < 180):
			current_spawn_location = bullet_spawn_locations[1]
			animated_sprite.frame = 1
		elif(angle < 270):
			current_spawn_location = bullet_spawn_locations[2]
			animated_sprite.frame = 2
		else:
			current_spawn_location = bullet_spawn_locations[3]
			animated_sprite.frame = 3
		shoot()
	else:
		animated_sprite.frame = 3
		
func shoot():
	if(Input.is_action_pressed("Shoot") and can_shoot):
		var bullet_instance = bullet.instantiate()
		bullet_instance.global_position = global_position + current_spawn_location
		bullet_instance.look_at(get_global_mouse_position())
		get_parent().add_child(bullet_instance)
		can_shoot = false
		await get_tree().create_timer(0.2).timeout
		can_shoot = true


func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if(event.is_action_pressed("Select")):
		turret_selected.emit(self)
