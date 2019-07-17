extends Node

var player : Node2D
var Energy = 6
var WalkSpeed = 100
var PlayerPosition = Vector2(0,0)
var boofFactor = 10;
var Equipment = {"Arm":1,"Legs":-1,"Head":-1,"Body":-1,"Misc":-1}

signal player_hit

#-----------------
#Energy
#-----------------
func playerHit():
	Energy = Energy - 1
	print(Energy)
	emit_signal("player_hit")
	playHitSound()

func playHitSound():
	var randomNumber = ceil(rand_range(0,5))
	var hf : AudioStreamPlayer2D = player.find_node("HitEffect")
	hf.stream = load("res://Sound/Effects/Squidge " + str(randomNumber) + ".wav")
	hf.play()