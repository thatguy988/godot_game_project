extends CharacterBody2D

# Constants
const SPEED = 200.0
const JUMP_VELOCITY = -400.0

# Tweens
var tween: Tween

# Booleans
var idle = false
var disable_controls = false
var jumpingup = true
var falling = true

# Camera Settings
var camera_x_offset = 125
var camera_y_offset = 0
var camera_movement_speed = 2  # Lower number equals faster

# Gravity Settings
var gravity_direction = 1
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# Animation Player and Sprite
@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D

# Signal
signal textbox_text

#level 5 sand wind
var SANDSTORM_RESISTANCE = 100


func _ready():
	get_character_position()
	pass
	#global_position.x = Global.position_x
	#global_position.y = Global.position_y



var direction = 0  # Initialize direction here
var in_sandstorm = 0 #sandstorm blows player left or right
var in_sandstorm_2 = 0 #sandstorm blows players up or down




func _physics_process(delta):
	# Add the gravity.
	velocity.y += gravity * delta * gravity_direction

	
	if disable_controls == false:
		handle_player_input()
		move_and_slide()
		update_animation(direction)
		get_character_position()
	else:
		handle_disabled_controls()
		move_and_slide()
		update_animation(0)
		get_character_position()

func handle_player_input():
	handle_jump(Input.is_action_just_pressed("ui_accept") and is_on_floor())
	
	direction = Input.get_axis("ui_left", "ui_right")
	handle_movement(direction)
	handle_camera_movement(direction)

func handle_jump(jump_condition):
	if in_sandstorm_2 != 0:
		handle_sandstorm_vertical_movement(in_sandstorm_2)
	elif jump_condition:
		velocity.y = JUMP_VELOCITY * gravity_direction
	

func handle_movement(direction):
	if in_sandstorm != 0:
		handle_sandstorm_movement(direction, in_sandstorm)
	elif direction:
		handle_regular_movement(direction)
	else:
		handle_idle_movement()



func handle_sandstorm_movement(direction, direction_multiplier):
	sprite.flip_h = (direction_multiplier == -1)
	idle = false
	velocity.x = direction * SPEED - (direction_multiplier * SANDSTORM_RESISTANCE)

func handle_sandstorm_vertical_movement(direction_multiplier):
	velocity.y = (direction_multiplier * SANDSTORM_RESISTANCE)


func handle_regular_movement(direction):
	sprite.flip_h = (direction == -1)
	idle = false
	velocity.x = direction * SPEED

func handle_idle_movement():
	velocity.x = move_toward(velocity.x, 0, SPEED)

func handle_camera_movement(direction):
	if direction:
		camera_x_offset = direction * 125
		move_camera_up_and_down()
		tween = create_tween()
		tween.tween_property($Camera, "offset", Vector2(camera_x_offset, camera_y_offset), camera_movement_speed).set_trans(Tween.TRANS_LINEAR)
	else:
		move_camera_up_and_down()
		if not idle:
			idle = true
			$IdleTimer.start(5)

func handle_disabled_controls():
	if Input.is_action_just_pressed("ui_select"):
		emit_signal("open_textbox")
	
		
func update_animation(direction):
	if is_on_floor():
		if direction == 0:
			ap.play("idle")
		else:
			ap.play("run")
		falling = true
	else:
		# Simplify the conditions using gravity_direction
		if gravity_direction == 1:
			update_animation_air(velocity.y < 0, "jumping up")
		elif gravity_direction == -1:
			update_animation_air(velocity.y > 0, "jumping up")

func update_animation_air(condition, animation_name):
	if condition and jumpingup:
		ap.play(animation_name)
		jumpingup = false
		falling = true
	elif not condition and falling:
		ap.play("falling")
		jumpingup = true
		falling = false


func get_character_position():
	Global.position_x = global_position.x
	Global.position_y = global_position.y
	
	
func _on_top_collision_body_entered(body): #when land on enemy head then let character bounce off
	velocity.y = JUMP_VELOCITY


