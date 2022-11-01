#Meteorito.gd
class_name Meteorito
extends RigidBody2D

## ATRIBUTOS EXPORT
export var vel_lineal_base:Vector2 = Vector2(10.0, 10.0)
export var vel_angular_base:float = 3.0
export var hitpoints_base:float = 10.0

## ATRIBUTOS
var hitpoints:float = 10.0
var esta_en_sector:bool = true setget set_esta_en_sector
var pos_spawn_original:Vector2
var vel_spawn_original:Vector2
var esta_destruido:bool = false


## ATRIBUTOS ONREADY
onready var impacto_SFX:AudioStreamPlayer = $ImpactoMeteorito
onready var explosion_impacto_VFX:AnimationPlayer = $AnimationPlayer

## METODOS
func _ready() -> void:
	#con angular determinamos la velocidad de rotación 
	#angular_velocity = vel_angular_base
	pass

func _integrate_forces(state: Physics2DDirectBodyState) -> void:
	if esta_en_sector:
		return
	var mi_transform := state.get_transform()
	mi_transform.origin = pos_spawn_original
	#####
	linear_velocity = vel_spawn_original
	#####
	state.set_transform(mi_transform)
	esta_en_sector = true
	

## SETTER AND GETTER
func set_esta_en_sector(valor:bool) ->void:
	esta_en_sector = valor


# METODOS CUSTOMER
func recibir_danio(danio:float) -> void:
	hitpoints -= danio
	if hitpoints <= 0.0 and not esta_destruido:
		esta_destruido = true
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
	pos_spawn_original = position
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
	##### original
	#linear_velocity = (vel_angular_base * dir / tamanio) * random_velocidad()
	######
	linear_velocity = vel_lineal_base * dir / tamanio * random_velocidad()
	######
	vel_spawn_original = linear_velocity
	#con angular determinamos la velocidad de rotación 
	angular_velocity = (vel_angular_base / tamanio) * random_velocidad()
	#CALCULAR HITPOINTS
	hitpoints = hitpoints_base * tamanio
	#SOLO DEBUG
	print("hitpoints ", hitpoints)




