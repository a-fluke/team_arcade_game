extends CharacterBody2D
class_name Player_Cursor

signal interact

var player_id : int
var speed : int = 500
var player_input : Player_Input
var radius : int = 3


func _ready() -> void:
	$player_num.text = "P%d" % (player_id + 1)
	$player_num.add_theme_color_override("font_color",World.PLAYER_COLORS[player_id])
	global_position = get_viewport_rect().size/2 + Vector2(0,-50)


func _physics_process(delta: float) -> void:
	move_cursor(delta)
	if player_input.a_just_pressed():
		interact.emit()
	queue_redraw()

func move_cursor(delta):
	var movement = player_input.left_stick
	
	# Deadzone
	if movement.length() < 0.2:
		movement = Vector2.ZERO
		
	velocity = movement * speed
	move_and_slide()


func _draw() -> void:
	draw_circle(Vector2.ZERO,radius,World.PLAYER_COLORS[player_id],false,2)
