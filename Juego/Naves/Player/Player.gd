class_name Player
extends NaveBase

## ATRIBUTOS EXPORT
export var potencia_motor: int = 18
export var potencia_rotacion: int = 260
export var estela_maxima:int = 150

## ATRIBUTOS
var empuje: Vector2 = Vector2.ZERO
var dir_rotacion: int = 0

## ATRIBUTOS ONREADY
onready var laser:RayoLaser = $LaserBeam2D setget ,get_laser
onready var estela:Estela = $EstelaPuntoInicio/Trail2D
onready var motor_SFX:Motor = $MotorSFX
onready var escudo:Escudo = $Escudo setget ,get_escudo

## SETTER AND GETTER
func get_laser() -> RayoLaser:
	return laser

func get_escudo() -> Escudo:
	return escudo

## METODOS
func _ready() -> void:
	DatosJuego.set_player_actual(self)


func _unhandled_input(event: InputEvent) -> void:
	if not esta_input_activo():
		return
	
	# DISPARO RAYO
	# esto es cuando presiono
	if event.is_action_pressed("disparo_secundario"):
		laser.set_is_casting(true)
		
	# esto es cuando suelto
	if event.is_action_released("disparo_secundario"):
		laser.set_is_casting(false)
	
	# CONTROL ESTELA Y SONIDO MOTOR
	if event.is_action_pressed("mover_adelante"):
		estela.set_max_points(estela_maxima)
		motor_SFX.sonido_on()

	elif event.is_action_pressed("mover_atras"):
		estela.set_max_points(0)
		motor_SFX.sonido_on()

	if (event.is_action_released("mover_adelante") or event.is_action_released("mover_atras")):
		motor_SFX.sonido_off()
	
	# ESCUDO
	if event.is_action_pressed("escudo") and not escudo.get_esta_activado():
		escudo.activar()

func _integrate_forces(_state: Physics2DDirectBodyState) -> void:
	#apply_central_impulse que tiene como parámetro un Vector2 que es el impulso y nos permite aplicar dicho impulso direccional sin afectar la rotación
	apply_central_impulse(empuje.rotated(rotation))
	#Para manejar rotaciones de un rigidbody vamos a utilizar apply_torque_impulse
	#que lo que hace es tomar como parámetro un valor del tipo float que es el torque y le aplica un impulso rotacional al cuerpo.
	apply_torque_impulse(dir_rotacion * potencia_rotacion)

func _process(_delta: float) -> void:
	player_input()


## METODO CUSTOM
func player_input() -> void:
	if not esta_input_activo():
		return
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
	
	# DISPARO
	if Input.is_action_pressed("disparo_ppal"):
		canion.set_esta_disparando(true)
	if Input.is_action_just_released("disparo_ppal"):
		canion.set_esta_disparando(false)

func esta_input_activo() ->bool:
	if estado_actual in [ESTADOS.MUERTO, ESTADOS.SPAWN]:
		return false
	return true

## SEÑALES INTERNAS

