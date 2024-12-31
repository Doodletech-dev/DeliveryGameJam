extends Area2D

@onready var missile_explosion: Node2D = $"../MissileExplosion"

@export var death_effect: PackedScene
@export var max_health : int
var current_health

func  _ready():
	current_health = max_health 

func _on_body_entered(body):
	if(body is Bullet or body is Missile):
		current_health -= body.damage
		body.hit_detected()
		if(current_health <= 0):	
			if(owner is Enemy):
				owner._death()
			if(get_parent().name == "NukeReactor"):
				GameManager.game_over.emit()
			create_effects()
			get_parent().queue_free()
			
func create_effects():
	var effect_instance = death_effect.instantiate()
	effect_instance.global_transform = global_transform
	get_tree().get_root().add_child(effect_instance)
	for emitter in effect_instance.get_children():
		emitter.emitting = true


func _on_area_entered(area: Area2D) -> void:
	pass # Replace with function body.
