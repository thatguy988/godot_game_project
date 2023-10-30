extends "res://src/battle/scripts/Battle_Zones/Battle.gd"


@export var slime: Resource
@export var character: Resource
@export var companion: Resource
@export var slime_2: Resource




func _ready():
	character_array=[character,companion]
	action_selection_array = [$Party_Group/GridContainer/Player/Player_Character/ActionSelection, $Party_Group/GridContainer/Companion/Companion/ActionSelection]
	magic_selection_array = [$Party_Group/GridContainer/Player/Player_Character/MagicSelection, $Party_Group/GridContainer/Companion/Companion/MagicSelection]
	health_bar_array = [$"character_info_textbox/MarginContainer/MarginContainer/VBoxContainer/Player1 healthbar", $"character_info_textbox/MarginContainer/MarginContainer2/VBoxContainer/companion healthbar"]
	magic_bar_array = [$"character_info_textbox/MarginContainer/MarginContainer/VBoxContainer/Player1 magicbar",$"character_info_textbox/MarginContainer/MarginContainer2/VBoxContainer/companion magicbar"]
	enemy_array = [slime, slime_2]
	enemy_nodes = [$Pair_of_Enemies/enemy_1, $Pair_of_Enemies/enemy_2]
	enemyturns = enemy_array.size()
	playerturns = []
	enemyturns = []
	for i in range(character_array.size()):
			playerturns.append(1)
	for i in range(enemy_array.size()):
			enemyturns.append(1)
	initialize_focus = [$Party_Group/GridContainer/Player/Player_Character/ActionSelection/Actions/Attack,$Party_Group/GridContainer/Companion/Companion/ActionSelection/Actions/Magic]
	initialize_focus_magic = [$Party_Group/GridContainer/Player/Player_Character/MagicSelection/Magic/Fire, $Party_Group/GridContainer/Companion/Companion/MagicSelection/Magic/Fire]
	character_animation_array = [$Party_Group/GridContainer/Player/Player_Character/Player_AnimationPlayer, $"Party_Group/GridContainer/Companion/Companion/Companion_AnimationPlayer"]
	enemy_animation_array = []
	enemy_damage_animation_array = [$"Pair_of_Enemies/enemy_1/slime_enemy/Enemy_Animation_Player", $"Pair_of_Enemies/enemy_2/slime_enemy/Enemy_Animation_Player"]
	emit_signal("set_health",$"character_info_textbox/MarginContainer/MarginContainer/VBoxContainer/Player1 healthbar", character.health, character.max_health)
	emit_signal("set_health",$"character_info_textbox/MarginContainer/MarginContainer2/VBoxContainer/companion healthbar", companion.health, companion.max_health)
	emit_signal("set_magic_points",$"character_info_textbox/MarginContainer/MarginContainer/VBoxContainer/Player1 magicbar", character.magic_points, character.max_magic_points)
	emit_signal("set_magic_points",$"character_info_textbox/MarginContainer/MarginContainer2/VBoxContainer/companion magicbar",companion.magic_points, companion.max_magic_points)
	emit_signal("display_counter_text_box",character_array[index].name,playerturns)
	for i in range(action_selection_array.size()):
		action_selection_array[i].hide()
		magic_selection_array[i].hide()
	$Transition/AnimationPlayer.play("fade_in")
	



func _on_enemy_1_cursor_selected():
	if enemy_array[0].alive:
		var selection_index = 0
		if action == "Attack":
			attack(selection_index)
		elif action == "scan":
			scan(selection_index)
		elif action in ["Fire","Water","Thunder","Earth"]:
			magic(selection_index, action)
			
		#add code for scripted scenes here maybe for bosses when boss reaches a certain health trigger cutscene
		
		
	else:
		emit_signal("display_info_text_box","Enemy is dead pick another.")
		await self.info_text_box_closed
		emit_signal("attack_button_pressed")

func _on_enemy_2_cursor_selected():
	if enemy_array[1].alive:
		var selection_index = 1
		if action == "Attack":
			attack(selection_index)
		elif action == "scan":
			scan(selection_index)
		elif action in ["Fire","Water","Thunder","Earth"]:
			magic(selection_index, action)
	else:
		emit_signal("display_info_text_box","Enemy is dead pick another.")
		await self.info_text_box_closed
		emit_signal("attack_button_pressed")
		
		
func go_back_to_platform_level():
	get_tree().change_scene_to_file("res://src/platforming/scenes/levels/level_1.tscn")


func _on_info_text_box_closed():
	emit_signal("info_text_box_closed")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_in":
		emit_signal("display_info_text_box","Start Battle")
		$TextboxTimer.start(10)
		await self.info_text_box_closed
		display_menu()
	elif anim_name == "battle_fade_out":
		get_tree().change_scene_to_file("res://src/platforming/scenes/levels/level_1.tscn")


func _on_player_cursor_selected():
	if character_array[0].alive:
		var selection_index = 0
		if action == "Heal":
			magic(selection_index, action)


func _on_companion_cursor_selected():
	if character_array[1].alive:
		var selection_index = 1
		if action == "Heal":
			magic(selection_index, action)
