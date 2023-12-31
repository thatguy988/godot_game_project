extends Control

signal attack_button_pressed
signal scan_button_pressed
signal magic_selected
signal healing_magic_selected

#cursor for player menus
signal display_attack_cursor
signal player_display_magic_cursor
signal hide_player_display_magic_cursor

#cursor for companion 
signal companion_display_action_cursor
signal companion_display_magic_cursor
signal hide_companion_display_magic_cursor


var character_array: Array
var action_selection_array: Array
var magic_selection_array: Array
var health_bar_array: Array
var magic_bar_array: Array

var initialize_focus: Array
var initialize_focus_magic: Array

var character_animation_array: Array
var enemy_animation_array: Array

var damage_array: Array
var enemy_damage_animation_array: Array




var enemy_array: Array
var enemy_nodes: Array
var enemy_node_cursors: Array

#signal text_box_closed
signal info_text_box_closed

signal display_info_text_box(new_text)
signal display_counter_text_box(new_name,playerturns)
signal set_health(progressbar, health, max_health)
signal set_magic_points(progressbar, magic_points, max_magic_points)

var playerturns
var enemyturns
var index = 0
var enemy_index = 0

var action

var pick_attack_or_magic

var weakness_multiplier = 2
var strength_multiplier = 0.5
var critical_multiplier = 1.5
var enemy_critical_multiplier = 1.5
var enemy_hit_weakness_multiplier = 2
var enemy_hit_strength_multiplier = 0.5

var battle_over = false



	
func _input(event):
#	if Input.is_action_just_pressed("ui_select") and $InfoTextbox.visible:
#		$InfoTextbox.hide()
#		emit_signal("text_box_closed")

	if Input.is_action_just_pressed("ui_cancel") and magic_selection_array[index].visible:
		magic_selection_array[index].hide()
		if index == 0:
			emit_signal("hide_player_display_magic_cursor")
		if index == 1:
			emit_signal("hide_companion_display_magic_cursor")
		display_menu()
		




func enemy_turn():
	#pick attack or magic list

		if enemy_array[enemy_index].magic_spells.size() != 0:
			pick_attack_or_magic = randi_range(0,1)
		else:
			pick_attack_or_magic = 0
		#pick character to attack
		var randomNum = randi_range(0, character_array.size() - 1)
		while(character_array[randomNum].alive == false):#make sure enemy picks alive character
			randomNum = randi_range(0,character_array.size() - 1)

		if pick_attack_or_magic == 0: #attack
			var critical_chance = 0.3
			var is_critical = randf() <= critical_chance
			enemy_damage_animation_array[enemy_index].play("Attack")
			if is_critical:
				emit_signal("display_info_text_box","%s does critical attack" % enemy_array[enemy_index].name)
				await self.info_text_box_closed
				character_animation_array[randomNum].play("Attacked")
				character_array[randomNum].health = max(0, character_array[randomNum].health - (enemy_critical_multiplier * enemy_array[enemy_index].attack_power))
				emit_signal("display_info_text_box","%s does damage %d" % [enemy_array[enemy_index].name, (enemy_critical_multiplier * enemy_array[enemy_index].attack_power) ])
				await self.info_text_box_closed
				decrease_turns(enemyturns, true, false)
			else:
				emit_signal("display_info_text_box","%s attacks" % enemy_array[enemy_index].name)
				await self.info_text_box_closed
				character_animation_array[randomNum].play("Attacked")
				character_array[randomNum].health = max(0, character_array[randomNum].health - enemy_array[enemy_index].attack_power)
				emit_signal("display_info_text_box","%s does damage %d" % [enemy_array[enemy_index].name,enemy_array[enemy_index].attack_power])
				await self.info_text_box_closed
				decrease_turns(enemyturns, false, false)
		elif pick_attack_or_magic == 1: #use magic
			enemy_damage_animation_array[enemy_index].play("Magic")
			var pick_spell = randi_range(0,enemy_array[enemy_index].magic_spells.size() - 1)
			emit_signal("display_info_text_box","%s casts %s" % [enemy_array[enemy_index].name, enemy_array[enemy_index].magic_spells[pick_spell]])
			await self.info_text_box_closed
			if character_array[randomNum].weakness == enemy_array[enemy_index].magic_spells[pick_spell]:
				character_array[randomNum].health = max(0, character_array[randomNum].health - (enemy_hit_weakness_multiplier * enemy_array[enemy_index].magic_attack_power))
				emit_signal("display_info_text_box","%s is weak to %s Damage %d" % [character_array[randomNum].name, enemy_array[enemy_index].magic_spells[pick_spell], (enemy_hit_weakness_multiplier * enemy_array[enemy_index].magic_attack_power)])
				await self.info_text_box_closed
				decrease_turns(enemyturns, true, false)
			elif character_array[randomNum].strength == enemy_array[enemy_index].magic_spells[pick_spell]:
				character_array[randomNum].health = max(0, character_array[randomNum].health - (enemy_hit_strength_multiplier * enemy_array[enemy_index].magic_attack_power))
				emit_signal("display_info_text_box","%s is resist to %s damage %d" % [character_array[randomNum].name, enemy_array[enemy_index].magic_spells[pick_spell], (enemy_hit_strength_multiplier * enemy_array[enemy_index].magic_attack_power)])
				await self.info_text_box_closed
				decrease_turns(enemyturns, false, false)
			else:
				character_array[randomNum].health = max(0, character_array[randomNum].health - (enemy_array[enemy_index].magic_attack_power))
				emit_signal("display_info_text_box", "Damage %d" % (enemy_array[enemy_index].magic_attack_power))
				await self.info_text_box_closed
				decrease_turns(enemyturns, false, false)
			character_animation_array[randomNum].play(enemy_array[enemy_index].magic_spells[pick_spell])
		emit_signal("set_health",health_bar_array[randomNum], character_array[randomNum].health, character_array[randomNum].max_health)
		check_enemy_index()
		check_for_player_turn()