func _on_out_of_bounds_body_entered(body):
	global_position.x = Global.checkpoint_spawn_point_x
	global_position.y = Global.checkpoint_spawn_point_y


func _on_area_2d_body_entered(body):
	disable_controls = true
	velocity = Vector2(0,0)
	
	
func _on_battle_transition():
	disable_controls = true
	velocity = Vector2(0,0)


func _on_idle_timer_timeout():
	camera_x_offset = 0
	tween_camera_offset(Vector2(camera_x_offset, camera_y_offset))

func move_camera_up_and_down():
	if Input.is_action_just_pressed("ui_up"):
		tween_camera_offset(Vector2(camera_x_offset, -125))
	elif Input.is_action_just_pressed("ui_down"):
		tween_camera_offset(Vector2(camera_x_offset, 125))
	
	if Input.is_action_just_released("ui_up") or Input.is_action_just_released("ui_down"):
		tween_camera_offset(Vector2(camera_x_offset, 0))

func tween_camera_offset(new_offset: Vector2):
	camera_y_offset = new_offset.y
	
	var newTween = create_tween()
	newTween.tween_property($Camera, "offset", new_offset, camera_movement_speed).set_trans(Tween.TRANS_LINEAR)


func _on_reverse_gravity_switch_body_entered(body):
	gravity_direction = -1
	$Sprite2D.flip_v = true
	$Sprite2D.offset.y = 18
	set_up_direction(Vector2(0, 1))

func _on_normal_gravity_switch_body_entered(body):
	gravity_direction = 1
	$Sprite2D.flip_v = false
	$Sprite2D.offset.y = 0
	set_up_direction(Vector2(0, -1))


# Constants
const SANDSTORM_ENABLED_RIGHT = -1
const SANDSTORM_DISABLED = 0
const SANDSTORM_ENABLED_LEFT = 1
const SANDSTORM_VERTICAL_DOWN = 1
const SANDSTORM_VERTICAL_UP = -1
const SANDSTORM_BLOW_LEFT = 200
const SANDSTORM_BLOW_RIGHT = 1200
const SANDSTORM_BLOW_RIGHT_1 = 100
const DEFAULT_RESISTANCE = 1
const SANDSTORM_BLOW_UP = 400


# Signals
func enable_sandstorm(direction, resistance):
	print("enable sandstorm")
	in_sandstorm = direction
	SANDSTORM_RESISTANCE = resistance

func disable_sandstorm():
	print("disable sandstorm")
	in_sandstorm = SANDSTORM_DISABLED
	SANDSTORM_RESISTANCE = DEFAULT_RESISTANCE

func enable_vertical_sandstorm(direction, resistance):
	print("enable vertical sandstorm")
	in_sandstorm_2 = direction
	SANDSTORM_RESISTANCE = resistance
	

func disable_vertical_sandstorm():
	print("disable vertical sandstorm")
	in_sandstorm_2 = SANDSTORM_DISABLED
	

# Handlers
func _on_sandstorm_body_entered(body,argument1,argument2):
	print(argument1)
	print(argument2)
	enable_sandstorm(argument1, argument2)
	
func _on_sandstorm_vertical_body_entered(body,argument1,argument2):
	print("on sandstorm vertical body entered")
	enable_vertical_sandstorm(argument1, argument2)


func _on_sandstorm_body_exited(body):
	disable_sandstorm()
	
	
func _on_sandstorm_vertical_body_exited(body):
	print("on sandstorm vertical body exited")
	disable_vertical_sandstorm()
	
	
# Timers

func _on_sand_timer_timeout():
	print("on sand timer timeout")
	disable_sandstorm()

func _on_time_before_start_timeout(arguement1,arguement2):
	print(" on time before start timeout")
	enable_sandstorm(arguement1, arguement2)


func _on_fireball_collision_body_entered(body):
	print("collision with fireball")


func _on_hazard_body_entered(body):
	print("collision with hazard")



