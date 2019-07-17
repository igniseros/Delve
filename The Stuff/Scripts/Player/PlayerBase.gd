extends Node2D

onready var ani = get_node("PlayerBody/Img") #get animated sprite node
onready var player = get_node("/root/PlayerGlobal")
onready var weapon = get_node("PlayerBody/Img/Weapon")
onready var body = get_node("PlayerBody")
onready var ItemsGlobal = get_node("/root/Items")

onready var WalkSpeed = player.WalkSpeed

var boofScene = load("res://Scenes/Effects/Boof.tscn")

var nextAnim = "idle3"

var w = false 
var a = false
var s = false
var d = false

var recentShootKey = "right"
var up = false
var left = false
var down = false
var right = false

func _ready():
	player.player = self
	$BoofingTimer.stop()
	$BoofTimer.start()
	updateEquipment()
	player.PlayerPosition = body.global_position
	set_process(true)

func _process(delta):
	movement()
	attack()

func movement():
	var oldPos = player.PlayerPosition
	player.PlayerPosition = body.global_position
	#-----------------------
	#movement and animations 
	#-----------------------
	
	#[reset boolean variables]
	w = false
	a = false
	s = false
	d = false
	var finalMove := Vector2(0,0)
	#[recheck boolean variables]
	if (Input.is_key_pressed(KEY_D)):
		d = true
	if (Input.is_key_pressed(KEY_A)):
		a = true
	if (Input.is_key_pressed(KEY_S)):
		s = true
	if (Input.is_key_pressed(KEY_W)):
		w = true
	
	#[do stuff with the booleans]
	if (w and not (a or s or d)):
		finalMove = Vector2(0,-WalkSpeed)
		nextAnim = "WU"
	if (a and not (w or s or d)):
		finalMove = Vector2(-WalkSpeed,0)
		nextAnim = "WL"
	if (s and not (w or a or d)):
		finalMove = Vector2(0,WalkSpeed)
		nextAnim = "WD"
	if (d and not (w or a or s)):
		finalMove = Vector2(WalkSpeed,0)
		nextAnim = "WR"
	#diaganals
	if (w and d and not (a or s)):
		finalMove = Vector2(WalkSpeed * (1 / sqrt(2)),-WalkSpeed * (1 / sqrt(2)))
		nextAnim = "WUR"
	if (w and a and not (d or s)):
		finalMove = Vector2(-WalkSpeed * (1 / sqrt(2)),-WalkSpeed * (1 / sqrt(2)))
		nextAnim = "WUL"
	if (s and d and not (a or w)):
		finalMove = Vector2(WalkSpeed * (1 / sqrt(2)),WalkSpeed * (1 / sqrt(2)))
		nextAnim = "WDR"
	if (s and a and not (d or w)):
		finalMove = Vector2(-WalkSpeed * (1 / sqrt(2)),WalkSpeed * (1 / sqrt(2)))
		nextAnim = "WDL"
	#Check boofality
	var boofFactor = 1;
	if (Input.is_key_pressed(KEY_SHIFT) and ($BoofTimer.time_left == 0)) and (w or a or s or d):
		$PlayerBody/BoofSound.play()
		$BoofTimer.start()
		
		var boofInstance : Particles2D = boofScene.instance()
		boofInstance.emitting = true
		boofInstance.rotation = finalMove.angle()
		$PlayerBody/Img.add_child(boofInstance)
		
		$BoofingTimer.start(.1)
	if ($BoofingTimer.time_left != 0):
		boofFactor *= player.boofFactor
	body.move_and_slide(finalMove * boofFactor)
	#if not moving go to idle animation
	if ((not w and not a and not s and not d) or (oldPos == player.PlayerPosition)):
		nextAnim = "idle3"
	
	if (ani.frame == 0):
		ani.set_animation(nextAnim)

func _input(event):
	#search for keys being pressed and send them to the shoot function
	if (event is InputEventKey):
		if event.pressed and event.scancode == KEY_UP:
			recentShootKey = "up"
		if event.pressed and event.scancode == KEY_DOWN:
			recentShootKey ="down"
		if event.pressed and event.scancode == KEY_LEFT:
			recentShootKey ="left"
		if event.pressed and event.scancode == KEY_RIGHT:
			recentShootKey = "right"
	

func attack():
	#------
	#Attack
	#------
	
	#[reset boolean variables]
	up = false
	left = false
	down = false
	right = false
	
	var dir = Vector2(0,0);
	
	#[recheck boolean variables]
	if (recentShootKey == "up"):
		up = true
		weapon.rotation_degrees = -90
		dir.y = -1
	if (recentShootKey == "left"):
		left = true
		weapon.rotation_degrees = 180
		dir.x = -1
	if (recentShootKey == "down"):
		down = true
		weapon.rotation_degrees = 90
		dir.y = 1
	if (recentShootKey == "right"):
		right = true
		weapon.rotation_degrees = 0
		dir.x = 1
	if (Input.is_key_pressed(KEY_SPACE)):
		weapon.get_children().front().attemptAttack(dir)

func updateEquipment():
	if player.Equipment["Arm"] != -1:
		for child in weapon.get_children(): #remove any previus weapon
			weapon.remove_child(child)
		#add new one
		var newWepScn = load(ItemsGlobal.Arms[player.Equipment["Arm"]]) #load weapon scene
		var newWepNode = newWepScn.instance() #instance weapon
		weapon.add_child(newWepNode) #attach weapon to weapon node