extends Area2D

@export var max_health : int
var current_health

func  _ready():
	current_health = max_health 
	

func _on_body_entered(body):
	if(body is Bullet):
		current_health -= body.damage
		print("Boom")
		body.queue_free()
		if(current_health <= 0):	
			get_parent().queue_free()
