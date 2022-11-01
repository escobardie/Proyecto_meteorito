#EstacionRecarga.gd
class_name EstacionRecarga
extends Node2D

## ATRIBUTOS EXPORT
export var energia:float = 6.0
export var radio_energia_entregada:float = 0.05

## ATRIBUTOS ONREADY
onready var carga_sfx:AudioStreamPlayer = $CargaSFX
onready var estacion_VFX:AnimationPlayer = $AnimationEstacionRecarga

## ATRIBUTOS
var nave_player:Player = null
var player_en_zona:bool = false

## METODOS
func _unhandled_input(event: InputEvent) -> void:
	if not puede_recargar(event):
		return
	
	control_energia()
	
	if event.is_action("recarga_escudo"):
		nave_player.get_escudo().control_energia(radio_energia_entregada)
	elif event.is_action("recarga_laser"):
		nave_player.get_laser().control_energia(radio_energia_entregada)
	
	if event.is_action_released("recarga_laser"):
		Eventos.emit_signal("ocultar_energia_laser")
	elif event.is_action_released("recarga_escudo"):
		Eventos.emit_signal("ocultar_energia_escudo")


## METODOS CUSTOMER
func puede_recargar(event: InputEvent) -> bool:
	var hay_input = event.is_action("recarga_escudo") or event.is_action("recarga_laser")
	if hay_input and player_en_zona and energia > 0.0:
		if !carga_sfx.playing:
			
			#estacion_VFX.play("recarga")
			carga_sfx.play()
		return true
	
	return false

func control_energia() -> void:
	energia -= radio_energia_entregada
	if energia <= 0.0:
		$VacioSFX.play()
		estacion_VFX.play("sin_energia")
	# solo para ver, QUITAR LUEGO
	print("Energia Estacion: ", energia)
	
	

## SEÑALES INTERNAS
func _on_AreaColision_body_entered(body: Node) -> void:
	if body.has_method("destruir"):
		body.destruir()

func _on_AreaRecarga_body_entered(body: Node) -> void:
	if body is Player:
		#al entrar la nave rep animacion mientras tenga energia hacer
		if energia > 0:
			estacion_VFX.play("recarga")
		player_en_zona = true
		nave_player = body
		Eventos.emit_signal("detecto_zona_recarga", true)

func _on_AreaRecarga_body_exited(body: Node) -> void:
	if body is Player:
		#al salir rep animacion normal, pero solo si tiene energia
		if energia > 0:
			estacion_VFX.play("idle")
		player_en_zona = false
		Eventos.emit_signal("detecto_zona_recarga", false)


