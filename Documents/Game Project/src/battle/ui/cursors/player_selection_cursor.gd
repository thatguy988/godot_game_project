extends "res://src/ui/menu_cursor.gd"

var can_select = false  # Indicates if the player can select an enemy

signal player_selection_canceled

func _process(delta):
	if not can_select:
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
			
			
	if Input.is_action_just_pressed("ui_accept"):
		var current_menu_item := get_menu_item_at_index(cursor_index)
		if current_menu_item != null:
			if current_menu_item.has_method("cursor_select"):
				current_menu_item.cursor_select()
	
	if Input.is_action_just_pressed("ui_cancel"): #press escape button
		visible = false
		can_select = false
		cursor_index = 0
		emit_signal("player_selection_canceled")#get it to work


func _on_player_cursor_selected():
	print("Player selected")
	visible = false
	can_select = false
	cursor_index = 0


func _on_companion_cursor_selected():
	print("Companion selected")
	visible = false
	can_select = false
	cursor_index = 0


func _on_battle_healing_magic_selected():
	can_select = true
	visible = true
