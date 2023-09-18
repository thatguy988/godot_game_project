extends "res://src/battle/scripts/Battle_Zones/Battle.gd"


@export var boss: Resource
@export var character: Resource
@export var companion: Resource




func _ready():
	character_array=[character,companion]
	action_selection_array=[$Party_Group/Player_Character/ActionSelection,$Party_Group/Companion/ActionSelection]
	magic_selection_array=[$Party_Group/Player_Character/MagicSelection, $Party_Group/Companion/MagicSelection]
	health_bar_array = [$"character_info_textbox/MarginContainer/MarginContainer/VBoxContainer/Player1 healthbar", $"character_info_textbox/MarginContainer/MarginContainer2/VBoxContainer/companion healthbar"]
	magic_bar_array = [$"character_info_textbox/MarginContainer/MarginContainer/VBoxContainer/Player1 magicbar",$"character_info_textbox/MarginContainer/MarginContainer2/VBoxContainer/companion magicbar"]
	enemy_array = [boss]
	enemy_nodes = [$One_Enemy/Enemy_1]
	enemyturns = enemy_array.size()
	playerturns = []
	enemyturns = []
	for i in range(character_array.size()):
			playerturns.append(1)
	for i in range(enemy_array.size()):
			enemyturns.append(1)
	initialize_focus=[$Party_Group/Player_Character/ActionSelection/Actions/Attack,$Party_Group/Companion/ActionSelection/Actions/Magic]
	initialize_focus_magic=[$Party_Group/Player_Character/MagicSelection/Magic/Fire,$Party_Group/Companion/MagicSelection/Magic/Fire ]
	character_animation_array = [$"Party_Group/Player_Character/Player_AnimationPlayer",$"Party_Group/Companion/Companion_AnimationPlayer"]
	damage_array=[$"Party_Group/PlayerDamage",$"Party_Group/CompanionDamage"]
	enemy_animation_array = []
	enemy_damage_animation_array = [$"One_Enemy/enemy_1/boss_1/Enemy_Animation_Player"]
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
		if action == "attack":
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
		if action == "attack":
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
	get_tree().change_scene_to_file("res://src/platforming/camera/camera.tscn")


func _on_info_text_box_closed():
	emit_signal("info_text_box_closed")


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_in":
		emit_signal("display_info_text_box","Start Battle")
		$TextboxTimer.start(10)
		await self.info_text_box_closed
		display_menu()
	elif anim_name == "battle_fade_out":
		get_tree().change_scene_to_file("res://src/platforming/camera/camera.tscn")
