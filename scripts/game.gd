extends Node2D

var menu_scene = load("res://scenes/menu.tscn")

func _ready() -> void:
	var menu = menu_scene.instantiate()
	$Container.add_child(menu)