func _on_flee_pressed():
	emit_signal("display_info_text_box", "Ran Away")
	await self.info_text_box_closed
	#get_tree().change_scene_to_file("res://camera/camera.tscn")
	
func _on_magic_pressed():
	action_selection_array[index].hide()
	display_magic_menu()

func display_magic_menu():
	magic_selection_array[index].show()
	initialize_focus_magic[index].grab_focus()
	if index == 0:
		emit_signal("player_display_magic_cursor")
	if index == 1:
		emit_signal("companion_display_magic_cursor")
	
func display_menu():
	action_selection_array[index].show()
	initialize_focus[index].grab_focus()
	if index == 0:
		emit_signal("display_attack_cursor")
	if index == 1:
		emit_signal("companion_display_action_cursor")
		
func _on_attack_pressed():
	action_selection_array[index].hide()
	action = "Attack"
	emit_signal("attack_button_pressed")
	
func _on_fire_pressed():
	magic_is_selected()
	action = "Fire"
	emit_signal("magic_selected")

func _on_water_pressed():
	magic_is_selected()
	action = "Water"
	emit_signal("magic_selected")

func _on_lightning_pressed():
	magic_is_selected()
	action = "Thunder"
	emit_signal("magic_selected")
	
func _on_earth_pressed():
	magic_is_selected()
	action = "Earth"
	emit_signal("magic_selected")
	
func _on_healing_pressed():
	magic_is_selected()
	action = "Heal"
	emit_signal("healing_magic_selected")

func check_if_all_enemies_dead():
	var dead_enemies = 0
	dead_enemies = 0
	for i in range(0,enemy_array.size()):
		if enemy_array[i].alive == false:
			dead_enemies += 1
	#print(dead_enemies)
	while dead_enemies == enemy_array.size():
		battle_over = true
		$TextboxTimer.start(15)
		emit_signal("display_info_text_box", "All enemies are dead.")
		await self.info_text_box_closed
		$Transition/AnimationPlayer.play("battle_fade_out")
		#go_back_to_platform_level()
	

		
func check_if_enemy_is_dead(selection_index):
	if enemy_array[selection_index].health <= 0:
		emit_signal("display_info_text_box", "%s is dead" % enemy_array[selection_index].name)
		enemy_array[selection_index].alive = false
		enemy_damage_animation_array[selection_index].play("Dead")
		await self.info_text_box_closed
		
func check_if_character_is_dead(selected_character):
	if character_array[selected_character].health == 0:
		emit_signal("display_info_text_box", "%s is dead" % character_array[selected_character].name)
		character_array[selected_character].alive = false
		await self.info_text_box_closed
	
		
