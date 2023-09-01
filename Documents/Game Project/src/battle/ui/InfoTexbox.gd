extends CanvasLayer

var tween : Tween

signal info_text_box_closed 

func _ready():
	$TextBoxContainer.visible = false

func _input(event):
	if Input.is_action_just_pressed("ui_select") and $TextBoxContainer.visible:
		$TextBoxContainer.visible = false
		print("Input")
		emit_signal("info_text_box_closed")

func _on_display_info_text_box(new_text):
	print("on_display_infotextbox")
	$TextBoxContainer.visible = true
	$TextBoxContainer/MarginContainer/HBoxContainer/Text.text = new_text
	$TextBoxContainer/MarginContainer/HBoxContainer/Text.visible_ratio = 0
	tween = create_tween()
	tween.tween_property($TextBoxContainer/MarginContainer/HBoxContainer/Text,"visible_ratio",1,len(new_text)*0.06).set_trans(Tween.TRANS_LINEAR)
	



func _on_info_text_box_closed():
	pass # Replace with function body.
