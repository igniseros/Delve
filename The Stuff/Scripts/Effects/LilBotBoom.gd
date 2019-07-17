extends Particles2D

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

# Called when the node enters the scene tree for the first time.
func _ready():
	set_process(true)

func _process(delta):
	if (not emitting) and ($Timer.is_stopped()):
		$Timer.start()
	if (not $Timer.is_stopped()) and ($Timer.wait_time == 0):
		queue_free()