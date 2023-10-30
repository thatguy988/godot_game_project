
extends CharacterBody2D




var direction = -1  # 1 for moving right, -1 for moving left.





@export var SPEED:int
@export var LEVEL_ID:int
@export var ENEMY_ID:int
@export var BATTLE_SCENE_PATH:String

func _ready():
	if Global.is_enemy_alive(LEVEL_ID, ENEMY_ID):
		$MovementTimer.start(5)
	else:
		queue_free()
		
func left_and_right_movement(delta):
	# Set the movement velocity based on the current direction.
	velocity.x = SPEED * direction



func load_battle_scene():
	emit_signal("battle_transition")
	#get_tree().change_scene_to_file("res://Sky_Battle_Scene.tscn")
	


func _physics_process(delta):
	left_and_right_movement(delta)
	move_and_slide()
	
	
	if velocity.x > 0:
		$AnimationPlayer.play("idle_facing_right")
	elif velocity.x < 0:
		$AnimationPlayer.play("idle_facing_left")
		
func _on_battle_collision_body_entered(body):
	Global.kill_enemy(LEVEL_ID, ENEMY_ID)
	queue_free()  # Destroy the enemy
	load_battle_scene()




	

func _on_movement_timer_timeout():
	direction = -direction
	$Sprite2D.flip_h = (direction == 1)
	$MovementTimer.stop()
	$MovementTimer.start(5)
	

