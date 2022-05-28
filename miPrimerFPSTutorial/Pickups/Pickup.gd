extends Spatial

enum TipoDeObjeto {
	Ammo,
	Health	
}

#stats
export (TipoDeObjeto) var objeto = TipoDeObjeto.Health
export var amount : int = 10

func _ready() -> void:
	
	pass

func _on_Pickup_body_entered(body: Node) -> void:
	if body.name == "Player":
		pickup(body)
		queue_free()
	pass # Replace with function body.

func pickup(body):
	if objeto == TipoDeObjeto.Health:
		body.add_health(amount)
	elif objeto == TipoDeObjeto.Ammo:
		body.add_ammo(amount)
