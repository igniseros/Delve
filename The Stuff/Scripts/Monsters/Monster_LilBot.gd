extends Monster

var rotation_speed_idle = PI/2.0
var rotation_speed_attacking = PI/4.0

onready var ani = $PhysicsBody/UpperBody
onready var body = $PhysicsBody

onready var shotScene = load("res://Scenes/Effects/LilBotBoom.tscn")

var last_frame = 0
var attacking = false
var player_is_in_range = false
var walking_backwards = false

var attack_walking_multiplyer = .6

func _init().(1,75, -PI/2.0):
	pass

func ready():
	path_ref = $PhysicsBody
	search_ray = $PhysicsBody/SearchRay
	$PhysicsBody/AttackArea.connect("body_entered", self, "body_entered")
	$PhysicsBody/AttackArea.connect("body_exited", self, "body_exited")

func process(delta):
	#tell the shader to turn him white based on how long ago he was hit
	(ani.material as ShaderMaterial).set_shader_param("hitLeft", $PhysicsBody/Timer.time_left)
	#do the thing if alive and player too
	if (alive and PlayerGlobal.alive):
		if (player_is_in_range):
			attemptStartAttack()
		if (attacking):
			attack()
		search_for_player()
	#set the die things
	if (not alive):
		if ($PhysicsBody/Explosion.frame == 6):
			ani.modulate = Color(0,0,0,1)
	
	#reset memory timer, he forget player if not see him
	if (seeing_player):
		$PhysicsBody/RememberPlayer.start()
	
	#set nav_goal to player if seeing him, if not go home
	if ($PhysicsBody/RememberPlayer.time_left > 0):
		nav_goal = PlayerGlobal.PlayerPosition
	else:
		nav_goal = global_position
	
	if ($PhysicsBody/RememberPlayer.time_left > 0) and (alive):
		$PhysicsBody/UpperBody/LeftEye.energy = .5
		$PhysicsBody/UpperBody/RightEye.energy = .5
	else:
		$PhysicsBody/UpperBody/LeftEye.energy = 0
		$PhysicsBody/UpperBody/RightEye.energy = 0
	
	if (not PlayerGlobal.alive):
		$PhysicsBody/LowerBody.animation = "stop"

func body_entered(body):
	if (body.get_parent().name == "Player"):
		player_is_in_range = true

func body_exited(body):
	if (body.get_parent().name == "Player"):
		player_is_in_range =false

func attemptStartAttack():
		if (ani.frame == 15):

			attacking = true
			ani.frame = 0

func attack():
	if (ani.frame == 6) and ($PhysicsBody/LazerHum.playing == false):
		$PhysicsBody/LazerHum.play()

	if (ani.frame == 7):
		attacking = false

		var shotI : Particles2D= shotScene.instance()
		shotI.z_index = 5
		shotI.emitting = true
		shotI.position.y += 35
		shotI.rotation_degrees += 90
		$PhysicsBody/UpperBody/ShotHere.add_child(shotI)
		if (player_is_in_range):
			$"/root/PlayerGlobal".playerHit()

func hit_taken(weapon):
	$PhysicsBody/Timer.start()
	$PhysicsBody/HitSound.play()

func die():
	alive = false
	$PhysicsBody/Explosion.frame = 0
	$PhysicsBody/UpperBody/LeftEye.energy = 0
	$PhysicsBody/UpperBody/RightEye.energy = 0
	$PhysicsBody/LowerBody.animation = "stop"
	body.set_collision_layer_bit(3,false)
	body.set_collision_mask_bit(3,false)

func move(delta):
	var max_rotation = rotation_speed_idle *delta #set idle rotation speed
	if (attacking) : max_rotation = rotation_speed_attacking * delta #if attacking switch to attack rotation speed
	#look_on_path(max_rotation, rotational_offset, correctness_threshhold)
	#turns you and returns whether or not you are looking the right way based on threshhold
	var facing_correctly = look_on_path(max_rotation, deg2rad(3)) 
	if (facing_correctly):
		walk(delta)
	else:
		$PhysicsBody/LowerBody.animation = "stop"

func walk(delta):
	var current_frame = $PhysicsBody/LowerBody.frame
	var walk_vector := get_direction_on_path()
	var distance_from_goal = get_distance_to_next_path_point()
	var temp_walk_speed = walk_speed
	
	$PhysicsBody/LowerBody.animation = "go"
	
	if ((last_frame == 6) or (last_frame == 1)) and ((current_frame == 7) or (current_frame == 2)):
		$PhysicsBody/WalkSound.play()
	
	if ((is_next_path_point_goal()) and (nav_goal == PlayerGlobal.PlayerPosition)):
		#move back and forward
		if (distance_from_goal < 90):
			walking_backwards = true
		if (distance_from_goal > 100):
			walking_backwards = false
		#stop if in good area
		if (distance_from_goal < 98 and distance_from_goal > 92):
			walk_vector *= 0
	else:
		walking_backwards = false
	
	if (walking_backwards):
		walk_vector *= -1
	
	if ((distance_from_goal < walk_speed * delta) and  (not walking_backwards)):
		temp_walk_speed = distance_from_goal / delta
	
	if (attacking):
		walk_vector *= attack_walking_multiplyer
	
	if ((temp_walk_speed == 0) or (walk_vector == Vector2(0,0))):
		$PhysicsBody/LowerBody.animation = "stop"
	
	last_frame = $PhysicsBody/LowerBody.frame
	body.move_and_slide(walk_vector * temp_walk_speed)
