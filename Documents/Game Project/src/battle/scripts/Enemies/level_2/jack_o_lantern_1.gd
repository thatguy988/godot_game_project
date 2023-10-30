extends Sprite2D



# Flag to prevent playing animations after the enemy is dead
var isdead = false

func _on_enemy_animation_player_animation_finished(anim_name):
	# If the animation isn't "Dead" and the enemy is not dead, play the "idle" animation.
	if anim_name != "Dead" and not isdead:
		$Enemy_Animation_Player.play("idle")
	# If the animation is "Dead," set the isdead flag to true.
	elif anim_name == "Dead":
		isdead = true
