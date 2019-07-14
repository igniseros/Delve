extends Node2D

onready var ani = get_node("Img") #get animated sprite node
onready var player = get_node("/root/PlayerGlobal")
onready var speed = player.get_speed()

var w = false 
var a = false
var s = false
var d = false

func _ready():
	set_process(true)

func _process(delta):
	#-----------------------
	#movement and animations 
	#-----------------------
	
	#reset boolean variables
	w = false
	a = false
	s = false
	d = false
	
	#recheck boolean variables
	if (Input.is_key_pressed(KEY_D)):
		d = true
	if (Input.is_key_pressed(KEY_A)):
		a = true
	if (Input.is_key_pressed(KEY_S)):
		s = true
	if (Input.is_key_pressed(KEY_W)):
		w = true
	
	#do stuff with the booleans
	if (w and not (a or s or d)):
		position.y -= speed * delta
		ani.set_animation("WU")
	if (a and not (w or s or d)):
		position.x -= speed * delta
		ani.set_animation("WL")
	if (s and not (w or a or d)):
		position.y += speed * delta
		ani.set_animation("WD")
	if (d and not (w or a or s)):
		position.x += speed * delta
		ani.set_animation("WR")
		
	if (w and d and not (a or s)):
		position.x += speed * (1 / sqrt(2)) * delta
		position.y -= speed * (1 / sqrt(2)) * delta
		ani.set_animation("WUR")
	if (w and a and not (d or s)):
		position.x -= speed * (1 / sqrt(2)) * delta
		position.y -= speed * (1 / sqrt(2)) * delta
		ani.set_animation("WUL")
	if (s and d and not (a or w)):
		position.x += speed * (1 / sqrt(2)) * delta
		position.y += speed * (1 / sqrt(2)) * delta
		ani.set_animation("WDR")
	if (s and a and not (d or w)):
		position.x -= speed * (1 / sqrt(2)) * delta
		position.y += speed * (1 / sqrt(2)) * delta
		ani.set_animation("WDL")
	
	if (not w and not a and not s and not d):
		ani.set_animation("idle")