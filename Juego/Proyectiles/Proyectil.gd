#Proyectil.gd
class_name Proyectil
extends Area2D

## ATRIBUTOS
var velocidad : Vector2 = Vector2.ZERO
var danio : float

## METODOS

## ** CONSTRUCTOR
func crear (pos:Vector2, dir:float, vel:float, danio_p:int) -> void:
	position = pos
	rotation = dir
	#Con el vector velocidad del proyectil pasa algo parecido al movimiento de la nave… tenemos que rotarla en su dirección.
	velocidad = Vector2(vel, 0).rotated(dir)

func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	position += velocidad*delta


func _on_VisibilityNotifier2D_screen_exited() -> void:
	queue_free()
