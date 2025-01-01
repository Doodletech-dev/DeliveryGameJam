extends Turret

signal turret_selected

@export var ray_length:int = 5000
@export var bullet: PackedScene
@export var laser_hit_effect: PackedScene

@onready var sprite: AnimatedSprite2D = $Sprite
@onready var outline: AnimatedSprite2D = $Outline


var selected: bool = false
var can_shoot: bool = true
var bullet_spawn_locations = [Vector2(24,25),Vector2(-24,25),Vector2(-20,1),Vector2(20,1)]
var current_spawn_location: Vector2
var wants_shoot: bool = false
var space_state

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.frame = 3
	outline.frame = 3

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(selected):
		# Get angle and convert to degrees
		var angle = rad_to_deg(get_angle_to(get_global_mouse_position()))
		# Normalize the angle to a range of 0-360 degrees
		angle = angle if angle >= 0 else angle + 360
		# Determine which quadrant the angle falls into and set the animation frame
		if(angle < 90):
			current_spawn_location = bullet_spawn_locations[0] * 5
			sprite.frame = 0
			outline.frame = 0
		elif(angle < 180):
			current_spawn_location = bullet_spawn_locations[1] * 5
			sprite.frame = 1
			outline.frame = 1
		elif(angle < 270):
			current_spawn_location = bullet_spawn_locations[2] * 5
			sprite.frame = 2
			outline.frame = 2
		else:
			current_spawn_location = bullet_spawn_locations[3] * 5
			sprite.frame = 3
			outline.frame = 3
		if(Input.is_action_pressed("Shoot") and can_shoot):
			wants_shoot = true;
		

func _physics_process(delta):
	space_state = get_world_2d().direct_space_state
	if(wants_shoot):
		wants_shoot = false
		shoot()
		
func shoot():
	var shooting = true
	var bullet_instance = bullet.instantiate()
	var ray_start = current_spawn_location+global_position
	var ray_end = (get_global_mouse_position() - ray_start) * ray_length
	var query = PhysicsRayQueryParameters2D.create(ray_start, ray_end)
	query.hit_from_inside = true
	query.collide_with_areas = true
	var collision = get_world_2d().direct_space_state.intersect_ray(query)
	if collision:
		spawn_laser_effect(collision.position)
		var distance = collision.position - ray_start
		bullet_instance.length = distance.length()
	bullet_instance.global_position = global_position + current_spawn_location
	bullet_instance.look_at(get_global_mouse_position())
	get_parent().add_child(bullet_instance)
	can_shoot = false
	await get_tree().create_timer(0.6).timeout
	shooting = false
	can_shoot = true

func spawn_laser_effect(spawn_location: Vector2):
	var effect_instance = laser_hit_effect.instantiate()
	get_tree().get_root().add_child(effect_instance)
	effect_instance.position = spawn_location

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if(event.is_action_pressed("Select")):
		turret_selected.emit(self)
		
func clear_selection():
	selected = false
	sprite.frame = 3
	outline.frame = 3
	outline.visible = false


func _on_mouse_entered() -> void:
	outline.visible = true


func _on_mouse_exited() -> void:
	if(!selected):
		outline.visible = false
