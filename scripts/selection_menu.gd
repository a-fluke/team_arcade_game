extends Node2D

signal start_game_pressed


var level_path : String = "res://scenes/level_1.tscn"

func _ready() -> void:
	z_index = World.BACKGROUND_Z

func _on_start_pressed() -> void:
	start_game_pressed.emit()
