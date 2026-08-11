extends Node2D

signal readied_up

var columns_x = {
	'blue' : 160,
	'neutral' : 320,
	'red' : 480
}

var row
var column = 'neutral'
var target_position
var player_input : Player_Input
var player_ready = false
var color : String
var color_ind : int
var info : Player_Info


func _ready() -> void:
	get_first_color()

func _physics_process(delta: float) -> void:
	if !player_ready:
		if player_input.left_just_pressed():
			move_left()
		
		if player_input.right_just_pressed():
			move_right()
		
		if player_input.a_just_pressed() and column != 'neutral':
			ready_up()
		
		if player_input.b_just_pressed():
			cycle_color()
		
	else:
		if player_input.b_just_pressed():
			unready()
	#move
	global_position = global_position.lerp(target_position,12*delta)
	$AnimatedSprite2D.play("%s_%s"%[color,column])
	update_info()

func update_info():
	info.team = column
	info.color = color

func ready_up():
	player_ready = true
	readied_up.emit()

func unready():
	column = 'neutral'
	target_position.x = columns_x[column]
	player_ready = false

func move_left():
	match column:
		'blue':
			pass
		'red':
			column = 'blue'
			target_position.x = columns_x['blue']
		'neutral':
			column = 'blue'
			target_position.x = columns_x['blue']

func move_right():
	match column:
		'blue':
			column = 'red'
			target_position.x = columns_x['red']
		'red':
			pass
		'neutral':
			column = 'red'
			target_position.x = columns_x['red']

func cycle_color():
	var new_color = (color_ind + 1)%8
	while !World.available_colors[World.player_colors[new_color]]:
		new_color = (new_color+1)%8
	
	color_ind = new_color
	World.available_colors[color] = true
	color = World.player_colors[color_ind]
	World.available_colors[color] = false

func get_first_color():
	var ind = 0
	for c in World.player_colors:
		if World.available_colors[c]:
			color = c
			color_ind = ind
			World.available_colors[c] = false
			break
		ind += 1
