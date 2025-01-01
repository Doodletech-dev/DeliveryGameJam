extends Node2D
@onready var health_bar: ProgressBar = $Border/HealthBar

@export var max_health: float = 20

func _ready():
	if(health_bar):
		health_bar.max_value = max_health
		
func set_max(health):
	max_health = health

func set_health(health):
	if(health_bar):
		health_bar.value = health