func check_if_all_characters_dead():
	var dead_characters = 0
	dead_characters = 0
	for i in range(0,character_array.size()):
		if character_array[i].alive == false:
			dead_characters += 1
	while dead_characters == character_array.size():
		battle_over = true
		emit_signal("display_info_text_box", "Game Over.")
		await self.info_text_box_closed
		go_back_to_platform_level()

func go_back_to_platform_level():
	pass

func check_index():
	index += 1
	if index >= character_array.size():
		index = 0
	while character_array[index].alive == false:
		index += 1
		if index >= character_array.size():
			index = 0
	emit_signal("display_counter_text_box",character_array[index].name,playerturns)

	
func check_enemy_index():
	enemy_index += 1
	if enemy_index >= enemy_array.size():
			enemy_index = 0
	while enemy_array[enemy_index].alive == false:
		enemy_index += 1
		if enemy_index >= enemy_array.size():
			enemy_index = 0
	
			
func check_for_player_turn():
	var sum_of_array = 0
	for value in enemyturns:
		sum_of_array += value
	if sum_of_array <= 0:
		index = 0
		playerturns = []
		$"TurnCounter".show() # show turncounter when player turn
		for i in range(character_array.size()):
			if character_array[i].alive == true:
				playerturns.append(1)
		emit_signal("display_counter_text_box",character_array[index].name,playerturns)
		display_menu()
	else:
		enemy_turn()
		
func check_for_enemy_turn():
	var sum_of_array = 0
	for value in playerturns:
		sum_of_array += value
	if sum_of_array <= 0:
		enemy_index = 0
		enemyturns = []
		$"TurnCounter".hide() #hide turncounter when enemies turn
		for i in range(enemy_array.size()):
			if enemy_array[i].alive == true:
				enemyturns.append(1)
		enemy_turn()
	else:
		display_menu()

	
func magic_is_selected():
	action_selection_array[index].hide()
	magic_selection_array[index].hide()
	
func _on_scan_pressed():
	action_selection_array[index].hide()
	action = "scan"
	emit_signal("scan_button_pressed")
	
func _on_textbox_timer_timeout():
	pass
	#$InfoTextbox.hide()
	#emit_signal("text_box_closed")


func _on_skip_pressed():
	action_selection_array[index].hide()
	emit_signal("display_info_text_box", "Skip to next character")
	await self.info_text_box_closed
	check_index()
	display_menu()
	decrease_turns(playerturns, true, true)


#func attack(selection_index):
#	var critical_chance = 0.05
#	var is_critical = randf() <= critical_chance
#	if is_critical:
#		emit_signal("display_info_text_box", "Critical Attack")
#		await self.info_text_box_closed
#		enemy_array[selection_index].health = max(0, enemy_array[selection_index].health - (critical_multiplier * character_array[index].attack_power))			
#		emit_signal("display_info_text_box", "Critical %d" % (critical_multiplier * character_array[index].attack_power))
#		decrease_turns(playerturns, true, true)
#	else:
#		emit_signal("display_info_text_box", "Attack")
#		await self.info_text_box_closed
#		emit_signal("display_info_text_box", "Damage %d" % character_array[index].attack_power)
#		enemy_array[selection_index].health = max(0, enemy_array[selection_index].health - character_array[index].attack_power)
#		decrease_turns(playerturns, false, true)
#	character_animation_array[index].play("Attack")
#	enemy_damage_animation_array[selection_index].play("Attacked")
#	await self.info_text_box_closed
#	check_if_enemy_is_dead(selection_index)
#	check_if_all_enemies_dead()
#	if battle_over == false:
#		print("going to check index")
#		check_index()
#		check_for_enemy_turn()
		
		
func attack(selection_index):
	var critical_chance = 0.05
	var is_critical = randf() <= critical_chance
	
	if is_critical:
		emit_critical_attack(selection_index)
	else:
		emit_normal_attack(selection_index)

	character_animation_array[index].play("Attack")
	enemy_damage_animation_array[selection_index].play("Attacked")
	await self.info_text_box_closed

	check_if_enemy_is_dead(selection_index)
	check_if_all_enemies_dead()
	if not battle_over:
		check_index()
		check_for_enemy_turn()

