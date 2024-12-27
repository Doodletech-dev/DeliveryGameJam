extends Node2D

@export var turrets: Node2D

var selected_turret = null

func _ready():
	# Assuming turrets are children of a "Turrets" node
	for turret in turrets.get_children():
		turret.connect("turret_selected", _on_turret_selected)

func _on_turret_selected(turret):
	if selected_turret and turret != selected_turret:
		selected_turret.selected = false;
	selected_turret = turret
	selected_turret.selected = true;
