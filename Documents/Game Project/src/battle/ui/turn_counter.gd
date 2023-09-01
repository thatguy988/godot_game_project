extends CanvasLayer

	
func array_to_string(arr):
	var str_arr = []
	for value in arr:
		str_arr.append(str(value))
	return ", ".join(str_arr)


func _on_display_counter_text_box(new_name, playerturns):
	$TextBoxContainer/MarginContainer/HBoxContainer/CharacterName.text = new_name
	$TextBoxContainer/MarginContainer/HBoxContainer/NumberofTurns.text = "%s" % array_to_string(playerturns)
