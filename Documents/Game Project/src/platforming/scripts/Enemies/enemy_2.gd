extends "res://src/platforming/scripts/Enemies/enemy.gd"


func _ready():
	if Global.is_enemy_alive(1, 1):
		pass
	else:
		queue_free()


func _on_top_collision_body_entered(body):
	Global.kill_enemy(1, 1)
	queue_free()

func load_battle_scene():
	Global.kill_enemy(1, 1)
	emit_signal("battle_transition")
	#get_tree().change_scene_to_file("res://src/battle/scenes/Battle_Zones/forest_battle_scene.tscn")
	
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_out":
		get_tree().change_scene_to_file("res://src/battle/scenes/Battle_Zones/forest_battle_scene.tscn")
