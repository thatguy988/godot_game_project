extends Node2D

func _on_battle_transition():#make contact with enemy
	$Transition/AnimationPlayer.play("fade_out")
