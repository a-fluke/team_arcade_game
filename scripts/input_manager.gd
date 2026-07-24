extends Node

var PLAYER_CURSOR = preload("res://scenes/player_cursor.tscn")

class PlayerSlot:
	var device_id: int
	var team : int = 0
	var ready : bool = false
	var player_input : Player_Input

var player_slots : Array[PlayerSlot] = []
var player_device_map : Dictionary = {}


func _process(delta: float) -> void:
	for player in player_slots:
		update_left_stick(player)


func _input(event: InputEvent) -> void:
	if event is InputEventJoypadButton and event.pressed:
		var device = event.device
		
		if !device_is_joined(device):
			join(device)
		else:
			match event.button_index:
				JOY_BUTTON_A:
					pass
				JOY_BUTTON_B:
					pass
				JOY_BUTTON_X:
					pass
				JOY_BUTTON_Y:
					pass


func update_left_stick(player):
	player.player_input.left_stick = Vector2(
			Input.get_joy_axis(player.device_id, JOY_AXIS_LEFT_X),
			Input.get_joy_axis(player.device_id, JOY_AXIS_LEFT_Y)
		)

func device_is_joined(device):
	for player in player_slots:
		if player.device_id == device:
			return true
	return false


func join(device):
	var slot = PlayerSlot.new()
	var player_id = player_slots.size()

	# add slot for player
	slot.device_id = device
	slot.player_input = Player_Input.new()
	player_slots.append(slot)
	
	# create player cursor
	var player_cursor = PLAYER_CURSOR.instantiate()
	player_cursor.player_id = player_id
	player_cursor.player_input = slot.player_input
	
	# map device to player
	player_device_map[device] = player_id
	
	add_child(player_cursor)


func get_player_id(device):
	return player_device_map[device]
