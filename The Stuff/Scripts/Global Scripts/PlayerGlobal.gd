extends Node

var WalkSpeed = 100
var ShotFreqThresh = 10
var PlayerPosition = Vector2(0,0)

#---------------
#Gets and sets
#---------------
func get_WalkSpeed():
	return WalkSpeed
func set_WalkSpeed(x):
	WalkSpeed = x

func get_ShotFreqThresh():
	return ShotFreqThresh
func set_ShotFreqThresh(x):
	ShotFreqThresh = x

func get_PlayerPosition():
	return PlayerPosition
func set_PlayerPosition(x):
	PlayerPosition = x