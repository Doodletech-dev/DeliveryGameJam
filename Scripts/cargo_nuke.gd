extends Node2D

class_name Cargo
@onready var shield_timer: Timer = $Shield_Timer
@onready var hitbox: Area2D = $CharacterHitbox

@export var max_repair = 50
@export var repair_speed = 0.5
var repaired_amount = 0
var never_shielded = true
var never_repaired = true 
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	GameManager.current_health = hitbox.max_health

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	GameManager.current_health = hitbox.current_health
	if(GameManager.shield_purchased and never_shielded):
		never_shielded = false
		shield_timer.start()
		hitbox.shielded = true
	if(GameManager.repair_purchased and never_repaired):
		never_repaired = false
		GameManager.repairing = true
	if(GameManager.repairing):
		if(repaired_amount < max_repair):
			hitbox.current_health += repair_speed
			repaired_amount += repair_speed
		else:
			GameManager.repairing = false
		if(hitbox.current_health > hitbox.max_health):
			hitbox.current_health = hitbox.max_health
			GameManager.repairing = false


func _on_timer_timeout() -> void:
	hitbox.shielded = false


func _on_repair_timer_timeout() -> void:
	GameManager.repairing = false
