#EnemigoBase.gd
class_name EnemigoBase
extends NaveBase


## ATRIBUTOS
var player_objetivo:Player = null
var dir_player:Vector2
<<<<<<< Updated upstream
var frame_actual:int = 0
=======
>>>>>>> Stashed changes


## METODOS
func _ready() -> void:
	#usando herencia para cambiar la cantidad de explosiones
	num_explosiones = 1
	player_objetivo = DatosJuego.get_player_actual()
	Eventos.connect("nave_destruida",self, "_on_nave_destruida")
	

func _physics_process(_delta: float) -> void:
<<<<<<< Updated upstream
	#¿Qué estamos haciendo ahí? Creando un contador que suma 1 
	#cuadro a cuadro y que cada 3 cuadros permite entrar al condicional y
	#hacer rotar_hacia_player (variable % 3 == 0, siendo % el módulo).
	frame_actual += 1
	if frame_actual % 3 == 0:
		rotar_hacia_player()
=======
	rotar_hacia_player()
>>>>>>> Stashed changes


func _on_Player_body_entered(body: Node) -> void:
	._on_Player_body_entered(body)
	if body is Player:
		body.destruir()
		destruir()

## METODOS CUSTOMER
func _on_nave_destruida(nave: NaveBase, _posicion, _explosiones) ->void:
	if nave is Player:
		player_objetivo = null


func rotar_hacia_player()  ->void:
	if player_objetivo:
		dir_player = player_objetivo.global_position - global_position
		rotation = dir_player.angle()



