#Eventos.gd

extends Node

signal disparo(proyectil)
signal nave_destruida(nave, posicion, explosiones)
signal base_destruida(base, posiciones)
signal spawn_meteorito(posicion, direccion, tamanio)
signal spawn_orbital(orbital)
signal meteorito_destruido(posicion)
signal nave_en_sector_peligro(centro_camara, tipo_peligro, num_peligro)

func _ready() -> void:
	pass 


