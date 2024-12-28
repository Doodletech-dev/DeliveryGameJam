extends Area2D

@export var max_health : int
var current_health

func  _ready():
	current_health = max_health 
	

func _on_body_entered(body):
	if(body is Bullet):
		current_health -= body.damage
		body.queue_free()
		if(current_health <= 0):	
			if(get_parent().name == "NukeReactor"):
				print("Game Over")
				GameManager.game_over.emit()
			get_parent().queue_free()
