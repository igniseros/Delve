extends Node2D

const MATERIAL = preload("res://Art/Shaders/MonsterMat.tres")

onready var ani = $PhysicsBody/UpperBody
onready var shotScene = load("res://Scenes/Effects/LilBotBoom.tscn")
var attacking = false
var heIsInMe = false

var Damage = 1

func _ready():
	var mat = get_node("PhysicsBody/UpperBody").get_material().duplicate(true)
	get_node("PhysicsBody/UpperBody").set_material(mat)
	
	$PhysicsBody/AttackArea.connect("body_entered", self, "body_entered")
	$PhysicsBody/AttackArea.connect("body_exited", self, "body_exited")
	set_process(true)
	

func takeHit(shotFrom):
	
	if ($PhysicsBody/Timer.time_left == 0):
		$PhysicsBody/HitSound.play()
		$PhysicsBody/Timer.start()

func _process(delta):
	#tell the shader to turn him white based on how long ago he was hit
	($PhysicsBody/UpperBody.material as ShaderMaterial).set_shader_param("hitLeft", $PhysicsBody/Timer.time_left);
	
	if (heIsInMe):
		attemptStartAttack()
	
	if (attacking):
		attack()

	lookAtPlayer(delta)

func lookAtPlayer(delta):
	var body = $PhysicsBody
	var oldRot = body.rotation
	body.look_at($"/root/PlayerGlobal".PlayerPosition)
	body.rotation_degrees -= 90
	var newRot = body.rotation
	var maxRotSpeed = PI * delta
	if (attacking): maxRotSpeed = PI/10.0 * delta
	if (abs(newRot - oldRot) > maxRotSpeed):
		body.rotation = oldRot
		body.rotation += -maxRotSpeed * ((oldRot - newRot)/abs(oldRot-newRot))

func body_entered(body):
	if (body.get_parent().name == "Player"):
		heIsInMe = true

func body_exited(body):
	if (body.get_parent().name == "Player"):
		heIsInMe =false

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
		shotI.emitting = true
		shotI.position.y += 35
		shotI.rotation_degrees += 90
		$PhysicsBody/UpperBody/ShotHere.add_child(shotI)
		if (heIsInMe):
			$"/root/PlayerGlobal".playerHit()