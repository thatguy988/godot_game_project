extends CharacterBody2D


const SPEED = 300.0


# Get the gravity from the project settings to be synced with RigidBody nodes.



func _physics_process(delta):
	

	

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	var vertical_direction = Input.get_axis("ui_up", "ui_down")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
	if vertical_direction:
		velocity.y = vertical_direction * SPEED
	else:
		velocity.y = move_toward(velocity.y,0,SPEED)

	move_and_slide()
