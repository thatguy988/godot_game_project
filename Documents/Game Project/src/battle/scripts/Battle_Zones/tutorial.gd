extends "res://src/battle/scripts/Battle_Zones/Battle.gd"


@export var enemy: Resource
@export var character: Resource
@export var companion: Resource

var character_name: Array
var dialogue: Array

signal tutorial_text_box_closed 
signal objective_complete

signal display_scan_cursor
signal display_magic_cursor

var dialogue_index = 0

var w_is_pressed := false
var s_is_pressed := false


var tutorial_step_0 := false #use spacebar to go through dialogue box
var tutorial_step_1 := false #use spacebar to go through dialogue box
var tutorial_step_2 := false # use w and s to navigate menu
var tutorial_step_3 := false # press enter to select attack option
var tutorial_step_4 := false # press esc to cancel attack
var tutorial_step_5 := false #press spacebar
var tutorial_step_6 := false 
var tutorial_step_7 := false 
var tutorial_step_8 := false 
var tutorial_step_9 := false 
var tutorial_step_10 := false 
var tutorial_step_11 := false 
var tutorial_step_12 := false 
var tutorial_step_13 := false 
var tutorial_step_14 := false 
var tutorial_step_15 := false 
var tutorial_step_16 := false 
var tutorial_step_17 := false 
var tutorial_step_18 := false 
var tutorial_step_19 := false 
var tutorial_step_20 := false 
var tutorial_step_21 := false 
var tutorial_step_22 := false 
var tutorial_step_23 := false 
var tutorial_step_24 := false 




func _ready():
	character_array=[character]
	action_selection_array=[$Player_Character/ActionSelection]
	magic_selection_array=[$Player_Character/MagicSelectWater]
	health_bar_array = [$"character_info_textbox/MarginContainer/MarginContainer/VBoxContainer/Player1 healthbar"]
	magic_bar_array = [$"character_info_textbox/MarginContainer/MarginContainer/VBoxContainer/Player1 magicbar"]
	enemy_array = [enemy]
	enemy_nodes = [$One_Enemy/Enemy]
	playerturns = []
	enemyturns = []
	for i in range(character_array.size()):
			playerturns.append(1)
	for i in range(enemy_array.size()):
			enemyturns.append(1)
	initialize_focus=[$Player_Character/ActionSelection/Actions/Attack]
	initialize_focus_magic=[$Player_Character/MagicSelection/Magic/Fire]
	character_animation_array = [$"Player_Character/Player_AnimationPlayer"]
	character_animation_array[0].queue("idle")
	damage_array=[$"PlayerDamage"]
	enemy_animation_array = []
	enemy_damage_animation_array = [$"EnemyDamage"]
	set_health($"One_Character_Info_Textbox/MarginContainer/MarginContainer/VBoxContainer/Player1 healthbar", 
				character.health, 
				character.max_health)
	set_magic_points($"One_Character_Info_Textbox/MarginContainer/MarginContainer/VBoxContainer/Player1 magicbar",
				character.magic_points,
				character.max_magic_points)
	for i in range(enemy_array.size()):
		enemy_nodes[i].texture = enemy_array[i].texture
	display_counter(character_array[index].name)
	$InfoTextbox.hide()
	for i in range(action_selection_array.size()):
		action_selection_array[i].hide()
		magic_selection_array[i].hide()
	$"One_Character_Info_Textbox".hide()
	$"TurnCounter".hide()
	$"Player_Character/ActionSelection".hide()
	$"Player_Character/select_magic".hide()
	$"Player_Character/select_scan".hide()
	$"Companion/MagicSelectFire".hide()
	$"Player_Character/MagicSelectWater".hide()
	$Companion.visible = false
	$InfoTextbox.hide()
	character_name = ["Tutorial Narrator"]
	dialogue = ["Hello I will go over the controls and how to play the battle scenes. For the rest of the tutorial, you can press spacebar to close this textbox to move on or wait a couple of seconds for this textbox to automatically close.",
				"Good First, In the top left corner of the screen is the InfoTextbox it will display info of what is going on in the battle at that moment. In a normal battle, it will open and close automatically.",
				"Good, when the menu pops up use the w key to move up and s to move the down the menu.",
				"Good. Now use the spacebar to select the attack button", 
				"As you can see you now have a cursor pointing at the enemy. Use the esc key to go back to cancel the attack and go back to the action selection.",
				"Now press enter to select attack option this will display the cursor to point at the enemy. Press enter again to select the enemy. When you select the enemy you will attack.",
				"If there are more then one enemy you can use the the arrow keys to move up and down selecting which enemy you want to attack by pressing spacebar.",
				"Now look at the top right corner you see this is the turn counter it displays the name of who's turn it is and also how many turns your team has.",
				"Each character in your party that is alive gets one turn. Each attack counts as one turn unless you land a critical hit with the attack. If you do a critical hit the attack counts as half a turn or 0.5 turn.",
				"When you are using magic each spell counts as one turn unless you hit the enemy's weakness. If you hit their weakness it counts as half a turn or 0.5 turn",
				"Lets add a companion to your party. You can see that your party now has two turns. A 1 for each character.",
				"Select the scan option when the menu pops up. Then select the enemy.",
				"You can now see the stats of the enemy the amount of health points, magic points, strength, and weakness. We can see the enemy is weak to water.",
				"Casting magic to hit a enemy's weakness will do more damage. Hitting an enemy's strength will do less damage. Casting magic that is neither a strength or weakness will do normal damage.",
				"To take advantage of this weakness select the magic option, then select water, then select the enemy.",
				"As you can see Hitting the enemy weakness does more damage and only costs half a turn.",
				"Now it is your companion's turn. Select magic, then select fire magic, then select the enemy.",
				"Fire is the strength of the enemy therefor it does half damage and costs full turn. However since you had a half turn, the game will subtract from the half turn first before subtracting from a full turn.",
				"If it was 0,1 we would of subtracted a full turn from the 1 and get 0,0. However because it was 0.5,1 we subtracted from 0.5 resulting in 0,1.",
				"So remember, a Half turns will subtract from a 1 first before subtract from a 0.5. And a full turn will subtract from a 0.5 before subtracting from a 1.",
				"Remember these rules of combat also apply when it is the enemy's turn.",
				"The other action selections are skip and flee. Skip will let you not take an action for your current character and move to the next character's turn. But will cost half a turn.",
				"Flee lets you have the possibly of running away from battle. But their is a chance flee will not work and cost you half a turn.",
				"Lastly, In the bottom right corner there will be a textbox displaying the healthbar and magicbar of your party.",
				"Good job this is the end of the tutorial."]
	tutorial_script()

