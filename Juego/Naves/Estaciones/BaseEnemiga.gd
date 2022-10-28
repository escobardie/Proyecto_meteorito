##BaseEnemiga.gd
class_name BaseEnemiga
extends Node2D

## ATRIBUTOS EXPORT
export var hitpoints:float = 30.0
export var orbital:PackedScene = null

## ATRIBUTOS ONREADY
onready var impacto_sfx:AudioStreamPlayer = $ImpactoSFX

## ATRIBUTOS
var esta_destruida:bool = false


## METODOS
func _ready() -> void:
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
	var pos_spawn:Vector2 = deteccion_cuadrante()
	
	var new_orbital:EnemigoOrbital = orbital.instance() #orbital.instance()
	new_orbital.crear(
		global_position + pos_spawn,
		self
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
		return $PosicionesSpawn/Este.position
	elif abs(angulo_player) > 135.0 and abs(angulo_player) <= 180.0:
		# PLAYER ENTRA POR LA IZQUIERDA
		return $PosicionesSpawn/Oeste.position
	elif abs(angulo_player) > 45.0 and abs(angulo_player) <= 135.0:
		# PLAYER ENTRA POR ARRIBA O POR DEBAJO
		if sign(angulo_player) > 0:
			# PLAYER ENTRA POR ABAJO
			return $PosicionesSpawn/Sur.position
		else:
			# PLAYER ENTRA POR ARRIBA
			return $PosicionesSpawn/Norte.position
	
	return $PosicionesSpawn/Norte.position




## SEÑALES INTERNAS
func _on_AreaColision_body_entered(body: Node) -> void:
	if body.has_method("destruir"):
		body.destruir()


func _on_VisibilityNotifier2D_screen_entered() -> void:
	#SPAWNER ORBITAL
	$VisibilityNotifier2D.queue_free()
	
	spawn_orbital()
	
#	var new_orbital:EnemigoOrbital = orbital.instance()
#	new_orbital.crear(
#		global_position + $PosicionesSpawn/Norte.global_position,
#		self
#	)
#	Eventos.emit_signal("spawn_orbital", new_orbital)
