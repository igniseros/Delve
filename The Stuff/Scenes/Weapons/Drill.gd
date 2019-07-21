extends Node2D

const ID = 1
onready var ani = $AnimatedSprite
var monsterCols = Array()
var hit = false
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
		hit = false

func _process(delta):
	if (ani.frame == 2):
		attack()

func attack():
	if (not hit):
		for col in monsterCols:
			(col.get_parent() as Monster).take_hit(ID)
			hit = true

func body_enterd(body):
	if (body.get_parent() is Monster):
		monsterCols.append(body)
		
func body_exited(body):
	if (body.get_parent() is Monster):
		var i = 0
		for mon in monsterCols:
			if (mon.get_parent().name == body.get_parent().name):
				monsterCols.remove(i)
			i+=1
		