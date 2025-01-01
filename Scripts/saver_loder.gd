extends Node
class_name SaverLoader

var save_data = {}

func _save_game(data : Dictionary):
	var file = FileAccess.open("user://savegame.json", FileAccess.WRITE)
	
	save_data.merge(data, true)
	
	var json = JSON.stringify(save_data)
	
	file.store_string(json)
	print("Save new data")
	file.close()
	
func _load_game():
	var file = FileAccess.open("user://savegame.json", FileAccess.READ)
	if(file == null): return false
	var json = file.get_as_text()
	
	save_data = JSON.parse_string(json)
	
	var savable_objects = get_tree().get_nodes_in_group("savable")
	get_tree().call_group("savable", "_on_load_game", save_data)
	get_parent()._on_load_game(save_data)

	file.close()
	return true
	
func _delete_save_game():
	DirAccess.remove_absolute("user://savegame.json")
