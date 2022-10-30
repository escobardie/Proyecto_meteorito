#EnemigoOrbital.gd
class_name EnemigoOrbital
extends EnemigoBase

## ATRIBUTOS EXPORT
export var rango_max_ataque:float = 1400.0

## ATRIBUTOS
#var estacion_deunia:Node2D
var base_deunia:Node2D


## METODOS
func _ready() -> void:
	Eventos.connect("base_destruida",self, "_on_base_destruida")
	
	canion.set_esta_disparando(true)


## METODOS CUSTOMER
func rotar_hacia_player() -> void:
	.rotar_hacia_player()
	if dir_player.length() > rango_max_ataque:
		canion.set_esta_disparando(false)
	else:
		canion.set_esta_disparando(true)

## CONSTRUCTOR
func crear (pos: Vector2, duenio: Node2D) -> void:
	global_position = pos
	base_deunia = duenio

## SEÑALES EXTERNAS
func _on_base_destruida(base:Node2D, _pas) -> void:
	if base == base_deunia:
		destruir()


