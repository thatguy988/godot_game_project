extends "res://src/ui/menu_cursor.gd"


	
var can_select_action = false  # Indicates if the player can select an enemy


func _process(delta):
	if not can_select_action:
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
			


func _on_battle_display_attack_cursor():
	visible = true
	can_select_action = true


func _on_attack_pressed():
		visible = false
		can_select_action = false
		cursor_index = 0
		
		var current_menu_item := get_menu_item_at_index(cursor_index)
		if current_menu_item != null:
			if current_menu_item.has_method("cursor_select"):
				current_menu_item.cursor_select()

func _on_magic_pressed():
	visible = false
	can_select_action = false
	cursor_index = 0
		
	var current_menu_item := get_menu_item_at_index(cursor_index)
	if current_menu_item != null:
		if current_menu_item.has_method("cursor_select"):
			current_menu_item.cursor_select()


func _on_scan_pressed():
	visible = false
	can_select_action = false
	cursor_index = 0
		
	var current_menu_item := get_menu_item_at_index(cursor_index)
	if current_menu_item != null:
		if current_menu_item.has_method("cursor_select"):
			current_menu_item.cursor_select()


func _on_skip_pressed():
	visible = false
	can_select_action = false
	cursor_index = 0
		
	var current_menu_item := get_menu_item_at_index(cursor_index)
	if current_menu_item != null:
		if current_menu_item.has_method("cursor_select"):
			current_menu_item.cursor_select()


func _on_flee_pressed():
	visible = false
	can_select_action = false
	cursor_index = 0
		
	var current_menu_item := get_menu_item_at_index(cursor_index)
	if current_menu_item != null:
		if current_menu_item.has_method("cursor_select"):
			current_menu_item.cursor_select()


func _on_tutorial_display_scan_cursor():
	visible = true
	can_select_action = true


func _on_tutorial_display_magic_cursor():
	visible = true
	can_select_action = true

