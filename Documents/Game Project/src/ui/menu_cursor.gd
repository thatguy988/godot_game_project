extends TextureRect

@export var menu_parent_path : NodePath 
@export var cursor_offset: Vector2

@onready var menu_parent := get_node(menu_parent_path)

var cursor_index: int = 0

func _ready():
	visible = false
				
func get_menu_item_at_index(index: int) -> Control:
	if menu_parent == null:
		return null
	if index >= menu_parent.get_child_count() or index < 0:
		return null
	return menu_parent.get_child(index) as Control  
func set_cursor_from_index(index : int)-> void:
	var menu_item := get_menu_item_at_index(index)
	
	if menu_item == null:
		return
	
	var position = menu_item.global_position
	var size = menu_item.size
	
	global_position = Vector2(position.x, position.y + size.y / 2.0) - (size / 2.0) - cursor_offset
	
	cursor_index = index





