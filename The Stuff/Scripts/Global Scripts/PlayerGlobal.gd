extends Node

var player : Node2D
var Energy = 2
var WalkSpeed = 100
var PlayerPosition = Vector2(0,0)
var boofFactor = 10;
var Equipment = {"Arm":1,"Legs":-1,"Head":-1,"Body":-1,"Misc":-1}
var alive = true

signal player_hit
signal player_die

#-----------------
#Energy
#-----------------
func playerHit():
	if (alive):
		Energy = Energy - 1
		emit_signal("player_hit")
		playHitSound()
		if (Energy <= 0): playerDie()

func playHitSound():
	var randomNumber = ceil(rand_range(0,5))
	var hf : AudioStreamPlayer2D = player.find_node("HitEffect")
	hf.stream = load("res://Sound/Effects/Squidge " + str(randomNumber) + ".wav")
	hf.play()

func playerDie():
	alive = false
	emit_signal("player_die")