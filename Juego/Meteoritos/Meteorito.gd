#Meteorito.gd
class_name Meteorito
extends RigidBody2D

## ATRIBUTOS EXPORT
export var vel_lineal_base:Vector2 = Vector2(300.0, 300.0)
export var vel_angular_base:float = 3.0
export var hitpoints_base:float = 10.0

## ATRIBUTOS
var hitpoints:float = 10.0

## ATRIBUTOS ONREADY
onready var impacto_SFX:AudioStreamPlayer = $ImpactoMeteorito
onready var explosion_impacto_VFX:AnimationPlayer = $AnimationPlayer

## METODOS
func _ready() -> void:
	#con angular determinamos la velocidad de rotación 
	#angular_velocity = vel_angular_base
	pass

# METODOS CUSTOMER
func recibir_danio(danio:float) -> void:
	hitpoints -= danio
	if hitpoints <= 0.0:
		destruir()
	impacto_SFX.play()
	explosion_impacto_VFX.play("impacto")

func destruir() -> void:
	$CollisionShape2D.set_deferred("disabled", true)
	Eventos.emit_signal("meteorito_destruido", global_position)
	queue_free()

func random_velocidad() ->float:
	randomize()
	return rand_range(1.1, 1.4)


## CONSTRUCTOR
func crear(pos:Vector2, dir:Vector2, tamanio:float) ->void:
	position = pos
	
	#linear_velocity = vel_lineal_base * dir
	#calcular MASA, tamaño de STRITE y del COLISIONADOR
	mass *= tamanio
	$Sprite.scale = Vector2.ONE * tamanio
	#RADIO = DIAMETRO * 2
	var radio:int = int($Sprite.texture.get_size().x / 2.3 * tamanio)
	var forma_colision:CircleShape2D = CircleShape2D.new()
	forma_colision.radius = radio
	$CollisionShape2D.shape = forma_colision
	#CALCULAR VELOCIDAD
	#con lineal determinamos el angulo de direccion
	linear_velocity = (vel_angular_base * dir / tamanio) * random_velocidad()
	#con angular determinamos la velocidad de rotación 
	angular_velocity = (vel_angular_base / tamanio) * random_velocidad()
	#CALCULAR HITPOINTS
	hitpoints = hitpoints_base * tamanio
	#SOLO DEBUG
	print("hitpoints ", hitpoints)




