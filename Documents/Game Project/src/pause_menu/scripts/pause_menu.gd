extends Control

func _ready():
	hide()

func pause_menu_opened():
	show()
	$"PauseMenuBackground/PauseMenuSelection/Resume".grab_focus()

func _on_resume_pressed():
	pass # Replace with function body.


func _on_quit_pressed():
	pass # Replace with function body.

