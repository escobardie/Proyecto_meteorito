#ExplosionMeteorito
class_name ExplosionMeteorito
extends Node2D

## ATRIBUTO ONREADY


func _ready() -> void:
	$AnimationPlayer.play(elerig_explosion_random())


func elerig_explosion_random() -> String:
	randomize()
	var num_anim:int = $AnimationPlayer.get_animation_list().size() - 1
	var indice_anim_random:int = randi() % num_anim + 1
	var list_animacion:Array = $AnimationPlayer.get_animation_list()
	
	return list_animacion[indice_anim_random]


func _on_AnimationPlayer_animation_finished(_anim_name: String) -> void:
	queue_free()
