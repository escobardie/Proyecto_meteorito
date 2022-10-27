##BaseEnemiga.gd
class_name BaseEnemiga
extends Node2D

## ATRIBUTOS EXPORT
export var hitpoints:float = 30.0

## ATRIBUTOS ONREADY
onready var impacto_sfx:AudioStreamPlayer = $ImpactoSFX

## ATRIBUTOS
var esta_destruida:bool = false


## METODOS
func _ready() -> void:
	$AnimationPlayer.play(elegir_animacion_random())



## METODOS CUSTOM
func elegir_animacion_random() -> String:
	randomize()
	var num_anim:int = $AnimationPlayer.get_animation_list().size() - 1
	var indice_anim_random:int = randi() % num_anim + 1
	var lista_animacion:Array = $AnimationPlayer.get_animation_list()
	
	return lista_animacion[indice_anim_random]

func recibir_danio(danio:float) ->void:
	hitpoints -= danio
	
	if hitpoints <= 0 and not esta_destruida:
		esta_destruida = true
		destruir()
		#queue_free()
	
	impacto_sfx.play()

func destruir() -> void:
	var posicion_partes = [
		$AreaColision/Sprites/Sprite.global_position,
		$AreaColision/Sprites/Sprite2.global_position,
		$AreaColision/Sprites/Sprite3.global_position,
		$AreaColision/Sprites/Sprite4.global_position
	]
	Eventos.emit_signal("base_destruida", posicion_partes)
	queue_free()


## SEÑALES INTERNAS
func _on_AreaColision_body_entered(body: Node) -> void:
	if body.has_method("destruir"):
		body.destruir()
