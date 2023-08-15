extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var jumpingup = true
var falling = true
@onready var ap = $AnimationPlayer
@onready var sprite = $Sprite2D

func _ready():
	global_position.x = Global.position_x
	global_position.y = Global.position_y

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		


	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	#sprite.flip_h mirror sprite
	if direction != 0:
		sprite.flip_h = (direction == -1)
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED) 
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
	
	


