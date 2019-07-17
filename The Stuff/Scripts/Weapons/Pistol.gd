extends Node2D


onready var bullet = load("res://Scenes/Weapons/Bullet.tscn")
var bang = false

func _ready():
	$Timer.wait_time = 1.0 / $"/root/Items".ArmData[0]["ATKSPD"] #set attack speed based on item data
	$Timer.start() # start timer
	self.position.x = 35 #look good
	set_process(true)

func attack(Direction : Vector2, startP : Vector2 = $Exit.global_position):
	bang = true
	$Exit/Effect.frame = 0 #reset animation
	var iB : Node2D= bullet.instance() #create bullet
	var speed = $"/root/Items".ArmData[0]["BLTSPD"] #get bullet speed
	iB.position = startP #setPosition
	iB.set_as_toplevel(true) #Ignor Parent Tranform
	
	#vvv set rotation and such depending on direction vvv
	if (Direction == Vector2(-1,0)): iB.find_node("Sprite").flip_h = true
	if (Direction == Vector2(0,1)): iB.find_node("Sprite").rotation_degrees = 90
	if (Direction == Vector2(0,-1)): iB.find_node("Sprite").rotation_degrees = -90
	
	print("iB == " + str(iB))
	(iB.get_node("Body") as RigidBody2D).linear_velocity = Direction * speed #Give Force
	$Exit.add_child(iB) #Add Child
	
	

func attemptAttack(Direction : Vector2, startP : Vector2 = $Exit.global_position):
	if ($Timer.time_left == 0): #check timer if good, attack
		attack(Direction, startP)
		$Timer.start()

func _process(delta):
	if (bang == true) and ($Exit/BangLight.visible == false):
		$Exit/BangLight.visible = true
		$BTime.start()
		bang = false
	
	if ($BTime.time_left == 0):
		$Exit/BangLight.visible = false
		
	