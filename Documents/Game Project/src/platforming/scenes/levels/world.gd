extends Node2D

signal display_textbox
signal text_box_closed
signal animation_is_finished
signal scene_finished

signal load_next_scene

var textbox_closed = false
var animation_finished = false

var character_name: Array
var dialogue: Array

func _ready():
	character_name = ["???","MechRobot"]
	dialogue = ["Well Well Hello there.","How are you doing boi.","I will not let you go any futher. You die here!!!"]


func cutscene_script():
	$Player/AnimationPlayer.play("idle")
	emit_signal("display_textbox",character_name[0],dialogue[0])
	animation_finished = true
	await self.scene_finished
	
	$Cutscenes/Timer.start(1)
	await self.load_next_scene
	
	emit_signal("display_textbox",character_name[0],dialogue[1])
	animation_finished = true
	await self.scene_finished
	
	$Cutscenes/Timer.start(1)
	await self.load_next_scene
	
	$Cutscenes/AnimationPlayer.play("scene_3")
	textbox_closed = true
	await self.scene_finished
	
	$Cutscenes/Timer.start(1)
	await self.load_next_scene
	
	emit_signal("display_textbox",character_name[1],dialogue[2])
	animation_finished=true
	await self.scene_finished
	
	
	$Cutscenes/Timer.start(1)
	await self.load_next_scene
	
	
	$Transition/AnimationPlayer.play("fade_out")
	textbox_closed = true
	await self.scene_finished
	#get_tree().change_scene_to_file("res://src/main_menu/scenes/main.tscn")
	
	
	
func _on_area_2d_body_entered(body):
	cutscene_script()


	
func _on_text_box_closed():
	textbox_closed = true
	both_signals_received()

func _on_animation_is_finished():
	animation_finished = true
	both_signals_received()

func both_signals_received():
	if textbox_closed && animation_finished:
		emit_signal("scene_finished")
		textbox_closed = false  # Reset flags for future use
		animation_finished = false


func _on_animation_player_animation_finished(anim_name):
	_on_animation_is_finished()


func _on_timer_timeout():
	emit_signal("load_next_scene")


func _on_battle_transition():#make contact with enemy
	$Transition/AnimationPlayer.play("fade_out")
