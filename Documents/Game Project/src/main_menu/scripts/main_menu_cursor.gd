extends "res://src/ui/menu_cursor.gd"

func _ready():
	visible = true
	
	
func _process(delta):

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
		visible = false
		cursor_index = 0
		
		var current_menu_item := get_menu_item_at_index(cursor_index)
		if current_menu_item != null:
			if current_menu_item.has_method("cursor_select"):
				current_menu_item.cursor_select()
