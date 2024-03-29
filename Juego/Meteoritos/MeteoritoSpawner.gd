#MeteoritoSpawner.gd
class_name MeteoritoSpawner
extends Position2D

## ATRIBUTOS EXPORT
export var direccion:Vector2 = Vector2(1,1)
export var rango_tamanio_meteorito:Vector2 = Vector2(0.5, 2.2)


func _ready() -> void:
	pass



func spawnear_meteorito() -> void:
	Eventos.emit_signal(
		"spawn_meteorito",
		global_position,
		direccion,
		tamanio_meteorito_random()
		)

func tamanio_meteorito_random() -> float:
	randomize()
	return rand_range(rango_tamanio_meteorito[0], rango_tamanio_meteorito[1])



