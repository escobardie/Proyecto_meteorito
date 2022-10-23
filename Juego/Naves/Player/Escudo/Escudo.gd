#Escudo.gd
class_name Escudo
extends Area2D

# VARIABLES
var esta_activado:bool = false setget ,get_esta_activado
var energia_original:float


## VARIABLES EXPORT
#Si por ejemplo queremos que el escudo dure 5 segundos y le damos una energía de 8,0:
#8,0 / 5s = 1,6 → cuánta energía por segundo hay que consumir.
#8.0 / 10s = 0.8
export var energia:float = 8.0
export var radio_desgaste:float = -0.8

## METODOS
func _process(delta: float) -> void:
	control_energia(radio_desgaste * delta)


func _ready() -> void:
	energia_original = energia
	#Ahora al iniciar no se consume energía (el _process no corre)
	set_process(false)
	controlar_colision(true)

## SETTERS AND GETTERS
func get_esta_activado() ->bool:
	return esta_activado

## METODOS CUSTOMER
func control_energia(consumo:float)-> void:
	energia += consumo
	# solo de prueba QUIETA LUEGO
	print("Energia Escudo: ", energia)
	
	if energia > energia_original:
		energia = energia_original	
	elif energia <= 0.0:
		desactivar()

func activar()-> void:
	if energia <= 0.0:
		return
	#print("escudo activado")
	esta_activado = true
	controlar_colision(false)
	$AnimationPlayer.play("activando")

func desactivar() -> void:
	set_process(false)
	esta_activado = false
	controlar_colision(true)
	$AnimationPlayer.play_backwards("activando")


func controlar_colision(esta_activ:bool) -> void:
	#recibimos el bool que determina el estado del colisionador
	$CollisionShape2D.set_deferred("disabled", esta_activ)


## SEÑALES INTERNAS
func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "activando" and esta_activado:
		$AnimationPlayer.play("activado")
		#activamos el process para activar el escudo
		set_process(true)

func _on_body_entered(body: Node) -> void:
	body.queue_free()
