extends CharacterBody2D

@export var chase_speed = 100

var player = null
var player_chase = null

var direction = 1  # 1 for moving right, -1 for moving left.
var home_position
var at_home = true
var prev_position
var target_x

# Define a variable for flipping the sprite
@onready var flip_sprite = $Sprite2D



@export var SPEED:int
@export var LEVEL_ID:int
@export var ENEMY_ID:int
@export var BATTLE_SCENE_PATH:String

func _ready():
	if Global.is_enemy_alive(LEVEL_ID, ENEMY_ID):
		home_position = global_position
		$MovementTimer.start(5)
	else:
		queue_free()
		
func left_and_right_movement(delta):
	# Set the movement velocity based on the current direction.
	velocity.x = SPEED * direction



func load_battle_scene():
	print("load battle scene")
	#get_tree().change_scene_to_file("res://Sky_Battle_Scene.tscn")
	pass


func _physics_process(delta):
	if player_chase:
		face_towards_player()
		position += (player.position - position) / chase_speed
		at_home = false
	elif not player_chase and not at_home:
		face_towards_home()
		prev_position = position
		position += (home_position - position) / chase_speed
		if prev_position.y == position.y:
			flip_sprite.flip_h = 0
			at_home = true
	elif not player_chase and at_home:
		left_and_right_movement(delta)
		#change_direction()
		
	move_and_slide()
	
	
	if velocity.x > 0:
		$AnimationPlayer.play("idle_right")
	elif velocity.x < 0:
		$AnimationPlayer.play("idle_left")
		




func _on_player_detected_body_entered(body):
	player = body
	player_chase = true

func _on_player_lost_body_exited(body):
	player = null
	player_chase = false

func face_towards_player():
	if target_x > global_position.x:
		flip_sprite.flip_h = 0
	elif target_x < global_position.x:
		flip_sprite.flip_h = 1

func face_towards_home():
	if target_x > global_position.x:
		flip_sprite.flip_h = 0
	elif target_x < global_position.x:
		flip_sprite.flip_h = 1

func _on_timer_timeout():
	target_x = global_position.x

func _on_movement_timer_timeout():
	direction = -direction
	flip_sprite.flip_h = (direction == 1)
	$MovementTimer.start(5)
	


func _on_player_enemy_collision_body_entered(body):
	load_battle_scene()