# ui_select press spacebar to go through dialogue and infotexbox
#ui_accept press enter to select menu option

func _input(event):
	if not tutorial_step_0:
		if Input.is_action_just_pressed("ui_select"):
			step_0_spacebar_pressed()

	elif tutorial_step_0 and not tutorial_step_1:
		if Input.is_action_just_pressed("ui_select"):
			step_1_spacebar_pressed()

	elif tutorial_step_1 and not tutorial_step_2: #step0 is true and step 1 is false then go into statement
		if Input.is_action_just_pressed("ui_select"):
			emit_signal("tutorial_text_box_closed")
		if not $"TextBox".visible:
			if Input.is_action_just_pressed("ui_up") and not tutorial_step_2:
				w_is_pressed = true
				both_w_and_s_pressed()
			if Input.is_action_just_pressed("ui_down") and not tutorial_step_2:
				s_is_pressed = true
				both_w_and_s_pressed()

	elif tutorial_step_2 and not tutorial_step_3: #select attack
		if Input.is_action_just_pressed("ui_select"):
			emit_signal("tutorial_text_box_closed")

	elif tutorial_step_3 and not tutorial_step_4: #press cancel
		if Input.is_action_just_pressed("ui_select"):
			emit_signal("tutorial_text_box_closed")

		if Input.is_action_just_pressed("ui_cancel"):
			step_4_esc_pressed()

	elif tutorial_step_4 and not tutorial_step_5: # select enemy
		if Input.is_action_just_pressed("ui_select"):
			emit_signal("tutorial_text_box_closed")
			
	elif tutorial_step_5 and not tutorial_step_6:#talk about how you can use up and down to select enemy
		if Input.is_action_just_pressed("ui_select"):
			tutorial_step_6 = true
			emit_signal("tutorial_text_box_closed")
			
	elif tutorial_step_6 and not tutorial_step_7:#display turn counter
		if Input.is_action_just_pressed("ui_select"):
			tutorial_step_7 = true
			emit_signal("tutorial_text_box_closed")
			
	elif tutorial_step_7 and not tutorial_step_8:#explain turn counter a little
		if Input.is_action_just_pressed("ui_select"):
			tutorial_step_8 = true
			emit_signal("tutorial_text_box_closed")
			
	elif tutorial_step_8 and not tutorial_step_9:#explain magic to turn counter
		if Input.is_action_just_pressed("ui_select"):
			tutorial_step_9 = true
			emit_signal("tutorial_text_box_closed")
			
	elif tutorial_step_9 and not tutorial_step_10:#add companion
		if Input.is_action_just_pressed("ui_select"):
			tutorial_step_10 = true
			emit_signal("tutorial_text_box_closed")
	
	elif tutorial_step_10 and not tutorial_step_11:#select scan
		if Input.is_action_just_pressed("ui_select"):
			emit_signal("tutorial_text_box_closed")
	
	elif tutorial_step_11 and not tutorial_step_12:#explain info displayed from scan
		if Input.is_action_just_pressed("ui_select"):
			tutorial_step_12 = true
			emit_signal("tutorial_text_box_closed")
	
	elif tutorial_step_12 and not tutorial_step_13:#explain cast spell on weakness and strength
		if Input.is_action_just_pressed("ui_select"):
			tutorial_step_13 = true
			emit_signal("tutorial_text_box_closed")
			
	elif tutorial_step_13 and not tutorial_step_14:# tell user to cast water
		if Input.is_action_just_pressed("ui_select"):
			emit_signal("tutorial_text_box_closed")
			
	elif tutorial_step_14 and not tutorial_step_15:# explain what happen
		if Input.is_action_just_pressed("ui_select"):
			tutorial_step_15 = true
			emit_signal("tutorial_text_box_closed")
			
	elif tutorial_step_15 and not tutorial_step_16:#have user cast fire magic
		if Input.is_action_just_pressed("ui_select"):
			tutorial_step_16 = true
			emit_signal("tutorial_text_box_closed")
	
	elif tutorial_step_16 and not tutorial_step_17:#explaining
		if Input.is_action_just_pressed("ui_select"):
			tutorial_step_17 = true
			emit_signal("tutorial_text_box_closed")
			
	elif tutorial_step_17 and not tutorial_step_18:#explaining
		if Input.is_action_just_pressed("ui_select"):
			tutorial_step_18 = true
			emit_signal("tutorial_text_box_closed")
			
	elif tutorial_step_18 and not tutorial_step_19:#explaining
		if Input.is_action_just_pressed("ui_select"):
			tutorial_step_19 = true
			emit_signal("tutorial_text_box_closed")
			
	elif tutorial_step_19 and not tutorial_step_20:#explaining
		if Input.is_action_just_pressed("ui_select"):
			tutorial_step_20 = true
			emit_signal("tutorial_text_box_closed")
	
	elif tutorial_step_20 and not tutorial_step_21:#explaining
		if Input.is_action_just_pressed("ui_select"):
			tutorial_step_21 = true
			emit_signal("tutorial_text_box_closed")
			
	elif tutorial_step_21 and not tutorial_step_22:#explaining
		if Input.is_action_just_pressed("ui_select"):
			tutorial_step_22 = true
			emit_signal("tutorial_text_box_closed")
			
	elif tutorial_step_22 and not tutorial_step_23: #display health bar
		if Input.is_action_just_pressed("ui_select"):
			tutorial_step_23 = true
			emit_signal("tutorial_text_box_closed")
			
	elif tutorial_step_23 and not tutorial_step_24:#tell user tutorial is over
		if Input.is_action_just_pressed("ui_select"):
			tutorial_step_24 = true
			emit_signal("tutorial_text_box_closed")
	
	
	
			
	
	
		
