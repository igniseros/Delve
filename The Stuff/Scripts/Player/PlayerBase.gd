extends Node2D

onready var ani = get_node("Img") #get animated sprite node
onready var player = get_node("/root/PlayerGlobal")
onready var weapon = get_node("Weapon")
onready var body = get_node("Body")

onready var WalkSpeed = player.get_WalkSpeed()
onready var ShotFreqThresh = player.get_ShotFreqThresh()

var w = false 
var a = false
var s = false
var d = false

var recentShootKey = "left"
var up = false
var left = false
var down = false
var right = false

func _ready():
	player.set_PlayerPosition(position)
	set_process(true)

func _process(delta):
	movement(delta)
	attack(delta)

func movement(delta):
	player.set_PlayerPosition(position)
	#-----------------------
	#movement and animations 
	#-----------------------
	
	#[reset boolean variables]
	w = false
	a = false
	s = false
	d = false
	
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
		
		position.y -= WalkSpeed * delta
		ani.set_animation("WU")
	if (a and not (w or s or d)):
		position.x -= WalkSpeed * delta
		ani.set_animation("WL")
	if (s and not (w or a or d)):
		position.y += WalkSpeed * delta
		ani.set_animation("WD")
	if (d and not (w or a or s)):
		position.x += WalkSpeed * delta
		ani.set_animation("WR")
	#diaganals
	if (w and d and not (a or s)):
		position.x += WalkSpeed * (1 / sqrt(2)) * delta
		position.y -= WalkSpeed * (1 / sqrt(2)) * delta
		ani.set_animation("WUR")
	if (w and a and not (d or s)):
		position.x -= WalkSpeed * (1 / sqrt(2)) * delta
		position.y -= WalkSpeed * (1 / sqrt(2)) * delta
		ani.set_animation("WUL")
	if (s and d and not (a or w)):
		position.x += WalkSpeed * (1 / sqrt(2)) * delta
		position.y += WalkSpeed * (1 / sqrt(2)) * delta
		ani.set_animation("WDR")
	if (s and a and not (d or w)):
		position.x -= WalkSpeed * (1 / sqrt(2)) * delta
		position.y += WalkSpeed * (1 / sqrt(2)) * delta
		ani.set_animation("WDL")
	#if not moving go to idle animation
	if (not w and not a and not s and not d):
		ani.set_animation("idle")

func _unhandled_key_input(event):
	#search for keys being pressed and send them to the shoot function
	if event.pressed and event.scancode == KEY_UP:
		recentShootKey = "up"
	if event.pressed and event.scancode == KEY_DOWN:
		recentShootKey ="down"
	if event.pressed and event.scancode == KEY_LEFT:
		recentShootKey ="left"
	if event.pressed and event.scancode == KEY_RIGHT:
		recentShootKey = "right"

func attack(delta):
	#------
	#Attack
	#------
	
	#[reset boolean variables]
	up = false
	left = false
	down = false
	right = false
	
	#[recheck boolean variables]
	if (recentShootKey == "up"):
		up = true
		weapon.rotation_degrees = -90
	if (recentShootKey == "left"):
		left = true
		weapon.rotation_degrees = 180
	if (recentShootKey == "down"):
		down = true
		weapon.rotation_degrees = 90
	if (recentShootKey == "right"):
		right = true
		weapon.rotation_degrees = 0