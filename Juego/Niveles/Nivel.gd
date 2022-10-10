#Nivel.gb
class_name Nivel
extends Node2D

## ATRIBUTOS ONREADY
onready var contenedor_proyectiles:Node

## METODOS
func _ready() -> void:
	conectar_seniales()
	crear_contenedor()

## METODOS CUSTOMER
func conectar_seniales() -> void:
	Eventos.connect("disparo", self, "_on_disparo")

func crear_contenedor() -> void:
	contenedor_proyectiles = Node.new()
	contenedor_proyectiles.name = "ContenedorProyectiles"
	add_child(contenedor_proyectiles)

func _on_disparo(proyectil:Proyectil) -> void:
	contenedor_proyectiles.add_child(proyectil)