#	if Input.is_action_just_pressed("ui_accept") and $TextBox.visible:
#		$TextBox.hide()
#		emit_signal("tutorial_text_box_closed")
		
#	if Input.is_action_just_pressed("ui_cancel") and magic_selection_array[index].visible:
#		magic_selection_array[index].hide()
#		if index == 0:
#			emit_signal("hide_player_display_magic_cursor")
#		if index == 1:
#			emit_signal("hide_companion_display_magic_cursor")
		#display_menu()

func step_0_spacebar_pressed():
	tutorial_step_0 = true
	emit_signal("tutorial_text_box_closed")
	
func step_1_spacebar_pressed():
	tutorial_step_1 = true
	emit_signal("tutorial_text_box_closed")
	

func both_w_and_s_pressed():
	if w_is_pressed and s_is_pressed:
		tutorial_step_2 = true
		emit_signal("objective_complete")


func _on_attack_pressed():
	if tutorial_step_2 and not tutorial_step_3: #object is to select attack button
		tutorial_step_3 = true
		emit_signal("objective_complete")
		action_selection_array[index].hide()
		action = "attack"
		attack_button_pressed.emit()#pass arguement
		emit_signal("attack_button_pressed")#get it to work
	elif tutorial_step_4 and not tutorial_step_5: # objective is to select enemy
		action_selection_array[index].hide()
		action = "attack"
		attack_button_pressed.emit()#pass arguement
		emit_signal("attack_button_pressed")#get it to work
		
