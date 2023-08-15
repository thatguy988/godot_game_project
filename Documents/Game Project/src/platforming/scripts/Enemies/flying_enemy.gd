extends CharacterBody2D

@export var speed = 100
@export var navigation_agent: NavigationAgent2D


var player = null
var player_chase = null

var direction = 1  # 1 for moving right, -1 for moving left.
var home_position
var at_home = true
var prev_position

func left_and_right_movement(delta):
	pass
	
func reset_movement():
	pass

func _physics_process(delta):
	if player_chase:
		position += (player.position - position)/speed
		at_home = false
	elif not player_chase and not at_home:
		prev_position = position
		position += (home_position - position)/speed
		if prev_position.y == position.y:
			at_home = true
			reset_movement()
	elif not player_chase and at_home:
		left_and_right_movement(delta)
	move_and_slide()




func _on_left_collision_body_entered(body):
	load_battle_scene()

func _on_right_collision_body_entered(body):
	load_battle_scene()

func _on_bottom_collision_body_entered(body):
	load_battle_scene()

func _on_top_collision_body_entered(body):
	pass
	
	
func load_battle_scene():
	pass
	

func _on_player_detected_body_entered(body):
	player = body 
	player_chase = true

func _on_player_lost_body_exited(body):
	player = null 
	player_chase = false
