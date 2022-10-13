#Canion.gd
class_name Canion
extends Node2D

## ATRIBUTOS EXPORT
export var proyectil:PackedScene = null
export var cadencia_disparo:float = 0.8
export var velocidad_proyectil:int = 100
export var danio_proytectil:int = 1

## ATRIBUTOS ONREADY
onready var timer_enfriamiento:Timer = $TimerEnfriamiento
onready var disparo_sfx:AudioStreamPlayer2D = $DisparoSFX
onready var esta_enfriado:bool = true
onready var esta_disparando:bool = false setget set_esta_disparando
onready var puede_disparar:bool = false setget set_puede_disparar

## ATRIBUTOS 
var puntos_disparo:Array = []

## SETTERS AND GETTERS
func set_esta_disparando(disparando: bool) ->void:
	esta_disparando = disparando

func set_puede_disparar(danio_puede:bool):
	puede_disparar = danio_puede


## METODOS
func _ready() -> void:
	#esto es para cambiar el loop desde codigo
	#disparo_sfx.stream.loop = false
	almacenar_puntos_disparo()
	timer_enfriamiento.wait_time = cadencia_disparo

func _process(delta: float) -> void:
	if esta_disparando and esta_enfriado:
		disparar()

## METODOS CUSTOM
func almacenar_puntos_disparo():
	for nodo in get_children():
		if nodo is Position2D:
			puntos_disparo.append(nodo)

func disparar() -> void:
	esta_enfriado = false
	disparo_sfx.play()
	timer_enfriamiento.start()
	for punto_disparo in puntos_disparo:
		var new_proyectil:Proyectil  = proyectil.instance()
		new_proyectil.crear(
			punto_disparo.global_position,
			get_owner().rotation,
			velocidad_proyectil,
			danio_proytectil
			)
		Eventos.emit_signal("disparo", new_proyectil)
	


func _on_TimerEnfriamiento_timeout() -> void:
	esta_enfriado = true
