extends Node2D

var already_passed = false


func _on_area_2d_body_entered(body):
	print("Checkpoint reached")
	
	Global.update_checkpoint()
	queue_free() #instead of using already_passed just destory object
	#if you want to keep checkpoint flag in world use already_passed
	# if already_passed == false:
	# Global.update_checkpoint()
	# already_passed = true

func _on_area_2d_body_exited(body):
	print("Continue onward")
