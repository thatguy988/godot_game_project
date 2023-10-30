extends Sprite2D


func _on_companion_animation_player_animation_finished(anim_name):
	if anim_name != "Dead":
		$Companion_AnimationPlayer.play("idle")