func _on_scan_pressed():
	$"Player_Character/select_scan".hide()
	action = "scan"
	scan_button_pressed.emit()#pass arguement
	emit_signal("scan_button_pressed")#get it to work
		
	
func step_4_esc_pressed():
	tutorial_step_4 = true
	emit_signal("objective_complete")

func step_5_enemy_selected():#step 5 select enemy to attack
	tutorial_step_5 = true
	emit_signal("objective_complete")

	
func next_step():
	dialogue_index += 1
	$TextboxTimer.start(20)
	display_textbox(character_name[0], dialogue[dialogue_index])
	await self.tutorial_text_box_closed
	
	
func tutorial_script():
	$TextboxTimer.start(20)
	display_textbox(character_name[0], dialogue[0])
	await self.tutorial_text_box_closed

	$TextboxTimer.start(20)
	display_text("The InfoTextBox")
	display_textbox(character_name[0], dialogue[1])
	await self.tutorial_text_box_closed
	
	$TextboxTimer.start(20)
	display_textbox(character_name[0], dialogue[2])
	await self.tutorial_text_box_closed
	
	display_text("Press up and down keys")
	$Player_Character/ActionSelection.show()
	$Player_Character/ActionSelection/Actions/Attack.grab_focus()
	emit_signal("display_attack_cursor")
	await self.objective_complete
	
	$Player_Character_Action_Selection.visible = false
	$Player_Character/ActionSelection.hide()
	$TextboxTimer.start(20)
	display_textbox(character_name[0], dialogue[3])
	await self.tutorial_text_box_closed
	
	$Player_Character/ActionSelection.show()
	$Player_Character/ActionSelection/Actions/Attack.grab_focus()
	emit_signal("display_attack_cursor")
