extends "res://src/battle/scripts/Battle_Zones/Battle.gd"


@export var enemy: Resource
@export var character: Resource
@export var companion: Resource
@export var enemy_2: Resource



func _ready():
	
	character_array=[character,companion]
	action_selection_array=[$Player_Character/ActionSelection,$Companion/ActionSelection]
	magic_selection_array=[$Player_Character/MagicSelection, $Companion/MagicSelection]
	health_bar_array = [$"character_info_textbox/MarginContainer/MarginContainer/VBoxContainer/Player1 healthbar", $"character_info_textbox/MarginContainer/MarginContainer2/VBoxContainer/companion healthbar"]
	magic_bar_array = [$"character_info_textbox/MarginContainer/MarginContainer/VBoxContainer/Player1 magicbar",$"character_info_textbox/MarginContainer/MarginContainer2/VBoxContainer/companion magicbar"]
	
	
	enemy_array = [enemy, enemy_2]
	enemy_nodes = [$Pair_of_Enemies/Enemy_1, $Pair_of_Enemies/Enemy_2]
	enemyturns = enemy_array.size()
	
	playerturns = character_array.size()
	enemyturns = enemy_array.size()
	
	initialize_focus=[$Player_Character/ActionSelection/Actions/Attack,$Companion/ActionSelection/Actions/Magic]
	initialize_focus_magic=[$Player_Character/MagicSelection/Magic/Fire,$Companion/MagicSelection/Magic/Fire ]
	
	character_animation_array = [$"Player_Character/Player_AnimationPlayer",$"Companion/Companion_AnimationPlayer"]
	character_animation_array[0].queue("idle")
	damage_array=[$"PlayerDamage",$"CompanionDamage"]
	
	enemy_animation_array = []
	enemy_damage_animation_array = [$"EnemyDamage", $"Enemy_2_Damage"]
	
	set_health($"character_info_textbox/MarginContainer/MarginContainer/VBoxContainer/Player1 healthbar", 
				character.health, 
				character.max_health)
	set_health($"character_info_textbox/MarginContainer/MarginContainer2/VBoxContainer/companion healthbar",
				companion.health,
				companion.max_health)
				
	set_magic_points($"character_info_textbox/MarginContainer/MarginContainer/VBoxContainer/Player1 magicbar",
				character.magic_points,
				character.max_magic_points)
	set_magic_points($"character_info_textbox/MarginContainer/MarginContainer2/VBoxContainer/companion magicbar",
				companion.magic_points,
				companion.max_magic_points)
	

	for i in range(enemy_array.size()):
		enemy_nodes[i].texture = enemy_array[i].texture
	display_counter(character_array[index].name,playerturns)
	
	$InfoTextbox.hide()
	
	for i in range(action_selection_array.size()):
		action_selection_array[i].hide()
		magic_selection_array[i].hide()

	display_text("Battle Start")
	$TextboxTimer.start(10)
	await self.text_box_closed
	display_menu()
	



func _on_enemy_1_cursor_selected():
	if enemy_array[0].alive:
		var selection_index = 0
		if action == "attack":
			attack(selection_index)
		elif action == "scan":
			scan(selection_index)
		elif action in ["Fire","Water","Thunder","Earth"]:
			magic(selection_index, action)
		
		
	else:
		display_text("Enemy is dead pick another")
		await self.text_box_closed
		attack_button_pressed.emit()#pass arguement
		emit_signal("attack_button_pressed")#get it to work

func _on_enemy_2_cursor_selected():
	if enemy_array[1].alive:
		var selection_index = 1
		if action == "attack":
			attack(selection_index)
		elif action == "scan":
			scan(selection_index)
		elif action in ["Fire","Water","Thunder","Earth"]:
			magic(selection_index, action)
	else:
		display_text("Enemy is dead pick another")
		await self.text_box_closed
		attack_button_pressed.emit()#pass arguement
		emit_signal("attack_button_pressed")#get it to work
		
		
func go_back_to_platform_level():
	get_tree().change_scene_to_file("res://src/platforming/camera/camera.tscn")
