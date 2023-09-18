extends Sprite2D


func _on_player_animation_player_animation_finished(anim_name):
	if anim_name != "Dead":
		$Player_AnimationPlayer.play("idle")
