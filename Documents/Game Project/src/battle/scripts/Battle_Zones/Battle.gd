extends Control

signal attack_button_pressed
signal scan_button_pressed
signal magic_selected

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

signal text_box_closed


var playerturns
var enemyturns
var index = 0
var enemy_index = 0

var action

var pick_attack_or_magic

var half_turn = 0.5
var full_turn = 1
var weakness_multiplier = 2
var strength_multiplier = 0.5
var critical_multiplier = 1.5
var enemy_critical_multiplier = 1.5
var enemy_hit_weakness_multiplier = 2
var enemy_hit_strength_multiplier = 0.5
	
	
func _input(event):
	if Input.is_key_pressed(KEY_F) and $InfoTextbox.visible:
		$InfoTextbox.hide()
		emit_signal("text_box_closed")
		
	if Input.is_action_just_pressed("ui_cancel") and magic_selection_array[index].visible:
		magic_selection_array[index].hide()
		if index == 0:
			emit_signal("hide_player_display_magic_cursor")
		if index == 1:
			emit_signal("hide_companion_display_magic_cursor")
		display_menu()
		

func set_health(progressbar, health, max_health):
	progressbar.value = health
	progressbar.max_value = max_health
	progressbar.get_node("Health Numbers").text = "HP: %d / %d" % [health,max_health]

func set_magic_points(progressbar, magic_points, max_magic_points):
	progressbar.value = magic_points
	progressbar.max_value = max_magic_points
	progressbar.get_node("Magic Numbers").text = "MP: %d / %d" % [magic_points,max_magic_points]
	
func display_counter(new_name,turn):
	$TurnCounter/TextBoxContainer/MarginContainer/HBoxContainer/CharacterName.text = new_name
	$TurnCounter/TextBoxContainer/MarginContainer/HBoxContainer/NumberofTurns.text = "%f" % playerturns
	
func display_text(new_text):
	$InfoTextbox/TextBoxContainer/MarginContainer/HBoxContainer/Text.text = new_text
	$InfoTextbox.show()
	
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
			if is_critical:
				display_text("%s does critical attack" % enemy_array[enemy_index].name)
				await self.text_box_closed
				damage_array[randomNum].play("damage")
				character_array[randomNum].health = max(0, character_array[randomNum].health - (enemy_critical_multiplier * enemy_array[enemy_index].attack_power))
				display_text("%s does damage %d" % [enemy_array[enemy_index].name, (enemy_critical_multiplier * enemy_array[enemy_index].attack_power) ] )
				await self.text_box_closed
				enemyturns -= half_turn
			else:
				display_text("%s attacks" % enemy_array[enemy_index].name)
				await self.text_box_closed
				damage_array[randomNum].play("damage")
				character_array[randomNum].health = max(0, character_array[randomNum].health - enemy_array[enemy_index].attack_power)
				display_text("%s does damage %d" % [enemy_array[enemy_index].name,enemy_array[enemy_index].attack_power])
				await self.text_box_closed
				enemyturns -= full_turn
			set_health(health_bar_array[randomNum],
							character_array[randomNum].health,
							character_array[randomNum].max_health)
		elif pick_attack_or_magic == 1: #use magic
			var pick_spell = randi_range(0,enemy_array[enemy_index].magic_spells.size() - 1)
			display_text("%s casts %s" % [enemy_array[enemy_index].name, enemy_array[enemy_index].magic_spells[pick_spell]])
			await self.text_box_closed
			if character_array[randomNum].weakness == enemy_array[enemy_index].magic_spells[pick_spell]:
				character_array[randomNum].health = max(0, character_array[randomNum].health - (enemy_hit_weakness_multiplier * enemy_array[enemy_index].magic_attack_power))
				display_text("%s is weak to %s Damage %d" % [character_array[randomNum].name, enemy_array[enemy_index].magic_spells[pick_spell], (enemy_hit_weakness_multiplier * enemy_array[enemy_index].magic_attack_power)])
				await self.text_box_closed
				enemyturns -= half_turn
			elif character_array[randomNum].strength == enemy_array[enemy_index].magic_spells[pick_spell]:
				character_array[randomNum].health = max(0, character_array[randomNum].health - (enemy_hit_strength_multiplier * enemy_array[enemy_index].magic_attack_power))
				display_text("%s is resist to %s damage %d" % [character_array[randomNum].name, enemy_array[enemy_index].magic_spells[pick_spell], (enemy_hit_strength_multiplier * enemy_array[enemy_index].magic_attack_power)])
				await self.text_box_closed
				enemyturns -= full_turn
			else:
				character_array[randomNum].health = max(0, character_array[randomNum].health - (enemy_array[enemy_index].magic_attack_power))
				display_text("Damage %d" % (enemy_array[enemy_index].magic_attack_power))
				await self.text_box_closed
				enemyturns -= full_turn
			damage_array[randomNum].play(enemy_array[enemy_index].magic_spells[pick_spell])
		check_enemy_index()
		check_for_player_turn()
				
