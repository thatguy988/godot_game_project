extends Node2D


signal display_next_textbox
signal text_box_closed 
signal animation_is_finished
signal scene_finished

signal display_textbox(name, new_text)



var textbox_closed := false
var animation_finished := false

var character_name: Array
var dialogue: Array



func _ready():
	character_name = ["Narrator", "Narrator", "Narrator", "Player_1"]
	dialogue = ["In the beginning, our hero is a man name Player_1.","Setting out with his companion fairy.","It is up to them and you the player. Good Luck.", "Lets Go!!!"]
	cutscene_script()
	
func cutscene_script():
	# part of scene has both animation and textbox
	$TimerForTextBox.start(1)
	await self.display_next_textbox
	$CharacterBody2D/AnimationPlayer.play("run")
	$AnimationPlayer.play("intro_walk_player_0")
	emit_signal("display_textbox",character_name[0], dialogue[0])#get it to work
	await self.scene_finished
	
	# part of scene has both animation and textbox
	$TimerForTextBox.start(1) #set time to wait for animation to finish
	await self.display_next_textbox
	$AnimationPlayer.play("intro_walk_companion_1")
	emit_signal("display_textbox",character_name[1], dialogue[1])#get it to work
	await self.scene_finished
	
	#this scene has no animation playing just textbox displays
	$TimerForTextBox.start(1)
	await self.display_next_textbox
	emit_signal("display_textbox",character_name[2], dialogue[2])#get it to work
	animation_finished = true
	await self.scene_finished
	
	
	
	$TimerForTextBox.start(0.5)
	await self.display_next_textbox
	emit_signal("display_textbox",character_name[3], dialogue[3])#get it to work
	
	$AnimationPlayer.play("intro_walk_player_3")
	$CharacterBody2D/AnimationPlayer.play("run")
	$TimerForTextBox.start(3.5)
	await self.display_next_textbox
	get_tree().change_scene_to_file("res://src/platforming/camera/camera.tscn")


func both_signals_received():
	if textbox_closed && animation_finished:
		emit_signal("scene_finished")
		textbox_closed = false  # Reset flags for future use
		animation_finished = false
	
	
func _on_timer_timeout():
	emit_signal("display_next_textbox")

func _on_animation_player_animation_finished(anim_name):
	emit_signal("animation_is_finished")
	if anim_name == "intro_walk_player_0":
		$CharacterBody2D/AnimationPlayer.stop()
		$CharacterBody2D/AnimationPlayer.play("idle")
	
func _on_text_box_closed():
	print("in textbox closed")
	textbox_closed = true
	both_signals_received()

func _on_animation_is_finished():
	print("in animation finished")
	animation_finished = true
	both_signals_received()


