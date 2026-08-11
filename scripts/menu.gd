extends Node2D

signal start_pressed

func _ready() -> void:
	z_index = World.BACKGROUND_Z
	$button_manager/start.grab_focus()

func _on_start_pressed() -> void:
	start_pressed.emit()


func _on_button_button_pressed() -> void:
	start_pressed.emit()


func _on_quit_pressed() -> void:
	get_tree().quit()
