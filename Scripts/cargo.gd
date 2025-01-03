extends Node2D
class_name Cargo

@onready var character_hitbox: Area2D = $CharacterHitbox
@onready var hitbox: Area2D = $CharacterHitbox
@onready var shield_timer: Timer = $Shield_Timer

@export var death_effect: PackedScene
@export var max_repair = 50
@export var repair_speed = 0.5
@export var health_upgrade_amount = 0.25
var repaired_amount = 0
var never_shielded = true
var never_repaired = true 
var player_current_health
var player_max_health = 100
var health_modifier = 1

func _ready():
	if(GameManager.saver_loder._load_game()):
		pass
	else:
		var health_multiplier = health_modifier
		if(GameManager.walker_upgrades > 0):
			health_multiplier *= 1 + health_upgrade_amount * GameManager.walker_upgrades
		player_current_health = hitbox.max_health * health_modifier
	print ("Player Current Health is " + str(player_current_health))
	GameManager.current_health = hitbox.max_health
	GameManager.max_health = hitbox.max_health

func _on_save_game():
	var data = {}
	data["player_health"] = player_current_health
	print("Saving the game")
	GameManager.saver_loder._save_game(data)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if(GameManager.health_upgrade_pending):
		GameManager.health_upgrade_pending = false
		print( 1 + health_upgrade_amount * GameManager.walker_upgrades)
		player_current_health *= 1 + health_upgrade_amount
		hitbox.current_health *= 1 + health_upgrade_amount
		GameManager.max_health = hitbox.max_health * (1 + health_upgrade_amount)
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
	

func _on_load_game(data : Dictionary):
	player_current_health =	 data["player_health"]
	print("player health equals " + str(player_current_health))

func _on_character_hitbox_body_entered(body: Node2D) -> void:
	print("Player take damage HP")
	if(player_current_health <= 0):
		print("Player at zero HP")
		#create_effects()
		GameManager.game_over.emit()
		get_tree().change_scene_to_file("res://Scenes/levels/level 1.tscn")

func create_effects():
	var effect_instance = death_effect.instantiate()
	print(effect_instance)
	effect_instance.global_transform = global_transform
	get_tree().get_root().add_child(effect_instance)
	for emitter in effect_instance.get_children():
		emitter.emitting = true
		
func _on_timer_timeout() -> void:
	hitbox.shielded = false
