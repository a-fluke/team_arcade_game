extends Node2D

const PLAYER = preload("res://scenes/player.tscn")

var selection_row = 0
const SELECT_START_HEIGHT = 72
const SELECT_SPACING = 36

var player_ready_array : Array[bool]


func add_selector(selector):
	selector.row = selection_row
	selection_row += 1
	
	selector.position = Vector2(320,SELECT_START_HEIGHT+(SELECT_SPACING*selector.row))
	selector.target_position = selector.position
	
	var Info = Player_Info.new()
	Info.status = Player_Info.Status.SELECTOR
	Info.player_id = selector.row
	
	selector.info = Info
	
	selector.readied_up.connect(_on_player_ready_update)
	player_ready_array.append(false)
	
	$Selectors.add_child(selector)


func selectors_to_players():
	var inputs : Array[Player_Input]
	var infos : Array[Player_Info]
	
	for selector in $Selectors.get_children():
		inputs.append(selector.player_input)
		infos.append(selector.info)
		selector.queue_free()
	
	for i in inputs.size():
		var player = PLAYER.instantiate()
		player.position = Vector2(randi_range(200,500),300)
		player.player_input = inputs[i]
		player.player_info = infos[i]
		$Players.add_child(player)


func _on_player_ready_update(player,status):
	player_ready_array[player.row] = status


func players_ready():
	var all_true = player_ready_array.all(func(element): return element == true)
	return all_true
