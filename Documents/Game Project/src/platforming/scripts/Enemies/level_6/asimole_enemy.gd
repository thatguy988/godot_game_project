extends CharacterBody2D

signal battle_transition #connect to player and level node
#make sure animation player has signal connect to each enemy when animation is finished change to specific scene

var direction = 1  # 1 for moving right, -1 for moving left.

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")



@export var LEVEL_ID:int
@export var ENEMY_ID:int
@export var SPEED:int
@export var BATTLE_SCENE_PATH: String

func _ready():
	if Global.is_enemy_alive(LEVEL_ID, ENEMY_ID):
		$MovementTimer.start(5)
	else:
		queue_free()


func load_battle_scene():
	Global.kill_enemy(LEVEL_ID, ENEMY_ID)
	emit_signal("battle_transition")

func left_and_right_movement(delta):
	# Set the movement velocity based on the current direction.
	velocity.x = SPEED * direction
	
	
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_out":
		get_tree().change_scene_to_file(BATTLE_SCENE_PATH)

	
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	left_and_right_movement(delta)
	# Move the enemy.
	move_and_slide()
	change_direction()
	
	if velocity.x > 0:
		$AnimationPlayer.play("walking_right")
	elif velocity.x < 0:
		$AnimationPlayer.play("walking_left")
	elif velocity.x == 0:
		$AnimationPlayer.play("idle")




var Raycast5enabled = true
var Raycast6enabled = true

# Function to toggle raycast states
func toggle_raycasts(enabled1, enabled2, enabled3, enabled4, enabled5, enabled6):
	$RayCast2D.enabled = enabled1
	$RayCast2D2.enabled = enabled2
	$RayCast2D3.enabled = enabled3
	$RayCast2D4.enabled = enabled4
	Raycast5enabled = enabled5
	Raycast6enabled = enabled6
	
	
	direction = -direction
	$Sprite2D.flip_h = (direction == 1)
	$MovementTimer.stop()
	$MovementTimer.start(5)


# Check collisions and update raycast states
func change_direction():
	var is_colliding_12 = $RayCast2D.is_colliding() or $RayCast2D2.is_colliding() 
	var is_colliding_34 = $RayCast2D3.is_colliding() or $RayCast2D4.is_colliding() 
	var is_colliding_56 = $RayCast2D5.is_colliding() and $RayCast2D6.is_colliding()

	# Determine which raycasts to enable or disable
	if not is_colliding_56:
		if not $RayCast2D5.is_colliding() and Raycast5enabled:
			toggle_raycasts(false, false, true, true, false, true)
		elif not $RayCast2D6.is_colliding() and Raycast6enabled:
			toggle_raycasts(true, true, false, false, true, false)
	elif is_colliding_12:
		toggle_raycasts(false, false, true, true, false, true)
	elif is_colliding_34:
		toggle_raycasts(true, true, false, false, true, false)

func _on_movement_timer_timeout():
	direction = -direction
	if direction == 1:
		timer_toggle_raycasts(true, true, false, false, true, false)
	elif direction == -1:
		timer_toggle_raycasts(false, false, true, true, false, true)
	$Sprite2D.flip_h = (direction == 1)
	$MovementTimer.stop()
	$MovementTimer.start(5)
	
# Function to toggle raycast states
func timer_toggle_raycasts(enabled1, enabled2, enabled3, enabled4, enabled5, enabled6):
	$RayCast2D.enabled = enabled1
	$RayCast2D2.enabled = enabled2
	$RayCast2D3.enabled = enabled3
	$RayCast2D4.enabled = enabled4
	Raycast5enabled = enabled5
	Raycast6enabled = enabled6



func _on_player_enemy_collision_body_entered(body):
		# Check if the enemy is positioned below the player
		var enemy_position = global_transform.origin
		var player_position = body.global_transform.origin

		print(enemy_position)
		print(player_position)
		
		if enemy_position.y > player_position.y:
			print("kill the enemy")
			Global.kill_enemy(LEVEL_ID, ENEMY_ID)
			queue_free()  # Destroy the enemy, you might have other logic here
			# Enemy landed on top of the player, so kill the player
			# Implement your logic for player death here
		else:
			print("go to battle scene")
			#load_battle_scene()
			# Player entered from the top, so kill the enemy

