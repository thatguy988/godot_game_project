extends Node2D




var tween: Tween


var rising_position: Vector2 = Vector2(0, -250)
var original_position: Vector2 = Vector2(0, 0)
var rising_speed: float = 5.0
var sinking_speed: float = 10.0


func _on_area_2d_body_entered(body):
	tween = create_tween()
	tween.tween_property($CharacterBody2D,"position", rising_position, rising_speed).set_trans(Tween.TRANS_LINEAR)


func _on_area_2d_body_exited(body):
	tween = create_tween()
	tween.tween_property($CharacterBody2D,"position", original_position, sinking_speed).set_trans(Tween.TRANS_LINEAR)



