extends CanvasLayer

# Declare variables for the windows
@onready var window_upgrades = $Window_Upgrades
@onready var window_menu = $Window_Menu
@onready var health_bar: ProgressBar = $Window_Gameplay/TextureRect/HealthBar

func _ready():
	# Connect button signals using the correct paths
	$Window_Gameplay/HBoxContainer/Button_Upgrades.connect("pressed", Callable(self, "_on_upgrade_button_pressed"))
	$Window_Gameplay/HBoxContainer2/Button_Menu.connect("pressed", Callable(self, "_on_menu_button_pressed"))

func _physics_process(delta: float) -> void:
	health_bar.value = GameManager.current_health

# Button actions

func _on_upgrade_button_pressed():
	toggle_window(window_upgrades)

func _on_menu_button_pressed():
	toggle_window(window_menu)

# Utility to toggle window visibility
func toggle_window(window: Control):
	# Toggle visibility for the clicked window
	window.visible = not window.visible
