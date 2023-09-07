extends CharacterBody2D

signal battle_transition #connect to player and level node
#make sure animation player has signal connect to each enemy when animation is finished change to specific scene

var direction = 1  # 1 for moving right, -1 for moving left.

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready():
	pass

func left_and_right_movement(delta):
	pass
	
	
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
	left_and_right_movement(delta)
		
#	# Check for collisions in the desired direction (velocity).
#	var collision = move_and_collide(velocity * delta)
#	velocity.x = SPEED * modifier
#
#	# If there is a collision, reverse the enemy's direction.
#	if collision:
#		print("Collision")
#		modifier = -modifier

	# Move the enemy.
	move_and_slide()
	if velocity.x > 0:
		$AnimationPlayer.play("walking")

func _on_top_collision_body_entered(body):
	pass
	
func _on_bottom_collision_body_entered(body):
	load_battle_scene()

func _on_left_collision_body_entered(body):
	load_battle_scene()

func _on_right_collision_body_entered(body):
	load_battle_scene()

func load_battle_scene():
	pass



