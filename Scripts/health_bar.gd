extends Node2D
@onready var health_bar: ProgressBar = $Border/HealthBar
@export var color: StyleBoxFlat

var max_health: float = 100

func _ready():
	if(health_bar):
		health_bar.max_value = max_health
		health_bar.set("theme_override_styles/fill",color)
		
func set_max(health):
	max_health = health
	if(health_bar):
		health_bar.max_value = max_health

func set_health(health):
	if(health_bar):
		health_bar.value = health
