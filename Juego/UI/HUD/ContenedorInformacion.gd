#ContenedorInformacion.gd
class_name ContenedorInformacion
extends NinePatchRect

## ATRIBUTOS EXPORT
export var auto_ocultar:bool = false setget set_auto_ocultar


## ATRIBUTOS ONREADY
onready var anim_contenedor:AnimationPlayer = $AnimationPlayer
onready var texto_contenedor:Label = $Label
onready var auto_ocultar_timer:Timer = $AutoOcultarTimer 

## ATRIBUTOS
var esta_activo:bool = true setget set_esta_activo

## SETTERS AND GETTERS
func set_auto_ocultar(value: bool) ->void:
	auto_ocultar = value

func set_esta_activo(value: bool) ->void:
	esta_activo = value


## METODOS CUSTOM
func mostrar() -> void:
	if esta_activo:
		anim_contenedor.play("mostrar")

func ocultar() -> void:
	if not esta_activo:
		anim_contenedor.stop()
	anim_contenedor.play("ocultar")

func mostrar_suavizado() -> void:
	if not esta_activo:
		return
	anim_contenedor.play("mostrar_suavizado")
	if auto_ocultar:
		auto_ocultar_timer.start()

func ocultar_suavizado() -> void:
	if esta_activo:
		anim_contenedor.play("ocultar_suavizado")

func modificar_texto(texto:String) ->void:
	texto_contenedor.text = texto


## SEÑALES INTERNAS
func _on_AutoOcultarTimer_timeout() -> void:
	ocultar_suavizado()
