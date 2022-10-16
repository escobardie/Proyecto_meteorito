#Player.gd
class_name Player
extends RigidBody2D

## ESTADOS ENUM
enum ESTADOS {SPAWN, VIVO, INVENSIBLE, MUERTO}

## ATRIBUTOS EXPORT
export var potencia_motor: int = 20
export var potencia_rotacion: int = 280
export var estela_maxima:int = 150
#**************************************************#
#ASIGNACION DE VARIABLE
#TIPADO ESTATICO
#var mi_variable1 :int = 100 #EXPLICITA
#var mi_variable2 := 100 #IMPLICITA
#**************************************************#
## ATRIBUTOS
var empuje: Vector2 = Vector2.ZERO
var dir_rotacion: int = 0
var estado_actual:int = ESTADOS.SPAWN
var hitpoints:float = 15.0


## ATRIBUTOS ONREADY
onready var canion:Canion = $Canion
onready var laser:RayoLaser = $LaserBeam2D
onready var estela:Estela = $EstelaPuntoInicio/Trail2D
onready var motor_SFX:Motor = $MotorSFX
onready var colisionador:CollisionShape2D = $CollisionShape2D
onready var impacto_SFX:AudioStreamPlayer = $ImpactSFX
onready var escudo:Escudo = $Escudo

## METODOS
func _ready() -> void:
	controlador_estado(estado_actual)
	#controlador_estado(ESTADOS.SPAWN)
	# Asignamos la ubicacion donde sera la explosion
	#Eventos.emit_signal("nave_destruida", global_position)
	#queue_free()

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

func controlador_estado(nuevo_estado : int) -> void:
	match nuevo_estado:
		ESTADOS.SPAWN:
			colisionador.set_deferred("disabled", true)
			canion.set_puede_disparar(false)
		ESTADOS.VIVO:
			colisionador.set_deferred("disabled", false)
			canion.set_puede_disparar(true)
		ESTADOS.INVENSIBLE:
			#desactiva el colisionador
			colisionador.set_deferred("disabled", true)
		ESTADOS.MUERTO:
			colisionador.set_deferred("disabled", true)
			canion.set_puede_disparar(true)
			Eventos.emit_signal("nave_destruida", global_position, 3)
			queue_free()
		_:
			printerr("ERROR ES HUMADO, PERDONAR ES DIVINO")
	estado_actual = nuevo_estado

func esta_input_activo() ->bool:
	if estado_actual in [ESTADOS.MUERTO, ESTADOS.SPAWN]:
		return false
	return true


func destruir() -> void:
	controlador_estado(ESTADOS.MUERTO)

func recibir_danio(danio:float) -> void:
	hitpoints -= danio
	if hitpoints <= 0.0:
		destruir()
	impacto_SFX.play()


## SEÑALES INTERNAS
func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "spawn":
		controlador_estado(ESTADOS.VIVO)
