#SectorMeteoritos.gd
class_name SectorMeteoritos
extends Node2D

## ATRIBUTOS EXPORT
export var cantidad_meteoritos:int = 10
export var intervalo_spawn:float = 1.2

## ATRIBUTOS
var spawners:Array

## METODOS 
func _ready() -> void:
	$Timer.wait_time = intervalo_spawn
	almacenar_spawners()
	conectar_seniales_detectores()

## METODOS CUSTOMER
func almacenar_spawners() -> void:
	for spawner in $Spawners.get_children():
		spawners.append(spawner)

func spawner_random() -> int:
	randomize()
	return randi() % spawners.size()

func conectar_seniales_detectores() -> void:
	for detector in $DetectorFueraZona.get_children():
		detector.connect("body_entered", self, "_on_detector_body_entered")


#SEÑALES INTERNA
func _on_SpawnTimer_timeout() -> void:
	if cantidad_meteoritos == 0:
		$Timer.stop()
		return
	spawners[spawner_random()].spawnear_meteorito()
	cantidad_meteoritos -=1

func _on_detector_body_entered(body: Node) -> void:
	body.set_esta_en_sector(false)

#CONSTRUCTOR
func crear(pos:Vector2, meteoritos:int) -> void:
	global_position = pos
	cantidad_meteoritos = meteoritos


