#MenuPpal.gd
class_name MenuPpal
extends Node

export(String, FILE, "*.tscn") var nivel_inicial = ""

## METODOS
func _ready() -> void:
	#activa pantalla completa en el juego
	OS.set_window_fullscreen(true)
	MusicaJuego.play_musica(MusicaJuego.get_lista_musicas().menu_principal)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pausa"):
		salir_juego()

## METODOS CUSTOM
func salir_juego() -> void:
	get_tree().quit()

## SEÑALES INTERNAS
func _on_Button_pressed() -> void:
	MusicaJuego.play_boton()
	get_tree().change_scene(nivel_inicial)


func _on_ButtonSalir_pressed() -> void:
	salir_juego()
	#get_tree().quit()