func emit_critical_attack(selection_index):
	var damage = critical_multiplier * character_array[index].attack_power
	emit_damage_signals("Critical Attack", damage)
	enemy_array[selection_index].health = max(0, enemy_array[selection_index].health - damage)
	decrease_turns(playerturns, true, true)

func emit_normal_attack(selection_index):
	var damage = character_array[index].attack_power
	emit_damage_signals("Attack", damage)
	enemy_array[selection_index].health = max(0, enemy_array[selection_index].health - damage)
	decrease_turns(playerturns, false, true)

func emit_damage_signals(message, damage):
	emit_signal("display_info_text_box", "%s %d" % [message, damage])
	await self.info_text_box_closed
	
#func magic(selection_index,action):
#	if action in ["Fire","Water","Thunder","Earth"]:
#		if character_array[index].magic_points >= 5:
#			if enemy_array[selection_index].weakness == action:
#				enemy_array[selection_index].health = max(0, enemy_array[selection_index].health - (weakness_multiplier * character_array[index].magic_attack_power))
#				emit_signal("display_info_text_box", "Hit Weakness Damage %d" % (weakness_multiplier * character_array[index].magic_attack_power))
#				await self.info_text_box_closed
#				decrease_turns(playerturns, true, true)
#			elif enemy_array[selection_index].strength == action:
#				enemy_array[selection_index].health = max(0, enemy_array[selection_index].health - (strength_multiplier * character_array[index].magic_attack_power))
#				emit_signal("display_info_text_box", "Enemy is resist to %s Damage %d" % [action, (strength_multiplier * character_array[index].magic_attack_power)])
#				await self.info_text_box_closed
#				decrease_turns(playerturns, false, true)
#			else:
#				enemy_array[selection_index].health = max(0, enemy_array[selection_index].health - character_array[index].magic_attack_power)
#				emit_signal("display_info_text_box", "%s Attack" % action)
#				await self.info_text_box_closed
#				decrease_turns(playerturns, false, true)
#			character_animation_array[index].play("Magic")
#			enemy_damage_animation_array[selection_index].play(action)
#			character_array[index].magic_points -= 10
#			emit_signal("set_magic_points",magic_bar_array[index],character_array[index].magic_points,character_array[index].max_magic_points)
#			check_if_enemy_is_dead(selection_index)
#			check_if_all_enemies_dead()
#			if battle_over == false:
#				check_index()
#				check_for_enemy_turn()
#		else:
#			emit_signal("display_info_text_box", "Not enough MP")
#			await self.info_text_box_closed
#			display_menu()
#	elif action == "Heal":
#		if character_array[index].magic_points >= 10 and character_array[selection_index].health != character_array[selection_index].max_health:
#			character_array[selection_index].health = min(character_array[selection_index].max_health, character_array[selection_index].health + character_array[index].healing_power)
#			emit_signal("display_info_text_box", "Healing %d" % character_array[index].healing_power)
#			await self.info_text_box_closed
#			decrease_turns(playerturns, false, true)
#			character_animation_array[selection_index].play(action)
#			character_array[index].magic_points -= 10
#			emit_signal("set_health",health_bar_array[selection_index], character_array[selection_index].health, character_array[selection_index].max_health)
#			emit_signal("set_magic_points",magic_bar_array[index],character_array[index].magic_points,character_array[index].max_magic_points)
#			check_index()
#			check_for_enemy_turn()
#		elif character_array[index].health == character_array[index].max_health:
#			emit_signal("display_info_text_box", "Full Health")
#			await self.info_text_box_closed
#			display_menu()
#		else:
#			emit_signal("display_info_text_box", "Not Enough MP")
#			await self.info_text_box_closed
#			display_menu()


