extends Node2D






func _ready():
	$TextBox_1/TextBoxContainer.visible = true
	$TextBox_2/TextBoxContainer.visible = true
	$TextBox_3/TextBoxContainer.visible = true
	$TextBox_1/TextBoxContainer/MarginContainer/VBoxContainer/CharacterName.text = "Narrator"
	$TextBox_1/TextBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/Text.text = "First Dialgoue Box!"
	$TextBox_2/TextBoxContainer/MarginContainer/VBoxContainer/CharacterName.text = "Mike"
	$TextBox_2/TextBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/Text.text = "Where are we man?"
	$TextBox_3/TextBoxContainer/MarginContainer/VBoxContainer/CharacterName.text = "John"
	$TextBox_3/TextBoxContainer/MarginContainer/VBoxContainer/HBoxContainer/Text.text = "Hello there."
	$AnimationPlayer.play("TextBox")
	


func _input(event):
	if Input.is_action_just_pressed("ui_accept"):
		get_tree().change_scene_to_file("res://src/main_menu/scenes/main.tscn")


func _on_animation_player_animation_finished(anim_name):
	get_tree().change_scene_to_file("res://src/main_menu/scenes/main.tscn")
	
