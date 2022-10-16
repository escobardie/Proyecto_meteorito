#EnemigoDummy.gd

extends Node2D

## ATRIBUTOS
var hitpoints:float = 10.0


# METODOS
func _ready() -> void:
	pass # Replace with function body.

func _process(delta: float) -> void:
	$Canion.set_esta_disparando(true)


# METODOS CUSTOMER
func recibir_danio(danio:float) -> void:
	hitpoints -= danio
	if hitpoints <= 0.0:
		queue_free()




## SEÑALES INTERNAS
func _on_Area2D_body_entered(body: Node) -> void:
	print("entra por aca")
	#preguntamos si el que toca el area es el PLAYER
	if body is Player:
		#entonces ejecutamos su metodo
		body.destruir()


