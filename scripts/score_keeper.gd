extends Node2D

signal team_win(team)

const MAX_CHARGE = 240
const CHARGE_INC = 8

@export var team = "blue"

func _ready() -> void:
	$background.texture = load("res://assets/ui/%s_ui_back.png"%team)
	$foreground.texture = load("res://assets/ui/%s_ui.png"%team)
	z_index = World.FOREGROUND_Z
	$charge.size.x = 0
	if team == "blue":
		$charge.position.x = -125
		
	elif team == "red":
		$charge.position.x = 125
		


func increase_charge():
	$charge.size.x += CHARGE_INC
	if team == "red":
		$charge.position.x -= CHARGE_INC
	if $charge.size.x == MAX_CHARGE:
		team_win.emit(team)
