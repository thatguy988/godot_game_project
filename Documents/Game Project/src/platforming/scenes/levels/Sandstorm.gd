extends Area2D


@export var SandTimer: float
@export var TimeBeforeStart: float
@export var speed_default: int
@export var speed_up: int


func _on_body_entered(body):
	print("_on_body_entered")
	$TimeBeforeStart.start(TimeBeforeStart)


func _on_body_exited(body):
	print("_on_body_exited in here")
	$TimeBeforeStart.stop()
	$SandTimer.stop()


func _on_time_before_start_timeout():
	$Sand.speed_scale = speed_up
	print("_on_time_before_start_timeout")
	$TimeBeforeStart.stop()
	$SandTimer.start(SandTimer)


func _on_sand_timer_timeout():
	$Sand.speed_scale = speed_default
	$SandTimer.stop()
	$TimeBeforeStart.start(TimeBeforeStart)
