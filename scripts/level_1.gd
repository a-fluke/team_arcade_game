extends Node2D

var blue_team : int = 0

func _ready() -> void:
	$battery_emptier.charge.connect(_charge_ship)


func _charge_ship(team):
	if team == "blue":
		blue_team += 1
		print(blue_team)
