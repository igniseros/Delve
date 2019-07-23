extends Monster

onready var body = $PhysicsBody
onready var ani = $PhysicsBody/Sprite
onready var memory_timer = $"PhysicsBody/Remember Player"
onready var hit_area = $PhysicsBody/HitPlayer
onready var attack_area = $"PhysicsBody/Attack Player"
onready var the_search_ray = $"PhysicsBody/Search Ray"

enum {IDLE, ATTACKING, ROTATING, ROT2WALK ,WALKING_TO_PLAYER, WALKING_HOME, DEAD}
const ROTATION_SPEED_ROTATING = 2 * PI
const ROTATION_SPEED_WALKING = 1 * PI
const WANTED_SPACE_FROM_PLAYER = 100 #how far away the monster wants to stay from the player

var state = IDLE
var changed_state = false
var remember_player = false
var player_attackable = false
var player_hittable = false
var player_hit_this_attack = false


func _init().(5,150):
	pass

func ready():
	path_ref = $PhysicsBody
	search_ray = $"PhysicsBody/Search Ray"
	nav_goal = PlayerGlobal.PlayerPosition
	
	$"PhysicsBody/Attack Player".connect("body_entered", self, "player_in_range")
	$"PhysicsBody/Attack Player".connect("body_exited", self, "player_out_of_range")
	$"PhysicsBody/HitPlayer".connect("body_entered", self, "player_in_hurt_range")
	$"PhysicsBody/HitPlayer".connect("body_exited", self, "player_out_of_hurt_range")

func process(delta):
	#hit shader
	(ani.material as ShaderMaterial).set_shader_param("hitLeft", $PhysicsBody/SinceHit.time_left)
	
	if (state != DEAD):
		#duh
		search_for_player()
		#time how long since seen
		if (seeing_player):
			memory_timer.start()
		#check time and see if he remembers player else he doesn't
		if (memory_timer.time_left > 0) or (seeing_player):
			remember_player = true
			$PhysicsBody/PlayerLight.energy = .5
		else:
			remember_player = false
			$PhysicsBody/PlayerLight.energy = 0.0
		#nav goal setting based on knowing where player is
		if (remember_player):
			nav_goal = PlayerGlobal.PlayerPosition
		else:
			nav_goal = global_position
		#set anim on death
		if (not alive) and (ani.frame == ani.frames.get_frame_count(ani.animation) - 1):
			ani.play("idle")
		# attempt if you should
		if (player_attackable):
			attempt_attack()
		# attack if attacking
		if (state == ATTACKING):
			attack()
	
	
	
	if (state == DEAD):
		var c = 1.0 - (float(ani.frame) / 13.0)
		ani.modulate = Color(c,c,c,1.0)

#------------------
# Combat Functions
#------------------

func hit_taken(weapon):
	$PhysicsBody/SinceHit.start()

func die():
	state = DEAD
	body.set_collision_layer_bit(3,false)
	body.set_collision_mask_bit(3,false)
	$PhysicsBody/PlayerLight.energy = 0
	ani.play("die")

#---------------------
# MOVEMENT FUNCTIONS
#---------------------
func move(delta):
	
	if (state != ATTACKING):
		not_attacking_movement(delta)
		if (body.global_position == nav_goal):
			state = IDLE

func not_attacking_movement(delta):
	var facing_correctly = look_on_path(0,deg2rad(30))
	if (state == ROTATING): facing_correctly = look_on_path(0,deg2rad(5))
	#if you're not facing correctly and you aren't already rotating, set state to rotate
	if (!facing_correctly and state != ROTATING):
		state = ROTATING
		changed_state = true
	
	if (state == ROTATING):
		execute_rotation(delta, facing_correctly)
	
	if (state == ROT2WALK):
		rot2walk(facing_correctly)
	
	if (state == WALKING_TO_PLAYER or state == WALKING_HOME):
		walk(delta)

func execute_rotation(delta, facing_correctly):
	if (changed_state):
		changed_state = false
		ani.play("rotation_ends", false)
	
	if (ani.frame == 0 and !facing_correctly):
		ani.play("rotation_ends", false)
	
	if (ani.frame == 3 and !facing_correctly):
		look_on_path(ROTATION_SPEED_ROTATING * delta)
	
	if (facing_correctly and ani.frame == 3):
		ani.play("rotation_ends", true)
		state = ROT2WALK
		changed_state = true

func rot2walk(facing_correctly):
	changed_state = false
	if (facing_correctly and ani.frame == 0):
		if (remember_player):
			changed_state = true
			state = WALKING_TO_PLAYER
		else:
			changed_state = true
			state = WALKING_HOME

func walk(delta):
	
	var goal := path[0]
	var distance_next_step = walk_speed * delta
	var temp_walk_speed = walk_speed
	var direction = get_direction_on_path()
	var walking_backwards = false
	
	ani.play("walking")
	
	look_on_path(ROTATION_SPEED_WALKING * delta)
	
	if (is_next_path_point_goal() and state == WALKING_TO_PLAYER):
		goal -= get_direction_on_path() * WANTED_SPACE_FROM_PLAYER
		walking_backwards = true
	
	var distance_to_goal = path_ref.global_position.distance_to(goal)
	
	if (distance_next_step > distance_to_goal):
		temp_walk_speed = distance_to_goal / delta
	
	if (distance_to_goal < 20 and is_next_path_point_goal()):
			temp_walk_speed *= 0
	
	direction = path_ref.global_position.direction_to(goal)
	
	if (temp_walk_speed == 0):
		ani.play("idle")
	
	body.move_and_slide(direction * temp_walk_speed)

#------------------
# Attack Functions
#------------------

func player_in_range(obj):
	player_attackable = true

func player_out_of_range(obj):
	player_attackable = false

func player_in_hurt_range(obj):
	player_hittable = true

func player_out_of_hurt_range(obj):
	player_hittable = false

func attempt_attack():
	if (state != ATTACKING):
		if (state == ROTATING):
			ani.play("rotation_ends", true)
		state = ATTACKING
		changed_state = true

func attack():
	if (changed_state) and (ani.frame == 0):
			ani.play("attacking")
			changed_state = false
	
	if (ani.frame == 11):
		if (player_hittable) and (not player_hit_this_attack):
			PlayerGlobal.playerHit()
			player_hit_this_attack = true
	
	if (ani.frame == 23):
		state = IDLE
		player_hit_this_attack = false