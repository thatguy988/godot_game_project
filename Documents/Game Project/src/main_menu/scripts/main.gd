extends Control

func _ready():
	$"MainMenu/MenuSelection/Play".grab_focus()
	

func _on_quit_pressed():
	get_tree().quit()


func _on_play_pressed():
	#get_tree().change_scene_to_file("res://src/platforming/camera/camera.tscn")
	get_tree().change_scene_to_file("res://src/battle/scenes/Battle_Zones/forest_battle_scene.tscn")
	#get_tree().change_scene_to_file("res://src/cutscenes/scenes/Intro.tscn")
	#get_tree().change_scene_to_file("res://src/cutscenes/scenes/Intro_Animation_Player.tscn")
	





func _on_tutorial_pressed():
	get_tree().change_scene_to_file("res://src/battle/scenes/Battle_Zones/tutorial.tscn")
