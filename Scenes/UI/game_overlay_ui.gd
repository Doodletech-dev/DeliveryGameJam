extends CanvasLayer
class_name GameUI

# Declare variables for the windows
@onready var window_upgrades = $Window_Upgrades
@onready var window_menu = $Window_Menu
@onready var health_bar: Node2D = %HealthbarNew
@onready var scrap: Label = $Window_Gameplay/Scrap
@onready var progress_bar: ProgressBar = $Window_Gameplay/ProgressBar/ProgressBar

@export var screen_wipe: PackedScene

var shield_queued = false
var repair_queued = false
var missile_queued = false
var wipe_queued = false
var wipe_complete = false

func _ready():
	# Connect button signals using the correct paths
	$Window_Gameplay/HBoxContainer/Button_Upgrades.connect("pressed", Callable(self, "_on_upgrade_button_pressed"))
	$Window_Gameplay/HBoxContainer2/Button_Menu.connect("pressed", Callable(self, "_on_menu_button_pressed"))
	health_bar.set_max(GameManager.current_health)
	scrap.text = str(GameManager.current_scraps)
	
	GameManager._get_game_overlay(self)
	

func _physics_process(delta: float) -> void:
	health_bar.set_health(GameManager.current_health)
	health_bar.set_max(GameManager.max_health)
	scrap.text = str(GameManager.current_scraps)
	%Upgrade1.get_child(0).text = str(GameManager.missile_upgrades)
	%Upgrade2.get_child(0).text = str(GameManager.laser_upgrades)
	%Upgrade3.get_child(0).text = str(GameManager.turret_upgrades)
	%Upgrade4.get_child(0).text = str(GameManager.walker_upgrades)

# Button actions

func _on_upgrade_button_pressed():
	toggle_window(window_upgrades)

func _on_menu_button_pressed():
	toggle_window(window_menu)

# Utility to toggle window visibility
func toggle_window(window: Control):
	# Toggle visibility for the clicked window
	window.visible = not window.visible
	if(!window.visible):
		apply_changes()

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
		%Upgrade1_Button.get_child(2).text = str(round(cost * 1.5))
	else:
		flash_text_red(%Upgrade1_Button.get_child(2))


func _on_upgrade_2_button_pressed() -> void:
	var cost = int(%Upgrade2_Button.get_child(2).text)
	if GameManager.current_scraps >= cost:
		GameManager.current_scraps -= cost
		GameManager.laser_upgrades += 1
		%Upgrade2_Button.get_child(2).text = str(round(cost * 1.5))
	else:
		flash_text_red(%Upgrade2_Button.get_child(2))


func _on_upgrade_3_button_pressed() -> void:
	var cost = int(%Upgrade3_Button.get_child(2).text)
	if GameManager.current_scraps >= cost:
		GameManager.current_scraps -= cost
		GameManager.turret_upgrades += 1
		%Upgrade3_Button.get_child(2).text = str(round(cost * 1.5))
	else:
		flash_text_red(%Upgrade3_Button.get_child(2))


func _on_upgrade_4_button_pressed() -> void:
	var cost = int(%Upgrade4_Button.get_child(2).text)
	if GameManager.current_scraps >= cost:
		GameManager.current_scraps -= cost
		GameManager.walker_upgrades += 1
		GameManager.health_upgrade_pending = true
		%Upgrade4_Button.get_child(2).text = str(round(cost * 1.5))
	else:
		flash_text_red(%Upgrade4_Button.get_child(2))
	print(GameManager.current_health)

func _on_upgrade_5_button_pressed() -> void:
	var cost = int(%Upgrade5_Button.get_child(2).text)
	if GameManager.current_scraps >= cost:
		GameManager.current_scraps -= cost
		var button = %Upgrade5_Button
		shield_queued = true
		handle_cooldown_purchase(button)
	else:
		flash_text_red(%Upgrade5_Button.get_child(2))

func _on_upgrade_6_button_pressed() -> void:
	var cost = int(%Upgrade6_Button.get_child(2).text)
	if GameManager.current_scraps >= cost:
		GameManager.current_scraps -= cost
		var button = %Upgrade6_Button
		GameManager.repair_purchased = true
		handle_cooldown_purchase(button)
	else:
		flash_text_red(%Upgrade6_Button.get_child(2))

func _on_upgrade_7_button_pressed() -> void:
	var cost = int(%Upgrade7_Button.get_child(2).text)
	if GameManager.current_scraps >= cost:
		GameManager.current_scraps -= cost
		var button = %Upgrade7_Button
		missile_queued = true
		handle_cooldown_purchase(button)
	else:
		flash_text_red(%Upgrade7_Button.get_child(2))


func _on_upgrade_8_button_pressed() -> void:
	var cost = int(%Upgrade8_Button.get_child(2).text)
	if GameManager.current_scraps >= cost:
		GameManager.current_scraps -= cost
		var button = %Upgrade8_Button
		wipe_queued = true
		handle_cooldown_purchase(button)
	else:
		flash_text_red(%Upgrade8_Button.get_child(2))

func apply_changes():
	if(shield_queued):
		GameManager.shield_purchased = true
	if(missile_queued):
		GameManager.missile_power_purchased = true
	if(wipe_queued and !wipe_complete):
		GameManager.screen_wipe_purchased = true
		get_parent().add_child(screen_wipe.instantiate())
		wipe_complete = true

func handle_cooldown_purchase(button):
	var cost = int(button.get_child(2).text)
	if(button.disabled):
		return
	button.set("disabled",true)

func update_progress_bar():
	progress_bar.value = GameManager.progress_bar_amount


func _on_button_menu_pressed() -> void:
	get_tree().paused = true


func _on_button_menu_resume_pressed() -> void:
	get_tree().paused = false
	toggle_window(window_menu)

func _on_button_menu_quit_pressed() -> void:
	get_tree().quit()
