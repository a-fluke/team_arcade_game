extends Node2D

signal start_game_pressed

var player_row = 0
const PLAYER_START_HEIGHT = 72
const PLAYER_SPACING = 36


var level_path : String = "res://scenes/level_1.tscn"

func _ready() -> void:
	z_index = World.BACKGROUND_Z

func _on_button_pressed() -> void:
	start_game_pressed.emit()

func _on_button_button_pressed() -> void:
	start_game_pressed.emit()

func add_player(player):
	player.row = player_row
	player_row += 1
	player.position = Vector2(320,PLAYER_START_HEIGHT+(PLAYER_SPACING*player.row))
	player.target_position = player.position
	$Players.add_child(player)
