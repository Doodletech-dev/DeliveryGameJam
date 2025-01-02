extends Area2D

@onready var missile_explosion: Node2D = $"../MissileExplosion"

@export var death_effect: PackedScene
@export var max_health : int
var current_health
var resitance

func  _ready():
	current_health = max_health 
	var owner = get_parent() as Enemy
	if(owner is Enemy):
		resitance = owner.damage_types

func _on_body_entered(body):
	if(body is Bullet or body is Missile):
		if(resitance == 0):
			if(body is Missile):
				current_health -= body.damage
			#if laser do no damage
		if(resitance == 1):
			#if laser do double damage
			if(body is Bullet):
				return
		if(resitance == 2):
			if(body is Missile):
				print("enemy took no damage because is resitant to missile")
				return
			elif(body is Bullet):
				print("enemy took double damage because is weak to bullets")
				current_health -= body.damage
		current_health -= body.damage
		body.hit_detected()
		if(current_health <= 0):	
			if(owner is Enemy):
				create_effects()
				owner._death()
				get_parent().queue_free()
			
func create_effects():
	var effect_instance = death_effect.instantiate()
	effect_instance.global_transform = global_transform
	get_tree().get_root().add_child(effect_instance)
	for emitter in effect_instance.get_children():
		emitter.emitting = true
