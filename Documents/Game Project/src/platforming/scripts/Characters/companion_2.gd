extends CharacterBody2D



@export var movement_speed: float = 200.0
@export var movement_target: Node2D
@export var navigation_agent: NavigationAgent2D
var max_target_distance: float = 500.0  # Define the maximum distance to consider a target unreachable.


#const SPEED = 200.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var jumping = true
var jumpingup = true
var falling = true
@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D
@onready var jumpraycast = $JumpRaycast
@onready var jumpraycast2 = $JumpRaycast2
@onready var jumpraycast3 = $JumpRaycast3
@onready var jumpraycast5 = $JumpRaycast5

func _ready():
	navigation_agent.path_desired_distance = 40.0
	navigation_agent.target_desired_distance = 10.0
	global_position.x = Global.companion_2_position_x
	global_position.y = Global.companion_2_position_y
	call_deferred("actor_setup")

func actor_setup():
	await get_tree().physics_frame
	set_movement_target(movement_target.global_position)

func set_movement_target(target_point: Vector2):
	if global_position.distance_to(target_point) > max_target_distance:
		# Target is too far, reset the target_position to a new location.
		find_new_target_position()
		navigation_agent.target_position.x = target_point.x 
		navigation_agent.target_position.y = target_point.y - 10
	else:
		navigation_agent.target_position.x = target_point.x 
		navigation_agent.target_position.y = target_point.y - 10


func find_new_target_position():
	
	global_position.x = Global.position_x
	global_position.y = Global.position_y

func _physics_process(delta):
	
	if navigation_agent.is_navigation_finished():
		call_deferred("actor_setup")
		return
	var current_agent_position: Vector2 = global_position
	var next_path_position: Vector2 = navigation_agent.get_next_path_position()
	var new_velocity: Vector2 = next_path_position - current_agent_position
	new_velocity = new_velocity.normalized()
	new_velocity = new_velocity * movement_speed
	velocity.x = new_velocity.x
	
	if not is_on_floor():
		velocity.y += gravity * delta
		
	if (jumpraycast3.is_colliding() or jumpraycast5.is_colliding()) and jumping == false:
		if is_on_floor():
			velocity.y = JUMP_VELOCITY
			jumping = true
	if (jumpraycast.is_colliding() and jumpraycast2.is_colliding()) and jumping == true:
		if is_on_floor():
			jumping = false
	else:
		if not is_on_floor() and (jumping == false):
			velocity.y = JUMP_VELOCITY
			jumping = true
#	else:
#		if not is_on_floor():
#			velocity.y = JUMP_VELOCITY
#			jumping = true
	

	
	# Get the direction based on the sign of velocity.x.
	var direction = 0
	if velocity.x < 0:
		direction = -1  # Moving left.
	elif velocity.x > 0:
		direction = 1  # Moving right.

	# Set the sprite flip_h based on the direction.
	sprite.flip_h = (direction == -1)

	move_and_slide()
	update_animation(direction)
	get_character_position()
	call_deferred("actor_setup")
	
func update_animation(direction):
	if is_on_floor():
		if direction == 0:
			ap.play("idle")
			falling = true
		else:
			ap.play("walking")
			falling = true
#	else:
#		if velocity.y < 0 and jumpingup == true:
#			ap.play("jumping up")
#			jumpingup = false
#			falling = true
#
#		elif velocity.y > 0 and falling == true:
#			ap.play("falling")
#			jumpingup = true
#			falling = false

func get_character_position():
	Global.companion_2_position_x = global_position.x
	Global.companion_2_position_y = global_position.y



