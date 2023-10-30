extends Node2D


var tween: Tween
var rising = true
var falling = false
@export var rising_position: Vector2
@export var falling_position: Vector2
@export var speed: int

func _ready():
	start_rising()

func setup_tween(target_pos: Vector2, duration: float, trans_type: int, ease_type: int):
	if tween:
		tween.stop()
	tween = create_tween()
	tween.tween_property($CharacterBody2D, "position", target_pos, duration).set_trans(trans_type).set_ease(ease_type)
	tween.connect("finished", on_tween_finished)

func start_rising():
	rising = true
	falling = false
	setup_tween(rising_position, speed, Tween.TRANS_CUBIC, Tween.EASE_OUT)

func on_tween_finished():
	if rising:
		start_falling()
	elif falling:
		start_rising()

func start_falling():
	rising = false
	falling = true
	setup_tween(falling_position, speed, Tween.TRANS_CUBIC, Tween.EASE_IN)



