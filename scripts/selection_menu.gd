extends Node2D

signal start_game_pressed

var level_path : String = "res://scenes/level_1.tscn"

func _on_button_pressed() -> void:
	start_game_pressed.emit()
