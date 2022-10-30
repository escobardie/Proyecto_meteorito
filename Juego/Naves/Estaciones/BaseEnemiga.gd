##BaseEnemiga.gd
class_name BaseEnemiga
extends Node2D

## ATRIBUTOS EXPORT
export var hitpoints:float = 30.0
export var orbital:PackedScene = null
export var numero_orbitales:int = 10
export var intervalo_spawn:float = 1.5

## ATRIBUTOS ONREADY
onready var impacto_sfx:AudioStreamPlayer = $ImpactoSFX
onready var timer_spawner_orbitales:Timer = $TimerSpawnerEnemigos
onready var ruta_enemiga:Path2D = $RutaEnemiga

## ATRIBUTOS
var esta_destruida:bool = false
var posicion_spawn:Vector2 = Vector2.ZERO

## METODOS
func _ready() -> void:
	timer_spawner_orbitales.wait_time = intervalo_spawn
	$AnimationPlayer.play(elegir_animacion_random())

func _process(_delta: float) -> void:
	var player_objetivo:Player = DatosJuego.get_player_actual()
	if not player_objetivo:
		return
	
	var dir_player:Vector2 = player_objetivo.global_position - global_position
	var angular_player:float = rad2deg(dir_player.angle())
	print(angular_player)



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
	Eventos.emit_signal("base_destruida", self, posicion_partes)
	queue_free()

func spawn_orbital() -> void:
	numero_orbitales -= 1
	ruta_enemiga.global_position = global_position
	
	#var pos_spawn:Vector2 = deteccion_cuadrante()
	#ruta_enemiga.global_position = global_position
	
	var new_orbital:EnemigoOrbital = orbital.instance() #orbital.instance()
	new_orbital.crear(
		global_position + posicion_spawn,
		self,
		ruta_enemiga
	)
	Eventos.emit_signal("spawn_orbital",new_orbital)

func deteccion_cuadrante() -> Vector2:
	var player_objetivo:Player = DatosJuego.get_player_actual()
	
	if not player_objetivo:
		return Vector2.ZERO
	
	var dir_player:Vector2 = player_objetivo.global_position - global_position
	var angulo_player:float = rad2deg(dir_player.angle())
	
	if abs(angulo_player) <= 45.0:
		# PLAYER ENTRA POR LA DERECHA
		ruta_enemiga.rotation_degrees = 180.0
		return $PosicionesSpawn/Este.position
	elif abs(angulo_player) > 135.0 and abs(angulo_player) <= 180.0:
		# PLAYER ENTRA POR LA IZQUIERDA
		ruta_enemiga.rotation_degrees = 0.0
		return $PosicionesSpawn/Oeste.position
	elif abs(angulo_player) > 45.0 and abs(angulo_player) <= 135.0:
		# PLAYER ENTRA POR ARRIBA O POR DEBAJO
		if sign(angulo_player) > 0:
			# PLAYER ENTRA POR ABAJO
			ruta_enemiga.rotation_degrees = 270.0
			return $PosicionesSpawn/Sur.position
		else:
			# PLAYER ENTRA POR ARRIBA
			ruta_enemiga.rotation_degrees = 90.0
			return $PosicionesSpawn/Norte.position
	
	return $PosicionesSpawn/Norte.position




## SEÑALES INTERNAS
func _on_AreaColision_body_entered(body: Node) -> void:
	if body.has_method("destruir"):
		body.destruir()


func _on_VisibilityNotifier2D_screen_entered() -> void:
	#SPAWNER ORBITAL
	$VisibilityNotifier2D.queue_free()
	posicion_spawn = deteccion_cuadrante()
	spawn_orbital()
	timer_spawner_orbitales.start()
	
#	var new_orbital:EnemigoOrbital = orbital.instance()
#	new_orbital.crear(
#		global_position + $PosicionesSpawn/Norte.global_position,
#		self
#	)
#	Eventos.emit_signal("spawn_orbital", new_orbital)


func _on_TimerSpawnerEnemigos_timeout() -> void:
	if numero_orbitales == 0:
		timer_spawner_orbitales.start()
		return
	spawn_orbital()
