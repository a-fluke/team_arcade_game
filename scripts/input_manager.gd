extends Node

var PLAYER_CURSOR = preload("res://scenes/player_cursor.tscn")
var PLAYER_SELECT = preload("res://scenes/player_select.tscn")

class PlayerSlot:
	var device_id: int
	var team : int = 0
	var ready : bool = false
	var player_input : Player_Input

var player_slots : Array[PlayerSlot] = []
var player_device_map : Dictionary = {}


func _physics_process(delta: float) -> void:
	for slot in player_slots:
		update_input(slot)

func _input(event: InputEvent) -> void:
	if get_parent().game_state == get_parent().Game_State.SELECT:
		if event is InputEventJoypadButton and event.pressed:
			var device = event.device
			if !device_is_joined(device):
				join(device)
		elif event.is_action_pressed("right") or \
			event.is_action_pressed("left") or \
			event.is_action_pressed("up") or \
			event.is_action_pressed("down") or \
			event.is_action_pressed("item") or \
			event.is_action_pressed("jump"):
				var device = -1
				if !device_is_joined(device):
					join(device)


func update_input(player : PlayerSlot):
	update_buttons(player)
	update_left_stick(player)

func update_buttons(slot):
	var input = slot.player_input
	
	input.a_previous = input.a_current
	input.b_previous = input.b_current
	
	if slot.device_id != -1:
		input.a_current = Input.is_joy_button_pressed(
			slot.device_id,
			JOY_BUTTON_A
		)
		
		
		input.b_current = Input.is_joy_button_pressed(
			slot.device_id,
			JOY_BUTTON_B
		)
	else:
		input.a_current = Input.is_action_just_pressed("jump")
		input.b_current = Input.is_action_just_pressed("item")

func update_left_stick(slot):
	var input = slot.player_input
	input.left_previous = input.left_current
	input.right_previous = input.right_current
	if slot.device_id != -1:
		input.left_stick = Vector2(
				Input.get_joy_axis(slot.device_id, JOY_AXIS_LEFT_X),
				Input.get_joy_axis(slot.device_id, JOY_AXIS_LEFT_Y)
			)
	else:
		input.left_stick = Input.get_vector("left","right","up","down")
	input.left_current = input.left_stick.x < -input.stick_thresh
	input.right_current = input.left_stick.x > input.stick_thresh

func device_is_joined(device):
	for player in player_slots:
		if player.device_id == device:
			return true
	return false

func join(device):
	if World.player_count < World.MAX_PLAYERS:
		var slot = PlayerSlot.new()
		var player_id = player_slots.size()

		# add slot for player
		slot.device_id = device
		slot.player_input = Player_Input.new()
		player_slots.append(slot)
		
		# create player select
		var player_select = PLAYER_SELECT.instantiate()
		player_select.player_input = slot.player_input
		
		#get_tree().current_scene.get_node("Menu_Container/selection_menu").add_player(player_select)
		get_tree().current_scene.get_node("Player_Container").add_selector(player_select)
		
		# map device to player
		player_device_map[device] = player_id

func get_player_id(device):
	return player_device_map[device]
