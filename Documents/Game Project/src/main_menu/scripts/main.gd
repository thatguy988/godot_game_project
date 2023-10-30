extends Control

signal display_info_text_box

func _ready():
	$"MainMenu/MenuSelection/Play".grab_focus()
	$IdleTimer.start(30)
	emit_signal("display_info_text_box","Press up and down arrow keys to move up and down. Press enter to select option.")
	
func _input(event):
	if Input.is_action_just_pressed("ui_up"):
		$IdleTimer.start(30)
	if Input.is_action_just_pressed("ui_dowm"):
		$IdleTimer.start(30)

func _on_quit_pressed():
	get_tree().quit()


func _on_play_pressed():
	#get_tree().change_scene_to_file("res://src/platforming/scenes/levels/level_3.tscn")
	#get_tree().change_scene_to_file("res://src/platforming/scenes/levels/level_2.tscn")
	get_tree().change_scene_to_file("res://src/platforming/scenes/levels/level_1.tscn")

	#get_tree().change_scene_to_file("res://src/platforming/scenes/levels/level_4.tscn")
	#get_tree().change_scene_to_file("res://src/platforming/scenes/levels/level_7.tscn")
	#get_tree().change_scene_to_file("res://src/platforming/scenes/levels/level_5.tscn")
	#get_tree().change_scene_to_file("res://src/platforming/scenes/levels/level_6.tscn")
	#get_tree().change_scene_to_file("res://src/platforming/camera/camera.tscn")
	#get_tree().change_scene_to_file("res://src/battle/scenes/Battle_Zones/forest_battle_scene.tscn")
	#get_tree().change_scene_to_file("res://src/battle/scenes/Battle_Zones/Boss_1_Battle_Scene.tscn")
	#get_tree().change_scene_to_file("res://src/cutscenes/scenes/Intro.tscn")
	#get_tree().change_scene_to_file("res://src/cutscenes/scenes/Intro_Animation_Player.tscn")
	

func _on_tutorial_pressed():
	get_tree().change_scene_to_file("res://src/battle/scenes/Battle_Zones/tutorial.tscn")


func _on_idle_timer_timeout():
	get_tree().change_scene_to_file("res://src/cutscenes/scenes/Intro_Animation_Player.tscn")
