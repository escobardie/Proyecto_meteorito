#Motor.gd
class_name Motor
extends AudioStreamPlayer2D

## VARIABLES EXPORT
export var tiempo_transicion:float = 0.6
export var volumen_apagado:float = -30.0

## VARIABLES ONREADY
onready var tween_sonido:Tween = $Tween

## VARIABLES
var volumen_original:float

## FUNCIONES
func _ready() -> void:
	volumen_original = volume_db
	volume_db = volumen_apagado

func sonido_on()-> void:
	#Verificar si no esta sonado y ejecuta el efecto de transicion
	if not playing:
		play()
	
	efecto_tansicion(volume_db,volumen_original)

func sonido_off() -> void:
	#Ejecuta el efecto de transicion
	efecto_tansicion(volume_db,volumen_apagado)

func efecto_tansicion(desde_vol:float, hasta_vol:float) ->void:
	tween_sonido.interpolate_property(
		self,
		"volume_db",
		desde_vol,
		hasta_vol,
		tiempo_transicion,
		Tween.TRANS_LINEAR,
		Tween.EASE_OUT_IN
	)
	tween_sonido.start()


