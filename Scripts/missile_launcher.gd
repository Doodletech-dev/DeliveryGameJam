extends Turret

signal turret_selected

@export var missile: PackedScene
@onready var outline: AnimatedSprite2D = %Outline
@onready var cooldown_timer: Timer = $CooldownTimer
@onready var recharge_bar: Node2D = $RechargeBar


var selected: bool = false
var can_shoot: bool = true

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if(selected):
		outline.visible = true
		shoot()
func _physics_process(delta: float) -> void:
	recharge_bar.set_health(cooldown_timer.wait_time - cooldown_timer.time_left)
	
func shoot():
	if(Input.is_action_pressed("Shoot") and can_shoot):
		var missile_instance = missile.instantiate()
		missile_instance.target = get_global_mouse_position()
		missile_instance.global_transform = global_transform
		get_parent().add_child(missile_instance)
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
	outline.visible = false

func _on_mouse_entered() -> void:
	outline.visible = true


func _on_mouse_exited() -> void:
	if(!selected):
		outline.visible = false