func handle_attack_magic(selection_index, action):
	var damage_multiplier = 1.0

	if enemy_array[selection_index].weakness == action:
		damage_multiplier = weakness_multiplier
		emit_signal("display_info_text_box", "Hit Weakness Damage %d" % (damage_multiplier * character_array[index].magic_attack_power))

		#decrease_turns(playerturns, true, true)
	elif enemy_array[selection_index].strength == action:
		damage_multiplier = strength_multiplier
		emit_signal("display_info_text_box", "Enemy is resist to %s Damage %d" % [action, (damage_multiplier * character_array[index].magic_attack_power)])

		#decrease_turns(playerturns, false, true)
	else:
		emit_signal("display_info_text_box", "%s Attack %s Damage" % [action, (damage_multiplier * character_array[index].magic_attack_power)])
	
	enemy_array[selection_index].health = max(0, enemy_array[selection_index].health - (damage_multiplier * character_array[index].magic_attack_power))
	decrease_turns(playerturns, damage_multiplier > 1.0, true)
	character_animation_array[index].play("Magic")
	enemy_damage_animation_array[selection_index].play(action)
	character_array[index].magic_points -= 10
	emit_signal("set_magic_points", magic_bar_array[index], character_array[index].magic_points, character_array[index].max_magic_points)
	await self.info_text_box_closed
	#damage multipler>1.0 will output true or false
	


	

	check_if_enemy_is_dead(selection_index)
	check_if_all_enemies_dead()

	if not battle_over:
		check_index()
		check_for_enemy_turn()

func handle_heal_magic(selection_index):
	if character_array[index].magic_points >= 10 and character_array[selection_index].health != character_array[selection_index].max_health:
		character_array[selection_index].health = min(character_array[selection_index].max_health, character_array[selection_index].health + character_array[index].healing_power)
		emit_signal("display_info_text_box", "Healing %d" % character_array[index].healing_power)
		await self.info_text_box_closed
		decrease_turns(playerturns, false, true)

		character_animation_array[selection_index].play("Heal")
		character_array[index].magic_points -= 10
		emit_signal("set_health", health_bar_array[selection_index], character_array[selection_index].health, character_array[selection_index].max_health)
		emit_signal("set_magic_points", magic_bar_array[index], character_array[index].magic_points, character_array[index].max_magic_points)

		check_index()
		check_for_enemy_turn()
	elif character_array[index].health == character_array[index].max_health:
		emit_signal("display_info_text_box", "Full Health")
		await self.info_text_box_closed
		display_menu()
	else:
		emit_signal("display_info_text_box", "Not Enough MP")
		await self.info_text_box_closed
		display_menu()

func magic(selection_index, action):
	if action in ["Fire", "Water", "Thunder", "Earth"]:
		if character_array[index].magic_points >= 5:
			if action == "Heal":
				handle_heal_magic(selection_index)
			else:
				handle_attack_magic(selection_index, action)
		else:
			emit_signal("display_info_text_box", "Not enough MP")
			await self.info_text_box_closed
			display_menu()
	else:
		emit_signal("display_info_text_box", "Invalid magic action")


	
		
func scan(selection_index):
	$TextboxTimer.start(20)
	emit_signal("display_info_text_box", "HP: %d, MP: %d, Strength: %s, Weakness %s. Press spacebar to continue" % [enemy_array[selection_index].health, enemy_array[selection_index].magic_points, enemy_array[selection_index].strength, enemy_array[selection_index].weakness])
	await self.info_text_box_closed
	display_menu()
	$TextboxTimer.start(5)

func _on_menu_cursor_menu_canceled():
	if action in ["Attack","scan"]:
		display_menu()
	elif action in ["Fire","Water","Lightning","Earth"]:
		display_magic_menu()


func _on_player_selection_cursor_player_selection_canceled():
	display_magic_menu()
		
func decrease_turns(turns_array, halfturnhit, is_player):
	var half_turn = 0.5
	var full_turn = 1.0
	var no_1 = true # there is no one turn
	
	if halfturnhit:
		for i in range(len(turns_array)):
			if turns_array[i] != 0:
				if turns_array[i] == 1:
					turns_array[i] -= half_turn
					no_1 = false
					break
		if no_1:
			for i in range(len(turns_array)):
				if turns_array[i] != 0:
					if turns_array[i] == 0.5:
						turns_array[i] -= half_turn
						break
	else:
		for i in range(len(turns_array)):
			if turns_array[i] != 0:
				if turns_array[i] == 0.5:
					turns_array[i] -= half_turn
				else:
					turns_array[i] -= full_turn
				break
	
	if is_player:
		playerturns = turns_array
		print("player turns")
		print(playerturns)
	else:
		enemyturns = turns_array
		print("enemy turns")
		print(enemyturns)
		



