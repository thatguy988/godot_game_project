
extends Node

var position_x
var position_y

var companion_position_x = position_x
var companion_position_y = position_y

var companion_2_position_x = position_x
var companion_2_position_y = position_y

var checkpoint_spawn_point_x = position_x
var checkpoint_spawn_point_y = position_y



# Create a dictionary to store enemy states for each level.
# The keys are the level numbers, and the values are the arrays representing the enemy states.
var level_enemy_states = {
	1: [true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true],
	2: [true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true],

	3: [true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true],
	4: [true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true],
	5: [true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true],
	6: [true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true, true],
	7: [true, true, true, true],
	# Add more levels and their respective enemy states arrays here.
}

# Function to check if an enemy at a specific index is alive for a given level.
func is_enemy_alive(level, index):
	if level in level_enemy_states and index >= 0 and index < level_enemy_states[level].size():
		return level_enemy_states[level][index]
	return false

# Method to switch the state of an enemy at a given index from true to false for a given level.
func kill_enemy(level, index):
	if level in level_enemy_states and index >= 0 and index < level_enemy_states[level].size():
		level_enemy_states[level][index] = false

func update_checkpoint():
	checkpoint_spawn_point_x = position_x
	checkpoint_spawn_point_y = position_y
	print(checkpoint_spawn_point_x)
	print(checkpoint_spawn_point_y)
	

# Example usage:
# To check if enemy 1 is alive in Level 1, call is_enemy_alive(1, 0).
# To check if enemy 2 is alive in Level 2, call is_enemy_alive(2, 1).
# To switch the state of enemy 1 to false in Level 1, call kill_enemy(1, 0).
# To switch the state of enemy 2 to false in Level 2, call kill_enemy(2, 1).
