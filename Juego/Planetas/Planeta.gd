#Planeta.gd

extends Node2D



func _on_AreaColisionPlaneta_body_entered(body: Node) -> void:
	if body.has_method("destruir"):
		body.destruir()
