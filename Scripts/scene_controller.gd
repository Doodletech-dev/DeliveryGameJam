extends Node

@onready var level_timer = $LevelTimer
@export var enemy_spawners : Array[Node2D] = []

var level_timer_time

func _ready():
	call_deferred("set_level_timer")
	if(enemy_spawners == null):
		printerr("No spawners connected to scene controller")

func set_level_timer():
	level_timer.wait_time = (GameManager.current_level * 60)
	level_timer.start()

func _on_level_timer_timeout():
	GameManager.stop_enemy_spawners.emit(enemy_spawners)
