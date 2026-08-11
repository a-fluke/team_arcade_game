extends Node2D

enum Game_State {
	MENU,SELECT,PLAYING,PAUSED
	}

const MAIN_MENU = preload("res://scenes/menu.tscn")
const SELECTION_MENU = preload("res://scenes/selection_menu.tscn")


var game_state 

func _ready() -> void:
	load_main_menu()
	await get_tree().process_frame
	

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
	game_state = Game_State.MENU


func load_level(path: String):
	unload()
	# Add new level
	var level = load(path).instantiate()
	$Level_Container.add_child(level)
	selectors_to_players()
	#cursors_to_players()
	game_state = Game_State.PLAYING


func load_selection_menu():
	unload()
	var menu = SELECTION_MENU.instantiate()
	menu.start_game_pressed.connect(_on_start_game_pressed)
	$Menu_Container.add_child(menu)
	game_state = Game_State.SELECT

func selectors_to_players():
	$Player_Container.selectors_to_players()

#func cursors_to_players():
	#var inputs : Array[Player_Input]
	#
	#for player in $Player_Container.get_children():
		##var new_input = Player_Input.new()
		##new_input
		#inputs.append(player.player_input)
		#player.queue_free()
	#
	#for i in inputs:
		#var player = PLAYER.instantiate()
		#player.position = Vector2(randi_range(200,500),300)
		#player.player_input = i
		#$Player_Container.add_child(player)
	

func _on_start_pressed():
	load_selection_menu()


func _on_start_game_pressed():
	load_level($Menu_Container/selection_menu.level_path)
