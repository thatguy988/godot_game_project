extends Sprite2D



func _on_enemy_animation_player_animation_finished(anim_name):
	if anim_name != "Dead":
		$Enemy_Animation_Player.play("idle")
