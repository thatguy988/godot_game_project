extends CanvasLayer

var tween : Tween

signal text_box_closed 

var text_speed = 0.05 #Text display speed from left to right the lower the value the faster the higher the value the slower the text displays

func _ready():
	$TextBoxContainer.visible = false

func _input(event):
	if Input.is_action_just_pressed("ui_select") and $TextBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/EndSymbol.text == "v":
		$TextBoxContainer.visible = false
		emit_signal("text_box_closed")
	elif Input.is_action_just_pressed("ui_select") and $TextBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/EndSymbol.text == "":
		tween.set_speed_scale(50)
		$TextBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/EndSymbol.text = "v"
		
		
func _on_display_textbox(name, new_text):
	$TextBoxContainer.visible = true
	$TextBoxContainer/MarginContainer/VBoxContainer/CharacterName.text = name
	$TextBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/Text.text = new_text
	$TextBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/EndSymbol.text = ""
	$TextBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/Text.visible_ratio = 0
	tween = create_tween()
	$DisplayEndSymbol.start(len(new_text) * text_speed)
	tween.tween_property($TextBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/Text,"visible_ratio",1,len(new_text) * text_speed).set_trans(Tween.TRANS_LINEAR) #let text become visible from left to right


func _on_timer_timeout():
	$TextBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/EndSymbol.text = "v"


func _on_player_textbox_text():
	if $TextBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/EndSymbol.text == "v":
		$TextBoxContainer.visible = false
		emit_signal("text_box_closed")
	elif $TextBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/EndSymbol.text == "":
		tween.set_speed_scale(50)
		$TextBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/EndSymbol.text = "v"
