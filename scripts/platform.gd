extends Node2D

@export var color : String

func _ready() -> void:
	$Sprite2D.texture = load("res://assets/platform_%s.png" % color)
