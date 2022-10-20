#CamaraPlayer
class_name CamaraPlayer
extends CamaraJuego

## ATRIBUTOS EXPORT
export var variacion_zoom:float = 0.1
export var zoom_min:float = 0.6
export var zoom_max:float = 2.0



## METODOS
func _ready() -> void:
	pass

func _unhandled_input(event: InputEvent) -> void:
	# CONTROL DE ZOOM
	if event.is_action_pressed("zoom_acercar"):
		controlar_zoom(-variacion_zoom)
	elif event.is_action_pressed("zoom_alejar"):
		controlar_zoom(variacion_zoom)


## METODOS CUSTOMER
func controlar_zoom(mod_zoom:float) -> void:
	zoom.x = clamp(zoom.x + mod_zoom, zoom_min, zoom_max)
	zoom.y = clamp(zoom.x + mod_zoom, zoom_min, zoom_max)
	zoom_suavizado(zoom.x, zoom.y, 0.15)



