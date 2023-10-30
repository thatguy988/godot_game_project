extends Node2D


var tween: Tween


var sink_position: Vector2 = Vector2(0, 500)
var original_position: Vector2 = Vector2(0, 0)
var sink_speed: float = 5.0
var float_up_speed: float = 10.0


func _on_area_2d_body_entered(body):
	tween = create_tween()
	tween.tween_property($CharacterBody2D,"position", sink_position, sink_speed).set_trans(Tween.TRANS_LINEAR)


func _on_area_2d_body_exited(body):
	tween = create_tween()
	tween.tween_property($CharacterBody2D,"position", original_position, float_up_speed).set_trans(Tween.TRANS_LINEAR)
