extends Particles2D

var oldPos := Vector2(0,0)

func _ready():
	set_process(true)

func _process(delta):
	(process_material as ParticlesMaterial).initial_velocity = $"/root/PlayerGlobal".boofFactor * 5
	if not emitting and $Timer.is_stopped():
		$Timer.start()
	if not $Timer.is_stopped() and $Timer.time_left == 0:
		queue_free()
	
	
	oldPos = global_position