#	$Player_Character_Action_Selection.visible = true
	display_text("Press enter to select the attack option")
	await self.objective_complete
	
	$TextboxTimer.start(20)
	display_textbox(character_name[0], dialogue[4])
	await self.tutorial_text_box_closed
	display_text("Press the cancel button go back.")
	await self.objective_complete
	
	$Player_Character/ActionSelection.hide()
	$Player_Character_Action_Selection.visible = false
	
	
	$TextboxTimer.start(20)
	display_textbox(character_name[0], dialogue[5])
	await self.tutorial_text_box_closed
	$Player_Character/ActionSelection.show()
	$Player_Character/ActionSelection/Actions/Attack.grab_focus()
	$Player_Character_Action_Selection.visible = true
	display_text("Select attack option then select the enemy")
	await self.objective_complete
	
	$TextboxTimer.start(20)
	display_textbox(character_name[0], dialogue[6])
	await self.tutorial_text_box_closed
	
	
	$"TurnCounter".show()
	$TextboxTimer.start(20)
	display_textbox(character_name[0], dialogue[7])
	await self.tutorial_text_box_closed
	
	$TextboxTimer.start(20)
	display_textbox(character_name[0], dialogue[8])
	await self.tutorial_text_box_closed
	
	$TextboxTimer.start(20)
	display_textbox(character_name[0], dialogue[9])
	await self.tutorial_text_box_closed
	
	$Companion.visible = true
	playerturns = [1, 1]
	display_counter(character_array[index].name)
	$TextboxTimer.start(20)
	display_textbox(character_name[0], dialogue[10])
	await self.tutorial_text_box_closed
	
	$TextboxTimer.start(20)
	display_textbox(character_name[0], dialogue[11])
	await self.tutorial_text_box_closed
	$Player_Character/select_scan.show()
	$Player_Character/select_scan/Actions/Attack.grab_focus()
	emit_signal("display_scan_cursor")
	display_text("Select scan and select the enemy")
	await self.objective_complete
	
	$TextboxTimer.start(20)
	display_textbox(character_name[0], dialogue[12])
	await self.tutorial_text_box_closed
	
	$TextboxTimer.start(20)
	display_textbox(character_name[0], dialogue[13])
	await self.tutorial_text_box_closed
	
	$TextboxTimer.start(20)
	display_textbox(character_name[0], dialogue[14])
	await self.tutorial_text_box_closed
	display_text("Select Magic then select Water then select enemy.")
	
	
	await self.objective_complete
	
	$TextboxTimer.start(20)
	display_textbox(character_name[0], dialogue[15])
	await self.tutorial_text_box_closed
	
	$TextboxTimer.start(20)
	display_textbox(character_name[0], dialogue[16])
	playerturns = [0.5, 1]
	display_counter("Companion")
	await self.tutorial_text_box_closed
	
	
	await self.objective_complete
	
	$TextboxTimer.start(20)
	display_textbox(character_name[0], dialogue[17])
	playerturns = [0, 1]
	display_counter("Player_1")
	await self.tutorial_text_box_closed
	
	$TextboxTimer.start(20)
	display_textbox(character_name[0], dialogue[18])
	await self.tutorial_text_box_closed
	
	$TextboxTimer.start(20)
	display_textbox(character_name[0], dialogue[19])
	await self.tutorial_text_box_closed
	
	$TextboxTimer.start(20)
	display_textbox(character_name[0], dialogue[20])
	await self.tutorial_text_box_closed
	
	$TextboxTimer.start(20)
	display_textbox(character_name[0], dialogue[21])
	await self.tutorial_text_box_closed
	
	$TextboxTimer.start(20)
	display_textbox(character_name[0], dialogue[22])
	await self.tutorial_text_box_closed
	
	$TextboxTimer.start(20)
	display_textbox(character_name[0], dialogue[23])
	await self.tutorial_text_box_closed
	
	$TextboxTimer.start(20)
	display_textbox(character_name[0], dialogue[24])
	await self.tutorial_text_box_closed
	
	get_tree().change_scene_to_file("res://src/main_menu/scenes/main.tscn")


func _on_enemy_1_cursor_selected():
	if not tutorial_step_5:
		step_5_enemy_selected()
		
	print(tutorial_step_10)
	print(tutorial_step_11)
	if tutorial_step_10 and not tutorial_step_11:
		print("Objective complete")
		tutorial_step_11 = true
		emit_signal("objective_complete")
		
		
	if enemy_array[0].alive:
		var selection_index = 0
		if action == "attack":
			attack(selection_index)
		elif action == "scan":
			scan(selection_index)
		elif action in ["Fire","Water","Thunder","Earth"]:
			magic(selection_index, action)
		#add code for scripted scenes here maybe for bosses when boss reaches a certain health trigger cutscene
	else:
		display_text("Enemy is dead pick another")
		await self.text_box_closed
		attack_button_pressed.emit()#pass arguement
		emit_signal("attack_button_pressed")#get it to work


		
func go_back_to_platform_level():
	get_tree().change_scene_to_file("res://src/main_menu/scenes/main.tscn")


func _on_text_box_timer_timeout():
	if not tutorial_step_0:
		tutorial_step_0 = true
	elif not tutorial_step_1:
		tutorial_step_1 = true
	emit_signal("tutorial_text_box_closed")


func _text_box_closed():
	$TextBox.hide()
	
func _on_objective_complete():
	$InfoTextbox.hide()