func _on_flee_pressed():
	display_text("Ran away")
	await self.text_box_closed
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
	action = "attack"
	attack_button_pressed.emit()#pass arguement
	emit_signal("attack_button_pressed")#get it to work
	
func _on_fire_pressed():
	magic_is_selected()
	action = "Fire"
	magic_selected.emit()
	emit_signal("magic_selected")

func _on_water_pressed():
	magic_is_selected()
	action = "Water"
	magic_selected.emit()
	emit_signal("magic_selected")

func _on_lightning_pressed():
	magic_is_selected()
	action = "Lightning"
	magic_selected.emit()
	emit_signal("magic_selected")
	
func _on_earth_pressed():
	magic_is_selected()
	action = "Earth"
	magic_selected.emit()
	emit_signal("magic_selected")

func check_if_all_enemies_dead():
	var dead_enemies = 0
	dead_enemies = 0
	for i in range(0,enemy_array.size()):
		if enemy_array[i].alive == false:
			dead_enemies += 1
	while dead_enemies == enemy_array.size():
		display_text("All enemies are dead")
		await self.text_box_closed
		go_back_to_platform_level()

		
func check_if_enemy_is_dead(selection_index):
	if enemy_array[selection_index].health <= 0:
		display_text("%s is dead" % enemy_array[selection_index].name)
		enemy_array[selection_index].alive = false
		enemy_damage_animation_array[selection_index].play("Dead")
		await self.text_box_closed
		
func check_if_character_is_dead(selected_character):
	if character_array[selected_character].health == 0:
		display_text("%s is dead" % character_array[selected_character].name)
		character_array[selected_character].alive = false
		await self.text_box_closed
		
func check_if_all_characters_dead():
	var dead_characters = 0
	dead_characters = 0
	for i in range(0,character_array.size()):
		if character_array[i].alive == false:
			dead_characters += 1
	while dead_characters == character_array.size():
		display_text("game over")
		await self.text_box_closed
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
	display_counter(character_array[index].name, playerturns)
	
func check_enemy_index():
	enemy_index += 1
	if enemy_index >= enemy_array.size():
			enemy_index = 0
	while enemy_array[enemy_index].alive == false:
		enemy_index += 1
		if enemy_index >= enemy_array.size():
			enemy_index = 0
	
			
func check_for_player_turn():
	if enemyturns <= 0:
		index = 0
		playerturns = 0
		for i in range(character_array.size()):
			if character_array[i].alive == true:
				playerturns += full_turn
		display_counter(character_array[index].name, playerturns)
		display_menu()
	else:
		enemy_turn()
		
func check_for_enemy_turn():
	if playerturns <= 0:
		enemy_index = 0
		enemyturns = 0
		for i in range(enemy_array.size()):
			if enemy_array[i].alive == true:
				enemyturns += full_turn
		enemy_turn()
	else:
		display_menu()

	
func magic_is_selected():
	action_selection_array[index].hide()
	magic_selection_array[index].hide()
	



