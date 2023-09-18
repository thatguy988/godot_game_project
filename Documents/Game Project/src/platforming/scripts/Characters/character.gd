extends CharacterBody2D


var tween: Tween
var idle = false

signal textbox_text
const SPEED = 200.0
const JUMP_VELOCITY = -400.0

var camera_x_offset = 125
var camera_y_offset = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var disable_controls = false
var jumpingup = true
var falling = true
@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D

func _ready():
	get_character_position()
	pass
	#global_position.x = Global.position_x
	#global_position.y = Global.position_y
	

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		# Handle Jump.
	



	
	
	if disable_controls == false:
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = JUMP_VELOCITY
			
		var direction = Input.get_axis("ui_left", "ui_right")
		
		if direction != 0:
			sprite.flip_h = (direction == -1)
			idle = false
			if direction == 1:#facing right
				camera_x_offset = 125
				move_camera_up_and_down()
				tween = create_tween()
				tween.tween_property($Camera,"offset",Vector2(camera_x_offset,camera_y_offset),1).set_trans(Tween.TRANS_LINEAR) 
			elif direction == -1:#facing left
				camera_x_offset=-125
				move_camera_up_and_down()
				tween = create_tween()
				tween.tween_property($Camera,"offset",Vector2(camera_x_offset,camera_y_offset),1).set_trans(Tween.TRANS_LINEAR) 
		elif (direction == 0):
			move_camera_up_and_down()
			if idle == false:
				idle = true
				$IdleTimer.start(5)
			
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
		move_and_slide()
		update_animation(direction)
		get_character_position()
	else:
		if Input.is_action_just_pressed("ui_select"):
			emit_signal("textbox_text")
		var direction = 0 
		velocity.x = 0
		move_and_slide()
		update_animation(direction)
		get_character_position()
	
func update_animation(direction):
	if is_on_floor():
		if direction == 0:
			ap.play("idle")
			falling = true
		else:
			ap.play("run")
			falling = true
	else:
		if velocity.y < 0 and jumpingup == true:
			ap.play("jumping up")
			jumpingup = false
			falling = true
			
		elif velocity.y > 0 and falling == true:
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
	
	
func _on_battle_transition():
	disable_controls = true


func _on_idle_timer_timeout():
	camera_x_offset = 0
	tween = create_tween()
	tween.tween_property($Camera,"offset",Vector2(camera_x_offset,camera_y_offset),1).set_trans(Tween.TRANS_LINEAR) 
	
func move_camera_up_and_down():
	if Input.is_action_just_pressed("ui_up"):
		camera_y_offset = -125
		
		tween= create_tween()
		tween.tween_property($Camera,"offset",Vector2(camera_x_offset,camera_y_offset),1).set_trans(Tween.TRANS_LINEAR)
	elif Input.is_action_just_pressed("ui_down"):
		camera_y_offset = 125
		
		tween = create_tween()
		tween.tween_property($Camera,"offset",Vector2(camera_x_offset,camera_y_offset),1).set_trans(Tween.TRANS_LINEAR)
	if Input.is_action_just_released("ui_up"):
		camera_y_offset = 0
		
		tween = create_tween()
		tween.tween_property($Camera,"offset",Vector2(camera_x_offset,camera_y_offset),1).set_trans(Tween.TRANS_LINEAR)
	elif Input.is_action_just_released("ui_down"):
		camera_y_offset = 0
		
		tween = create_tween()
		tween.tween_property($Camera,"offset",Vector2(camera_x_offset,camera_y_offset),1).set_trans(Tween.TRANS_LINEAR)
