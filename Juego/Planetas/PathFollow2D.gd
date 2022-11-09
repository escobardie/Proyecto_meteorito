extends PathFollow2D

# ATRIBUTOS
var velocidad:float = 0.0 setget set_velocidad


## GETTER AND SETTER
func set_velocidad(vel:float) -> void:
	velocidad = vel


## METODOS
#https://www.youtube.com/watch?v=IoKHAViH0M4
func _process(delta: float) -> void:
	set_offset(get_offset() + velocidad * delta)