func _on_healing_pressed():
	magic_is_selected()
	#change index to selected entity
	if character_array[index].magic_points >= 10 and character_array[index].health != character_array[index].max_health:
		character_array[index].health = min(character_array[index].max_health, character_array[index].health + character_array[index].healing_power)
		display_text("Healing %d" % character_array[index].healing_power)
		await self.text_box_closed
		$PlayerDamage.play("player_heal")
		character_array[index].magic_points -= 10
		playerturns -= 1
		set_magic_points(magic_bar_array[index],
				character_array[index].magic_points,
				character_array[index].max_magic_points)
		set_health(health_bar_array[index], 
					character_array[index].health, 
					character_array[index].max_health)

		check_index()
		check_for_enemy_turn()
	elif character_array[index].health == character_array[index].max_health:
		display_text("Full health")
		await self.text_box_closed
		display_menu()
	else:
		display_text("Not enough MP")
		await self.text_box_closed
		display_menu()
	
#

func _on_scan_pressed():
	action_selection_array[index].hide()
	action = "scan"
	scan_button_pressed.emit()#pass arguement
	emit_signal("scan_button_pressed")#get it to work
	
func _on_textbox_timer_timeout():
	$InfoTextbox.hide()
	emit_signal("text_box_closed")


func _on_skip_pressed():
	action_selection_array[index].hide()
	display_text("Skip to next character")
	await self.text_box_closed
	check_index()
	display_menu()
	playerturns -= half_turn


func attack(selection_index):
	var critical_chance = 0.9
	var is_critical = randf() <= critical_chance
	if is_critical:
		display_text("Critical Attack")
		await self.text_box_closed
		character_animation_array[index].play("attack")
		character_animation_array[index].queue("idle")
		enemy_array[selection_index].health = max(0, enemy_array[selection_index].health - (critical_multiplier * character_array[index].attack_power))			
		display_text("Critical %d" % (critical_multiplier * character_array[index].attack_power))
		playerturns -= half_turn
	else:	
		display_text("Attack")
		await self.text_box_closed
		character_animation_array[index].play("attack")
		character_animation_array[index].queue("idle")
		display_text("Damage %d" % character_array[index].attack_power)
		enemy_array[selection_index].health = max(0, enemy_array[selection_index].health - character_array[index].attack_power)
		playerturns -= full_turn
	enemy_damage_animation_array[selection_index].play("Attacked")
	await self.text_box_closed
	check_if_enemy_is_dead(selection_index)
	check_if_all_enemies_dead()
	check_index()
	check_for_enemy_turn()
	
func magic(selection_index,action):
	if character_array[index].magic_points >= 5:
		if enemy_array[selection_index].weakness == action:
			enemy_array[selection_index].health = max(0, enemy_array[selection_index].health - (weakness_multiplier * character_array[index].magic_attack_power))
			display_text("Hit Weakness Damage %d" % (weakness_multiplier * character_array[index].magic_attack_power))
			await self.text_box_closed
			playerturns -= half_turn
		elif enemy_array[selection_index].strength == action:
			enemy_array[selection_index].health = max(0, enemy_array[selection_index].health - (strength_multiplier * character_array[index].magic_attack_power))
			display_text("Enemy is resist to %s Damage %d" % [action, (strength_multiplier * character_array[index].magic_attack_power)])
			await self.text_box_closed
			playerturns -= full_turn
		else:
			enemy_array[selection_index].health = max(0, enemy_array[selection_index].health - character_array[index].magic_attack_power)
			display_text("%s Attack" % action)
			await self.text_box_closed
			playerturns -= full_turn
		character_animation_array[index].play("magic_attack")
		character_animation_array[index].queue("idle")
		enemy_damage_animation_array[selection_index].play(action)
		character_array[index].magic_points -= 10
		set_magic_points(magic_bar_array[index],
				character_array[index].magic_points,
				character_array[index].max_magic_points)
		check_if_enemy_is_dead(selection_index)
		check_if_all_enemies_dead()
		check_index()
		check_for_enemy_turn()
	else:
		display_text("Not enough MP")
		await self.text_box_closed
		display_menu()

func scan(selection_index):
	$TextboxTimer.start(10)
	display_text("HP: %d, MP: %d, Strength: %s, Weakness %s" % [enemy_array[selection_index].health, enemy_array[selection_index].magic_points, enemy_array[selection_index].strength, enemy_array[selection_index].weakness])
	await self.text_box_closed
	display_menu()
	$TextboxTimer.start(3)

func _on_menu_cursor_menu_canceled():
	if action in ["attack","scan"]:
		display_menu()
	elif action in ["Fire","Water","Lightning","Earth"]:
		display_magic_menu()
