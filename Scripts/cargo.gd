extends Node2D
class_name Cargo

@onready var character_hitbox: Area2D = $CharacterHitbox

var player_current_health
var player_max_health = 100

func _ready():
	if(GameManager.saver_loder._load_game()):
		pass
	else:
		player_current_health = player_max_health
	print ("Player Current Health is " + str(player_current_health))

func _on_save_game():
	var data = {}
	data["player_health"] = player_current_health
	print("Saving the game")
	GameManager.saver_loder._save_game(data)

func _on_load_game(data : Dictionary):
	player_current_health =	 data["player_health"]
	print("player health equals " + str(player_current_health))

func _on_character_hitbox_body_entered(body: Node2D) -> void:
	if(body is Bullet or body is Missile):
		player_current_health -= body.damage
		body.queue_free()
		if(player_current_health <= 0):
			GameManager.game_over.emit()
			get_tree().change_scene_to_file("res://Scenes/levels/level 1.tscn")
