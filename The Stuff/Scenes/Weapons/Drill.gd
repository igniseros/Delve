extends Node2D

onready var ani = $AnimatedSprite
var monsterCols = Array()

func _ready():
	scale /= 2
	position.x += 45
	$Area2D.connect("body_entered", self, "body_enterd")
	$Area2D.connect("body_exited", self, "body_exited")
	set_process(true)

func attemptAttack(dir):
	if (ani.frame == 14):
		$AttackSound.play()
		ani.frame=0

func _process(delta):
	if (ani.frame == 2):
		attack()

func attack():
	for col in monsterCols:
		col.get_parent().takeHit(1)

func body_enterd(body):
	if (str(body.get_parent().name).split('_')[0] == "Monster"):
		monsterCols.append(body)
		

func body_exited(body):
	if (str(body.get_parent().name).split('_')[0] == "Monster"):
		var i = 0
		for mon in monsterCols:
			if (mon.get_parent().name == body.get_parent().name):
				monsterCols.remove(i)
			i+=1
		