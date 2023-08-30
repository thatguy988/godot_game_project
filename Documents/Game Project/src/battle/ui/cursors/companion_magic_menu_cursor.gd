extends "res://src/ui/menu_cursor.gd"

	
var can_select_magic = false  # Indicates if the player can select an enemy


func _process(delta):
	if not can_select_magic:
		return
	var input := Vector2.ZERO
	
	if Input.is_action_just_pressed("ui_up"):
		input.y -= 1
	if Input.is_action_just_pressed("ui_down"):
		input.y += 1
	
	match menu_parent.get_class():
		"VBoxContainer":
			set_cursor_from_index(cursor_index + input.y)
		"HBoxContainer":
			set_cursor_from_index(cursor_index + input.x)
		"GridContainer":
			set_cursor_from_index(cursor_index + input.x + input.y * menu_parent.columns)
			

func _on_battle_companion_display_magic_cursor():
	visible = true
	can_select_magic = true


func _on_battle_hide_companion_display_magic_cursor():
	print("HEYO")
	visible = false
	can_select_magic = false
	cursor_index = 0


func _on_fire_pressed():
	visible = false
	can_select_magic = false
	cursor_index = 0
	var current_menu_item := get_menu_item_at_index(cursor_index)
	if current_menu_item != null:
		if current_menu_item.has_method("cursor_select"):
			current_menu_item.cursor_select()


func _on_water_pressed():
	visible = false
	can_select_magic = false
	cursor_index = 0
	var current_menu_item := get_menu_item_at_index(cursor_index)
	if current_menu_item != null:
		if current_menu_item.has_method("cursor_select"):
			current_menu_item.cursor_select()


func _on_lightning_pressed():
	visible = false
	can_select_magic = false
	cursor_index = 0
	var current_menu_item := get_menu_item_at_index(cursor_index)
	if current_menu_item != null:
		if current_menu_item.has_method("cursor_select"):
			current_menu_item.cursor_select()


func _on_earth_pressed():
	visible = false
	can_select_magic = false
	cursor_index = 0
	var current_menu_item := get_menu_item_at_index(cursor_index)
	if current_menu_item != null:
		if current_menu_item.has_method("cursor_select"):
			current_menu_item.cursor_select()


func _on_healing_pressed():
	visible = false
	can_select_magic = false
	cursor_index = 0
	var current_menu_item := get_menu_item_at_index(cursor_index)
	if current_menu_item != null:
		if current_menu_item.has_method("cursor_select"):
			current_menu_item.cursor_select()


func _on_tutorial_companion_display_magic_cursor():
	pass # Replace with function body.


func _on_tutorial_hide_companion_display_magic_cursor():
	pass # Replace with function body.
