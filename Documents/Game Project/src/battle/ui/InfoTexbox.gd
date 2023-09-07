extends CanvasLayer

var tween : Tween

signal info_text_box_closed 

var text_speed = 0.06

func _ready():
	$TextBoxContainer.visible = false

func _input(event):
	if Input.is_action_just_pressed("ui_select") and $TextBoxContainer/MarginContainer/HBoxContainer/EndSymbol.text == "v":
		$TextBoxContainer.visible = false
		emit_signal("info_text_box_closed")
	elif Input.is_action_just_pressed("ui_select") and $TextBoxContainer/MarginContainer/HBoxContainer/EndSymbol.text == "":
		tween.set_speed_scale(50)
		$TextBoxContainer/MarginContainer/HBoxContainer/EndSymbol.text = "v"
		
func _on_display_info_text_box(new_text):
	$TextBoxContainer.visible = true
	$TextBoxContainer/MarginContainer/HBoxContainer/Text.text = new_text
	$TextBoxContainer/MarginContainer/HBoxContainer/EndSymbol.text = ""
	$TextBoxContainer/MarginContainer/HBoxContainer/Text.visible_ratio = 0
	tween = create_tween()
	$DisplayEndSymbol.start(len(new_text)*text_speed)
	tween.tween_property($TextBoxContainer/MarginContainer/HBoxContainer/Text,"visible_ratio",1,len(new_text)*text_speed).set_trans(Tween.TRANS_LINEAR)
	

func _on_info_text_box_closed():
	pass # Replace with function body.


func _on_display_end_symbol_timeout():
	$TextBoxContainer/MarginContainer/HBoxContainer/EndSymbol.text = "v"
