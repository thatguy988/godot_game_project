extends Node2D






func _ready():
	$TextBox_1/TextBoxContainer/MarginContainer/VBoxContainer/CharacterName.text = "Narrator"
	$TextBox_1/TextBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/Text.text = "First Dialgoue Box!"
	$TextBox_2/TextBoxContainer/MarginContainer/VBoxContainer/CharacterName.text = "Mike"
	$TextBox_2/TextBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/Text.text = "Where are we man?"
	$TextBox_3/TextBoxContainer/MarginContainer/VBoxContainer/CharacterName.text = "John"
	$TextBox_3/TextBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/Text.text = "Hello there."
	$AnimationPlayer.play("TextBox")



