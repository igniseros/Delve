extends RigidBody2D

var shotFrom

func _ready():
	$Area2D.connect("body_entered", self, "timeToGo")
	contacts_reported = true;

func timeToGo(object):
	print((object as Node2D).get_parent().name)
	if object.name == "PlayerBody":
	
		$"/root/PlayerGlobal".playerHit(shotFrom)
		get_parent().queue_free()
	
	if str(object.get_parent().name).split("_")[0] == "Monster":
		object.get_parent().takeHit(shotFrom)
	
	
	if object.name != "PlayerBody" and object.get_parent().name != "Bullet":
		get_parent().queue_free()