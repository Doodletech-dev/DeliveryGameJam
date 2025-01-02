extends Node2D

@onready var hp_heal: Node2D = $Border/HpHeal
@onready var health_bar: ProgressBar = %HealthBar
@export var color: StyleBoxFlat

var max_health: float = 100

func _ready():
	if(health_bar):
		health_bar.max_value = max_health
		set_color(color)
		
func set_color(color):
	health_bar.set("theme_override_styles/fill",color)

func set_max(health):
	if(health):
		max_health = health
		if(health_bar):
			health_bar.max_value = max_health

func set_health(health):
	if(health_bar):
		health_bar.value = health

func _physics_process(delta: float) -> void:
	if(hp_heal):
		hp_heal.visible = GameManager.repairing
