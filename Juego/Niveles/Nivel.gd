#Nivel.gb
class_name Nivel
extends Node2D

## ATRIBUTOS EXPORT
export var explosion:PackedScene = null
export var meteorito:PackedScene
export var explosion_meteorito:PackedScene
export var sector_meteoritos:PackedScene #= null
export var tiempo_transicion_camara:float = 2.0

## ATRIBUTOS ONREADY
onready var contenedor_proyectiles:Node
onready var contenedor_meteoritos:Node = null
onready var contenedor_sector_meteoritos:Node = null
onready var camara_nivel:Camera2D = $CamaraNivel
onready var camara_player:Camera2D = $Player/CamaraPlayer

## ATRIBUTOS 
var meteoritos_totales:int = 0

## VARIABLE



## METODOS
func _ready() -> void:
	conectar_seniales()
	crear_contenedor()

## METODOS CUSTOMER
func conectar_seniales() -> void:
	Eventos.connect("disparo", self, "_on_disparo")
	Eventos.connect("nave_destruida", self, "_on_nave_destruida")
	Eventos.connect("spawn_meteorito", self, "_on_spawn_meteoritos")
	Eventos.connect("meteorito_destruido", self, "_on_meteorito_destruido")
	Eventos.connect("nave_en_sector_peligro", self, "_on_nave_en_sector_peligroso")


func crear_contenedor() -> void:
	#CONTENEDOR PROYECTILES
	contenedor_proyectiles = Node.new()
	contenedor_proyectiles.name = "ContenedorProyectiles"
	add_child(contenedor_proyectiles)
	
	#CONTENEDOR METEORITOS
	contenedor_meteoritos = Node.new()
	contenedor_meteoritos.name = "ContenedorMeteoritos"
	add_child(contenedor_meteoritos)
	
	#CONTENEDOR SECTOR METEORITOS
	contenedor_sector_meteoritos = Node.new()
	contenedor_sector_meteoritos.name = "ContenedorSectorMeteoritos"
	add_child(contenedor_sector_meteoritos)


func crear_sector_meteoritos(centro_camara:Vector2, numero_peligros:int) ->void:
	meteoritos_totales = numero_peligros
	var new_sector_meteoritos:SectorMeteoritos = sector_meteoritos.instance()
	new_sector_meteoritos.crear(centro_camara, numero_peligros)
	camara_nivel.global_position = centro_camara
	contenedor_sector_meteoritos.add_child(new_sector_meteoritos)
	camara_nivel.zoom = camara_player.zoom
	camara_nivel.devolver_zoom_original()
	transicion_camara(
		camara_player.global_position,
		camara_nivel.global_position,
		camara_nivel,
		tiempo_transicion_camara
	)


func transicion_camara(desde: Vector2, hasta: Vector2, camara_actual:Camera2D, tiempo_transicion:float) -> void:
	$TweenCamara.interpolate_property(
		camara_actual,
		"global_position",
		desde,
		hasta,
		tiempo_transicion,
		Tween.TRANS_LINEAR,
		Tween.EASE_IN_OUT
	)
	camara_actual.current = true
	$TweenCamara.start()


func controlar_meteoritos_restantes() ->void:
	meteoritos_totales -= 1
	if meteoritos_totales == 0:
		# al termina con todos los meteritos, destruimos el contenedor de meteorita
		contenedor_sector_meteoritos.get_child(0).queue_free()
		camara_player.set_puede_hacer_zoom(true)
		var zoom_actual = camara_player.zoom
		camara_player.zoom = camara_nivel.zoom
		camara_player.zoom_suavizado(zoom_actual.x, zoom_actual.y, 1.0)
		transicion_camara(
			camara_nivel.global_position,
			camara_player.global_position,
			camara_player,
			tiempo_transicion_camara * 0.10
		)


## CONEXION SEÑALES EXTERNAS

func _on_disparo(proyectil:Proyectil) -> void:
	contenedor_proyectiles.add_child(proyectil)

func _on_nave_destruida(posicion:Vector2, num_explosiones:int) -> void:
	for _i in range(num_explosiones):
		var new_explosion:Node2D = explosion.instance()
		new_explosion.global_position = posicion
		add_child(new_explosion)
		yield(get_tree().create_timer(0.6), "timeout")

func _on_spawn_meteoritos(pos_spawn:Vector2, dir_meteorito:Vector2, tamanio:float) -> void:
	var new_meteorito:Meteorito = meteorito.instance()
	new_meteorito.crear(
		pos_spawn,
		dir_meteorito,
		tamanio
	)
	contenedor_meteoritos.add_child(new_meteorito)

func _on_meteorito_destruido(pos:Vector2) -> void:
	var new_explosion:ExplosionMeteorito = explosion_meteorito.instance()
	new_explosion.global_position = pos
	add_child(new_explosion)
	
	controlar_meteoritos_restantes()

func _on_nave_en_sector_peligroso(centro_cam:Vector2, tipo_peligro:String, num_peligros:int) -> void:
	if tipo_peligro == "Meteorito":
		crear_sector_meteoritos(centro_cam, num_peligros)
	elif tipo_peligro == "Enemigo":
		pass



func _on_TweenCamara_tween_completed(object: Object, _key: NodePath) -> void:
	#para solucionar el bog de pantalla al salir de la zona de meteoritos
	if object.name == "CamaraPlayer":
		object.global_position = $Player.global_position
