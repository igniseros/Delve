extends Node2D

onready var energy = $"/root/PlayerGlobal".Energy

func _ready():
	$"/root/PlayerGlobal".connect("player_hit", self, "updateEnergy")
	updateEnergy()

func updateEnergy():
	energy = $"/root/PlayerGlobal".Energy
	$Sprite.region_rect.size.x = 16 * energy