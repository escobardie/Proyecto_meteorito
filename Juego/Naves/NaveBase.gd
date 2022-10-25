#NaveBase.gd
class_name NaveBase
extends RigidBody2D

## ESTADOS ENUM
enum ESTADOS {SPAWN, VIVO, INVENSIBLE, MUERTO}

## ATRIBUTOS EXPORT
export var hitpoints:float = 20.0

#**************************************************#
#ASIGNACION DE VARIABLE
#TIPADO ESTATICO
#var mi_variable1 :int = 100 #EXPLICITA
#var mi_variable2 := 100 #IMPLICITA
#**************************************************#
## ATRIBUTOS
var estado_actual:int = ESTADOS.SPAWN


## ATRIBUTOS ONREADY
onready var colisionador:CollisionShape2D = $CollisionShape2D
onready var impacto_SFX:AudioStreamPlayer = $ImpactSFX
onready var canion:Canion = $Canion


## METODOS
func _ready() -> void:
	controlador_estado(estado_actual)



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
			canion.set_puede_disparar(false)
			Eventos.emit_signal("nave_destruida",self, global_position, 3)
			queue_free()
		_:
			printerr("ERROR ES HUMADO, PERDONAR ES DIVINO")
	estado_actual = nuevo_estado

func recibir_danio(danio:float) -> void:
	hitpoints -= danio
	if hitpoints <= 0.0:
		destruir()
	impacto_SFX.play()

func destruir() -> void:
	controlador_estado(ESTADOS.MUERTO)


## SEÑALES INTERNAS
func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "spawn":
		controlador_estado(ESTADOS.VIVO)

func _on_Player_body_entered(body: Node) -> void:
	if body is Meteorito:
		body.destruir()
		destruir()

