extends KinematicBody

var salud = 5
var velMov = 1

var damage = 1
var attackRate = 1
var attackDist = 2

var puntosQueDa = 10

#componentes

onready var player : Node = get_node("/root/World/Player")
onready var timer : Timer = get_node("Timer")

func _ready() -> void:
	timer.set_wait_time(attackRate)
	timer.start()

func _physics_process(delta: float) -> void:
	var dir = (player.translation - translation).normalized()
	dir.y = 0
	
	move_and_slide(dir * velMov, Vector3.UP)

func take_damage(damage):
	salud-=damage
	
	if salud <= 0:
		morirse()

func morirse():
	player.add_score(puntosQueDa)
	queue_free()

func atacar():
	player.take_damage(damage)


func _on_Timer_timeout() -> void:
	if translation.distance_to(player.translation) <= attackDist:
		atacar()
	
	
	pass # Replace with function body.
