extends Node2D

var already_passed = false


func _on_area_2d_body_entered(body):
	print("Checkpoint reached")
	if already_passed == false:
		Global.update_checkpoint()
		already_passed = true


func _on_area_2d_body_exited(body):
	print("Continue onward")
