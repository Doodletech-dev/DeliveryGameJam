extends CanvasLayer

# Declare variables for the windows
@onready var window_upgrades = $Window_Upgrades
@onready var window_menu = $Window_Menu
@onready var health_bar: Node2D = %HealthbarNew
@onready var scrap: Label = $Window_Gameplay/Scrap

func _ready():
	# Connect button signals using the correct paths
	$Window_Gameplay/HBoxContainer/Button_Upgrades.connect("pressed", Callable(self, "_on_upgrade_button_pressed"))
	$Window_Gameplay/HBoxContainer2/Button_Menu.connect("pressed", Callable(self, "_on_menu_button_pressed"))
	health_bar.set_max(GameManager.current_health)
	scrap.text = str(GameManager.current_scraps)

func _physics_process(delta: float) -> void:
	health_bar.set_health(GameManager.current_health)
	scrap.text = str(GameManager.current_scraps)

# Button actions

func _on_upgrade_button_pressed():
	toggle_window(window_upgrades)

func _on_menu_button_pressed():
	toggle_window(window_menu)

# Utility to toggle window visibility
func toggle_window(window: Control):
	# Toggle visibility for the clicked window
	window.visible = not window.visible

func flash_text_red(text):
	var original_color = Color(1.0,1.0,1.0,1.0)
	var red = Color(1.0,0.0,0.0,1.0)
	text.set("theme_override_colors/font_color",red)
	await get_tree().create_timer(0.1).timeout
	text.set("theme_override_colors/font_color",original_color)
	await get_tree().create_timer(0.1).timeout
	text.set("theme_override_colors/font_color",red)
	await get_tree().create_timer(0.1).timeout
	text.set("theme_override_colors/font_color",original_color)

func _on_upgrade_1_button_pressed() -> void:
	var cost = int(%Upgrade1_Button.get_child(2).text)
	if GameManager.current_scraps >= cost:
		GameManager.current_scraps -= cost
		GameManager.missile_upgrades += 1
	else:
		flash_text_red(%Upgrade1_Button.get_child(2))


func _on_upgrade_2_button_pressed() -> void:
	var cost = int(%Upgrade2_Button.get_child(2).text)
	if GameManager.current_scraps >= cost:
		GameManager.current_scraps -= cost
		GameManager.laser_upgrades += 1
	else:
		flash_text_red(%Upgrade2_Button.get_child(2))


func _on_upgrade_3_button_pressed() -> void:
	var cost = int(%Upgrade3_Button.get_child(2).text)
	if GameManager.current_scraps >= cost:
		GameManager.current_scraps -= cost
		GameManager.turret_upgrades += 1
	else:
		flash_text_red(%Upgrade3_Button.get_child(2))


func _on_upgrade_4_button_pressed() -> void:
	var cost = int(%Upgrade4_Button.get_child(2).text)
	if GameManager.current_scraps >= cost:
		GameManager.current_scraps -= cost
		GameManager.walker_upgrades += 1
	else:
		flash_text_red(%Upgrade4_Button.get_child(2))

func _on_upgrade_5_button_pressed() -> void:
	var cost = int(%Upgrade5_Button.get_child(2).text)
	if GameManager.current_scraps >= cost:
		GameManager.current_scraps -= cost
	else:
		flash_text_red(%Upgrade5_Button.get_child(2))


func _on_upgrade_6_button_pressed() -> void:
	var cost = int(%Upgrade6_Button.get_child(2).text)
	if GameManager.current_scraps >= cost:
		GameManager.current_scraps -= cost
	else:
		flash_text_red(%Upgrade6_Button.get_child(2))


func _on_upgrade_7_button_pressed() -> void:
	var cost = int(%Upgrade7_Button.get_child(2).text)
	if GameManager.current_scraps >= cost:
		GameManager.current_scraps -= cost
	else:
		flash_text_red(%Upgrade7_Button.get_child(2))


func _on_upgrade_8_button_pressed() -> void:
	var cost = int(%Upgrade8_Button.get_child(2).text)
	if GameManager.current_scraps >= cost:
		GameManager.current_scraps -= cost
	else:
		flash_text_red(%Upgrade8_Button.get_child(2))
