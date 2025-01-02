extends Area2D

@onready var missile_explosion: Node2D = $"../MissileExplosion"
@onready var health_bar: Node2D = %"Healthbar"

@export var death_effect: PackedScene
@export var max_health : int
@export var damage_type := DamageTypes.type.bullet
@export var damage_weakness = 5

var current_health
var shielded: bool = false

func  _ready():
	current_health = max_health 
	if(health_bar):
		health_bar.set_max(max_health)

func _on_body_entered(body):
	handle_hit(body)
			
func create_effects():
	var effect_instance = death_effect.instantiate()
	effect_instance.global_transform = global_transform
	get_tree().get_root().add_child(effect_instance)
	for emitter in effect_instance.get_children():
		emitter.emitting = true
		
func handle_hit(body):
	# This could've just be a base class but eh... it works
	if(body is Bullet or body is Missile or body is Laser_Turret or body is Screen_Wipe):
		var damage = body.damage
		if(body.damage_type == damage_type):
			damage *= damage_weakness
		if(shielded):
			damage = 0
		current_health -= damage
		if(health_bar):
			health_bar.visible = true
			health_bar.set_health(current_health)
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
			if(get_parent().name == "NukeReactor"):
				GameManager.game_over.emit()
			create_effects()
			get_parent().queue_free()

func laser_hit_pew_pew(body):
	handle_hit(body)
				get_parent().queue_free()
			
func create_effects():
	var effect_instance = death_effect.instantiate()
	effect_instance.global_transform = global_transform
	get_tree().get_root().add_child(effect_instance)
	for emitter in effect_instance.get_children():
		emitter.emitting = true
