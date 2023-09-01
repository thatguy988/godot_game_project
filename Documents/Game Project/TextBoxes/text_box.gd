extends CanvasLayer

var tween : Tween

signal text_box_closed 

func _ready():
	$TextBoxContainer.visible = false

func _input(event):
	if Input.is_action_just_pressed("ui_select") and $TextBoxContainer.visible:
		$TextBoxContainer.visible = false
		emit_signal("text_box_closed")



func _on_display_textbox(name, new_text):
	print("display next textbox")
	$TextBoxContainer.visible = true
	$TextBoxContainer/MarginContainer/VBoxContainer/CharacterName.text = name
	$TextBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/Text.text = new_text
	$TextBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/EndSymbol.text = ""
	$TextBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/Text.visible_ratio = 0
	tween = create_tween()
	tween.tween_property($TextBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/Text,"visible_ratio",1,len(new_text)*0.04).set_trans(Tween.TRANS_LINEAR) #let text become visible from left to right



