extends CanvasLayer


func _on_set_health(progressbar, health, max_health):
	progressbar.value = health
	progressbar.max_value = max_health
	progressbar.get_node("Health Numbers").text = "HP: %d / %d" % [health,max_health]


func _on_set_magic_points(progressbar, magic_points, max_magic_points):
	progressbar.value = magic_points
	progressbar.max_value = max_magic_points
	progressbar.get_node("Magic Numbers").text = "MP: %d / %d" % [magic_points,max_magic_points]
