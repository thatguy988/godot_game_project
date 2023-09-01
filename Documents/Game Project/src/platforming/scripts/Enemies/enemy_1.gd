extends "res://src/platforming/scripts/Enemies/enemy.gd"

const SPEED = 50.0
var MOVE_DISTANCE = 100.0  # The distance the enemy will move left and right before changing direction.
var remaining_distance = MOVE_DISTANCE


func _ready():
	if Global.is_enemy_alive(1, 0):
		pass
	else:
		queue_free()
#	

func left_and_right_movement(delta):
		# Update the remaining distance to move.
	remaining_distance -= abs(velocity.x) * delta

	# If the enemy has moved the desired distance in the current direction, change direction.
	if remaining_distance <= 0:
		direction = -direction
		remaining_distance = MOVE_DISTANCE
		$Sprite2D.flip_h = (direction == 1)
		

	# Set the movement velocity based on the current direction.
	velocity.x = SPEED * direction


func _on_top_collision_body_entered(body):
	Global.kill_enemy(1, 0)
	queue_free()


func load_battle_scene():
	Global.kill_enemy(1, 0)
	get_tree().change_scene_to_file("res://src/battle/scenes/Battle_Zones/forest_battle_scene.tscn")
