#Camino.gd
extends Node2D

#export var dir_horario:bool = true
export var velocidad:float = 200.0
export var escala_luna:int = 1

onready var luna_rotando:Area2D = $Path2D/PathFollow2D/LunaRotando
onready var path_follow_2D:PathFollow2D = $Path2D/PathFollow2D


func _ready() -> void:
	luna_propiedades(velocidad,escala_luna)


func _on_LunaRotando_body_entered(body: Node) -> void:
	if body.has_method("destruir"):
		body.destruir()

func luna_propiedades(vel:float, scal:int) -> void:
	luna_rotando.scale = Vector2(scal,scal)
	path_follow_2D.set_velocidad(vel)
