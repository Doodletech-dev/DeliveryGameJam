extends Node
class_name SaverLoader

func _save_game(data : Dictionary):
	var file = FileAccess.open("user://savegame.json", FileAccess.WRITE)
	var save_data = {}
	save_data = data
	
	var json = JSON.stringify(save_data)
	
	file.store_string(json)
	file.close()
	
func _load_game():
	var file = FileAccess.open("user://savegame.json", FileAccess.READ)
	if(file == null): return
	var json = file.get_as_text()
	
	var saved_data = JSON.parse_string(json)
	
	var savable_objects = get_tree().get_nodes_in_group("savable")
	get_tree().call_group("savable", "_on_load_game", saved_data)

	file.close()
