extends Node2D

const MAIN_MENU = preload("res://scenes/menu.tscn")

func _ready() -> void:
	load_main_menu()
	

func load_main_menu():
	var menu = MAIN_MENU.instantiate()
	menu.start_pressed.connect(_on_start_pressed)
	$Menu_Container.add_child(menu)


func load_level(path: String):
	# Remove menu
	for child in $Menu_Container.get_children():
		child.queue_free()

	# Remove previous level
	for child in $Level_Container.get_children():
		child.queue_free()

	# Add new level
	var level = load(path).instantiate()
	$Level_Container.add_child(level)


func _on_start_pressed():
	load_level("res://scenes/level_1.tscn")
