extends KinematicBody

#stats
var saludAhora : int = 10
var saludMax : int = 10
var ammo : int = 15
var score : int = 0

#fisicas
var moveSpeed : float = 5.0
var jumpForce : float = 5.0
var gravity : float = 12.0

#camara
var minLookAngle : float = -90.0
var maxLookAngle : float = 90
var camaraSens : float  = .5


#vectores
var vel : Vector3 = Vector3()
var mouseDelta : Vector2 = Vector2()

#camara
onready var camera = get_node("CameraOrbit/Camera")
onready var pivote = get_node("CameraOrbit/Camera/Gun/Spatial")
onready var bulletScene = preload("res://Player/Bullet.tscn")

onready var UI : Node = get_node("../UI")

func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	UI.actualizaBarraVida(saludAhora, saludMax)
	UI.actualizaAmmo(ammo)
	UI.actualizaScore(score)
	
	
	
	
	
	
func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		mouseDelta = event.relative

func _process(delta: float) -> void:
	#Rotar la camara en el eje X
	camera.rotation_degrees -= Vector3(rad2deg(mouseDelta.y),0,0) * camaraSens * delta
	
	#Limitar la rotacion vertical
	camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, minLookAngle, maxLookAngle)
	
	#Rotar el jugador en el eje Y
	rotation_degrees -= Vector3(0,rad2deg(mouseDelta.x),0)* camaraSens * delta	
	
	#reiniciar el mouse delta
	mouseDelta = Vector2()
	
	if Input.is_action_just_pressed("shoot"):
		if ammo > 0:
			disparar()
	

func disparar():

	var bullet = bulletScene.instance()
	get_tree().get_root().add_child(bullet)
	bullet.global_transform = pivote.global_transform
	bullet.scale = Vector3.ONE
	ammo -= 1
	UI.actualizaAmmo(ammo)
	

func _physics_process(delta: float) -> void:
	#Reiniciar x y z de Velocidad cada cuadro
	vel.x = 0
	vel.z = 0
	
	var input = Vector2()
	
	#Input de movimiento
	if Input.is_action_pressed("ui_up"):
		input.y -= 1
	if Input.is_action_pressed("ui_down"):
		input.y += 1
	if Input.is_action_pressed("ui_left"):
		input.x -= 1
	if Input.is_action_pressed("ui_right"):
		input.x +=1
	
	input = input.normalized()
	
	var adelante = global_transform.basis.z
	var derecha = global_transform.basis.x
	
	#poner la velocidad
	vel.z = (adelante * input.y + derecha * input.x).z * moveSpeed
	vel.x = (adelante * input.y + derecha * input.x).x * moveSpeed
	
	vel.y -= gravity * delta
	
	vel = move_and_slide(vel, Vector3.UP)
	
	if Input.is_action_pressed("jump") and is_on_floor():
		vel.y = jumpForce
		
	
func add_score(puntosQueDa):
	score+=puntosQueDa
	UI.actualizaScore(score)

func take_damage(damage):
	saludAhora-=damage
	UI.actualizaBarraVida(saludAhora, saludMax)
	print("Recibi daño esta es mi salud"+str(saludAhora))
	if saludAhora <= 0:
		morirse()

func morirse():
	get_tree().reload_current_scene()
	pass

func add_health(vida):
	saludAhora = clamp(saludAhora + vida, 0, saludMax)
	print("Me cure, esta es mi salud"+str(saludAhora))
	UI.actualizaBarraVida(saludAhora, saludMax)
	
func add_ammo(municion):
	ammo += municion
	UI.actualizaAmmo(ammo)
