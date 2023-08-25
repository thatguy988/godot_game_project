extends CharacterBody2D

@export var movement_speed: float = 200.0
@export var movement_target: Node2D
@export var navigation_agent: NavigationAgent2D
var max_target_distance: float = 1000.0  # Define the maximum distance to consider a target unreachable.

@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D



func _ready():
	navigation_agent.path_desired_distance = 20.0
	navigation_agent.target_desired_distance = 20.0
#	global_position.x = Global.companion_position_x
#	global_position.y = Global.companion_position_y
	call_deferred("actor_setup")

func actor_setup():
	await get_tree().physics_frame
	set_movement_target(movement_target.global_position)
	


func set_movement_target(target_point: Vector2):
	if global_position.distance_to(target_point) > max_target_distance:
		# Target is too far, reset the target_position to a new location.
		find_new_target_position()
		#navigation_agent.target_position.x = movement_target.global_position.x
		navigation_agent.target_position.x = target_point.x
		navigation_agent.target_position.y = target_point.y - 25

	else:
		navigation_agent.target_position.x = target_point.x
		navigation_agent.target_position.y = target_point.y - 25



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
	velocity = new_velocity
	
	
	
	var direction = 0
	if velocity.x < 0:
		direction = 1  # Moving left.
	elif velocity.x > 0:
		direction = -1  # Moving right.

	# Set the sprite flip_h based on the direction.
	sprite.flip_h = (direction == -1)

	
	
	
	move_and_slide()
	get_companion_position()
	update_animation()
	call_deferred("actor_setup")


func get_companion_position():
	Global.companion_position_x = global_position.x
	Global.companion_position_y = global_position.y


func update_animation():
	ap.play("idle")
	

func _on_timer_timeout():
	pass
	#call_deferred("actor_setup")

