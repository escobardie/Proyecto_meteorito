#ExplosionMeteorito
class_name ExplosionMeteorito
extends Node2D

## ATRIBUTO ONREADY


func _ready() -> void:
	pass 


func _on_AnimationPlayer_animation_finished(_anim_name: String) -> void:
	queue_free()
