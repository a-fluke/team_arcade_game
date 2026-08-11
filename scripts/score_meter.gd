extends Node2D

@export var team := "blue"
var max := 33


func _ready() -> void:
	set_level(0)
	

func set_level(level : int):
	$Panel.size.y = level
	$Panel.position.y = -level
