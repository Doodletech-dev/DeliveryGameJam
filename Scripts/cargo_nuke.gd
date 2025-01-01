extends Node2D

class_name Cargo

@onready var hitbox: Area2D = $CharacterHitbox

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.current_health = hitbox.max_health

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	GameManager.current_health = hitbox.current_health
