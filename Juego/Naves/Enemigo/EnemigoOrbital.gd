#EnemigoOrbital.gd
class_name EnemigoOrbital
extends EnemigoBase



## ATRIBUTOS EXPORT
export var rango_max_ataque:float = 1400.0
export var velocidad:float = 400.0

## ATRIBUTOS
var base_deunia:Node2D
var ruta:Path2D
var path_folow:PathFollow2D

## ATRIBUTOS ONREDY
onready var detector_obstaculo:RayCast2D = $DetectorObstaculo


## METODOS
func _ready() -> void:
	Eventos.connect("base_destruida",self, "_on_base_destruida")
	canion.set_esta_disparando(true)

func _process(delta: float) -> void:
	path_folow.offset += velocidad * delta
	position = path_folow.global_position

## METODOS CUSTOMER
func rotar_hacia_player() -> void:
	.rotar_hacia_player()
	if dir_player.length() > rango_max_ataque or detector_obstaculo.is_colliding():
		canion.set_esta_disparando(false)
	else:
		canion.set_esta_disparando(true)

## CONSTRUCTOR
func crear (pos: Vector2, duenio: Node2D, ruta_duenio:Path2D) -> void:
	global_position = pos
	base_deunia = duenio
	ruta = ruta_duenio
	path_folow = PathFollow2D.new()
	ruta.add_child(path_folow)

## SEÑALES EXTERNAS
func _on_base_destruida(base:Node2D, _pas) -> void:
	if base == base_deunia:
		destruir()


