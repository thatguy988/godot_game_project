extends "res://src/platforming/scripts/Enemies/flying_enemy.gd"

const SPEED = 50.0
var MOVE_DISTANCE = 100.0  # The distance the enemy will move left and right before changing direction.
var remaining_distance = MOVE_DISTANCE


func _ready():
	if Global.is_enemy_alive(1, 2):
		home_position = global_position 
	else:
		queue_free()

func reset_movement():
	MOVE_DISTANCE = 100.0
	remaining_distance = MOVE_DISTANCE
	
func left_and_right_movement(delta):
	# Update the remaining distance to move.
	remaining_distance -= abs(velocity.x) * delta

	# If the enemy has moved the desired distance in the current direction, change direction.
	if remaining_distance <= 0:
		direction = -direction
		$Dragonfly1.flip_h = (direction == 1)
		remaining_distance = MOVE_DISTANCE

	# Set the movement velocity based on the current direction.
	velocity.x = SPEED * direction

func _on_top_collision_body_entered(body):
	Global.kill_enemy(1, 2)
	queue_free()

func load_battle_scene():
	#get_tree().change_scene_to_file("res://Sky_Battle_Scene.tscn")
	pass
