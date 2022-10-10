#Player.gd
class_name Player
extends RigidBody2D

## ATRIBUTOS EXPORT
export var potencia_motor: int = 20
export var potencia_rotacion: int = 280
#**************************************************#
#ASIGNACION DE VARIABLE
#TIPADO ESTATICO
#var mi_variable1 :int = 100 #EXPLICITA
#var mi_variable2 := 100 #IMPLICITA
#**************************************************#
## ATRIBUTOS
var empuje: Vector2 = Vector2.ZERO
var dir_rotacion: int = 0

## METODOS

func _ready() -> void:
	pass

func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	#apply_central_impulse que tiene como parámetro un Vector2 que es el impulso y nos permite aplicar dicho impulso direccional sin afectar la rotación
	apply_central_impulse(empuje.rotated(rotation))
	#Para manejar rotaciones de un rigidbody vamos a utilizar apply_torque_impulse
	#que lo que hace es tomar como parámetro un valor del tipo float que es el torque y le aplica un impulso rotacional al cuerpo.
	apply_torque_impulse(dir_rotacion * potencia_rotacion)

func _process(delta: float) -> void:
	player_input()

## METODO CUSTOM
func player_input() -> void:
	# EMPUJE
	empuje = Vector2.ZERO
	if Input.is_action_pressed("mover_adelante"):
		empuje = Vector2(potencia_motor, 0)
	elif Input.is_action_pressed("mover_atras"):
		empuje = Vector2(-potencia_motor, 0)
	
	# ROTACION
	dir_rotacion = 0
	if Input.is_action_pressed("mover_horario"):
		dir_rotacion += 1
	elif Input.is_action_pressed("mover_antihorario"):
		dir_rotacion -= 1






