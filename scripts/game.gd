extends Node2D

const MAIN_MENU = preload("res://scenes/menu.tscn")
const SELECTION_MENU = preload("res://scenes/selection_menu.tscn")

func _ready() -> void:
	load_main_menu()
	await get_tree().process_frame
	print(Input.get_connected_joypads())
	Input.joy_connection_changed.connect(_on_joy_connection_changed)
	

func unload():
		# Remove menu
	for child in $Menu_Container.get_children():
		child.queue_free()

	# Remove previous level
	for child in $Level_Container.get_children():
		child.queue_free()

func load_main_menu():
	unload()
	var menu = MAIN_MENU.instantiate()
	menu.start_pressed.connect(_on_start_pressed)
	$Menu_Container.add_child(menu)


func load_level(path: String):
	unload()
	# Add new level
	var level = load(path).instantiate()
	$Level_Container.add_child(level)


func load_selection_menu():
	unload()
	var menu = SELECTION_MENU.instantiate()
	menu.start_game_pressed.connect(_on_start_game_pressed)
	$Menu_Container.add_child(menu)


func _on_start_pressed():
	load_selection_menu()


func _on_start_game_pressed():
	load_level($Menu_Container/selection_menu.level_path)


func _on_joy_connection_changed(device: int, connected: bool):
	print(device, connected)
