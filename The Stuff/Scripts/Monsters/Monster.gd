extends Node2D

class_name Monster

var alive : bool
var health : float
var walk_speed : float

var path_ref : Node2D
var path_to_player : PoolVector2Array

func _init(_health = 1, _walk_speed = 50 , _alive = true).():
	health = _health
	walk_speed = _walk_speed
	alive = _alive

func _ready():
	ready()
	set_process(true)

func _process(delta):
	path_to_player = get_path_to_player()
	path_to_player.remove(0)
	process(delta)
	if (alive and PlayerGlobal.alive):
		move(delta)

func get_path_to_player() -> PoolVector2Array: 
	return get_parent().find_node("Navigation2D").get_simple_path(
				path_ref.global_position,PlayerGlobal.PlayerPosition) #get path

func get_direction_on_path() -> Vector2: 
	return (path_to_player[0] - path_ref.global_position).normalized()

func get_distance_to_next_path_point() -> float:
	return path_ref.global_position.distance_to(path_to_player[0])

func get_direction_to_player() -> Vector2:
	return (PlayerGlobal.PlayerPosition - path_ref.global_position).normalized()

func is_next_path_point_player() -> bool:
	return path_to_player.size() == 1

func take_hit(weapon):
	if (alive):
		health -= $"/root/Items".ArmData[weapon]["DMG"]
		if (health <= 0):
			die()
	hit_taken(weapon)

func look_on_path(max_rotation = 0 ,rotational_offset = 0, correcness_threshold = 0) -> bool:
	var old_rotation = path_ref.rotation #get old rotation
	var goal_rotation = get_direction_on_path().angle() + rotational_offset #get goal rotation
	old_rotation = fmod(old_rotation, 2*PI) #keep in 2pi range
	goal_rotation = fmod(goal_rotation, 2*PI)
	if (old_rotation < 0): old_rotation += 2*PI #keep positive
	if (goal_rotation < 0): goal_rotation += 2*PI
	
	var rotational_difference = goal_rotation - old_rotation
	var rotation_direction = 0
	if (abs(rotational_difference) > 0):
		rotation_direction = rotational_difference / abs(rotational_difference) #get rotation direction
	
	if (abs(fmod(rotational_difference, 2*PI)) > PI): #if your gonna spin more than 180 deg, go the other way
		rotation_direction *= -1
	
	
	
	path_ref.rotate(abs(rotational_difference) * rotation_direction)
	if (abs(rotational_difference) > max_rotation): #if too fast rotation
		path_ref.rotation = old_rotation #reset rotation
		path_ref.rotate(rotation_direction * max_rotation) #rotate with new stuff
	
	return abs(rotational_difference) <= correcness_threshold

func ready():
	pass

func process(delta): #process for you
	pass

func move(delta):
	pass

func hit_taken(weapon): #take hit for you
	pass

func die():
	pass