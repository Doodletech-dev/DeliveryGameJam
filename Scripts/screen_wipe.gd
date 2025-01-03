extends Node2D
class_name Screen_Wipe

@onready var collision_shape: CollisionShape2D = $Area2D/CollisionShape2D

@export var damage = 500
@export var damage_type := DamageTypes.type.bullet
@export var spread_speed = 50
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	collision_shape.shape.radius += spread_speed
	if(collision_shape.shape.radius > 1500):
		queue_free()

func hit_detected():
	print("wow")

func _on_area_entered(area: Area2D) -> void:
	print(area)
	if(area.get_parent() is Enemy):
		area.laser_hit_pew_pew(self)
