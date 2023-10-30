extends CharacterBody2D


signal battle_transition #connect to player and level node
#make sure animation player has signal connect to each enemy when animation is finished change to specific scene


# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")



@export var LEVEL_ID:int
@export var ENEMY_ID:int
@export var BATTLE_SCENE_PATH: String
@export var facing_direction: int # 1 for true 0 for false

func _ready():
	if Global.is_enemy_alive(LEVEL_ID, ENEMY_ID):
		$Sprite2D.flip_h = facing_direction
		var animation_names = {0: "idle_facing_left", 1: "idle_facing_right"}
		var animation_name = animation_names.get(facing_direction, "default_animation_name")
		$AnimationPlayer.play(animation_name)
	else:
		queue_free()
		
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta


func _on_top_collision_body_entered(body):
	Global.kill_enemy(LEVEL_ID, ENEMY_ID)
	queue_free()


func load_battle_scene():
	Global.kill_enemy(LEVEL_ID, ENEMY_ID)
	emit_signal("battle_transition")


	
func _on_animation_player_animation_finished(anim_name):
	if anim_name == "fade_out":
		get_tree().change_scene_to_file(BATTLE_SCENE_PATH)



func _on_player_enemy_collision_body_entered(body):
		# Check if the enemy is positioned below the player
		var enemy_position = position
		var player_position = body.position
#		var enemy_position = global_transform.origin
#		var player_position = body.global_transform.origin
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
			


