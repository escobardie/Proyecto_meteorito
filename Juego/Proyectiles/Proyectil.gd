#Proyectil.gd
class_name Proyectil
extends Area2D

## ATRIBUTOS
var velocidad : Vector2 = Vector2.ZERO
var danio : float #= 1.0

## METODOS

## ** CONSTRUCTOR
func crear (pos:Vector2, dir:float, vel:float, danio_p:int) -> void:
	position = pos
	rotation = dir
	#Con el vector velocidad del proyectil pasa algo parecido al movimiento de la nave… tenemos que rotarla en su dirección.
	velocidad = Vector2(vel, 0).rotated(dir)

# METODOS
func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	position += velocidad*delta

# METODOS CUSTOM
func daniar(otro_cuerpo: CollisionObject2D) -> void:
	#has_method”? Un método que devuelve true o false
	if otro_cuerpo.has_method("recibir_danio"):
		otro_cuerpo.recibir_danio(danio)
	queue_free()


## SEÑALES INTERNAS
func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()

func _on_body_entered(body: Node) -> void:
	daniar(body)

func _on_area_entered(area: Area2D) -> void:
	daniar(area)
