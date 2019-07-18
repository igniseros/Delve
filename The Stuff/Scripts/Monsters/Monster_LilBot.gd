extends Node2D

export var health = 3
export var alive = true

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
	$PhysicsBody/Timer.start()
	$PhysicsBody/HitSound.play()
	if (alive):
		health -= $"/root/Items".ArmData[shotFrom]["DMG"]
		if (health <= 0):
			die()

func _process(delta):
	#tell the shader to turn him white based on how long ago he was hit
	($PhysicsBody/UpperBody.material as ShaderMaterial).set_shader_param("hitLeft", $PhysicsBody/Timer.time_left)
	
	if (alive):
		if (heIsInMe):
			attemptStartAttack()
		if (attacking):
			attack()
		lookAtPlayer(delta)
	
	if (not alive):
		if ($PhysicsBody/UpperBody/Explosion.frame == 6):
			$PhysicsBody/UpperBody.modulate = Color(.5,.5,.5,1)

func lookAtPlayer(delta):
	var body = $PhysicsBody
	var oldRot = body.rotation
	body.look_at($"/root/PlayerGlobal".PlayerPosition) #look at him
	body.rotation_degrees -= 90 #but correctly
	var newRot = body.rotation
	var maxRotSpeed = PI * delta #speedlimit
	if (attacking): maxRotSpeed = PI/10.0 * delta #even slower if aiming
	if (abs(newRot - oldRot) > maxRotSpeed):  #dont go to fast
		body.rotation = oldRot
		body.rotation += -maxRotSpeed * ((oldRot - newRot)/abs(oldRot-newRot)) #you went too fast, ajust

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

func die():
	alive = false
	$PhysicsBody/UpperBody/Explosion.frame = 0
	$PhysicsBody/UpperBody/LeftEye.energy = 0
	$PhysicsBody/UpperBody/RightEye.energy = 0
	