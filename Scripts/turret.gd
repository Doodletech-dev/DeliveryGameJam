extends Turret

signal turret_selected

@export var bullet: PackedScene


@onready var sprite: AnimatedSprite2D = $Sprite
@onready var outline: AnimatedSprite2D = $Outline
@onready var recharge_bar: Node2D = $RechargeBar
@onready var cooldown_timer: Timer = $CooldownTimer


var selected: bool = false
var can_shoot: bool = true
var bullet_spawn_locations = [Vector2(100,38),Vector2(-130,38),Vector2(-123,-78),Vector2(123,-78)]
var current_spawn_location: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	sprite.frame = 6
	outline.frame = 3

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
			sprite.frame = 0
			outline.frame = 0
		elif(angle < 180):
			current_spawn_location = bullet_spawn_locations[1]
			sprite.frame = 1
			outline.frame = 1
		elif(angle < 270):
			current_spawn_location = bullet_spawn_locations[2]
			sprite.frame = 2
			outline.frame = 2
		else:
			current_spawn_location = bullet_spawn_locations[3]
			sprite.frame = 3
			outline.frame = 3
		shoot()
	recharge_bar.set_health(cooldown_timer.wait_time - cooldown_timer.time_left)	
	
		
func shoot():
	if(Input.is_action_pressed("Shoot") and can_shoot):
		var bullet_instance = bullet.instantiate()
		bullet_instance.global_position = global_position + current_spawn_location
		bullet_instance.look_at(get_global_mouse_position())
		get_parent().add_child(bullet_instance)
		can_shoot = false
		recharge_bar.set_max(cooldown_timer.wait_time)
		recharge_bar.set_health(0)
		recharge_bar.visible = true
		cooldown_timer.start()
		
func _on_cooldown_timer_timeout() -> void:
	can_shoot = true
	recharge_bar.visible = false
	cooldown_timer.stop()

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
