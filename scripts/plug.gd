extends Carryable
class_name Cable

signal docked
signal removed

# ----- VARIABLES ----- #
var BASE_WEIGHT : float = 500

var team = "blue"

var prev_pos : float
var moving_left := false
var moving_right := false
var start_position : float
var recoil_speed := 400
var arrival_tolerance := 2

func _ready() -> void:
	$Sprite2D.texture = load("res://assets/outlet/%s_plug.png"%team)
	z_index = 0
	weight = BASE_WEIGHT
	prev_pos = global_position.x
	start_position = global_position.x
	

func _physics_process(delta: float) -> void:
	match state:
		State.GROUND:
			ground_movement(delta)
		State.HELD:
			held_movement()
		State.PLACED:
			pass

	if prev_pos > global_position.x:
		moving_left = true
		moving_right = false
	elif prev_pos < global_position.x:
		moving_right = true
		moving_left = false
	else:
		moving_left = false
		moving_right = false
	prev_pos = global_position.x

func pickup(player):
	# item on ground
	if state == State.HELD:
		pass
	else:
		if state == State.PLACED:
			carrier.empty()
			$Sprite2D.texture = load("res://assets/outlet/%s_plug.png"%team)
			removed.emit()
		state = State.HELD
		carrier = player
		z_index = World.HELD_ITEM_Z

func place(dock_loc,dock):
	global_position = dock_loc
	state = State.PLACED
	carrier = dock
	velocity = Vector2.ZERO
	z_index = World.PLACED_ITEM_Z
	
	$Sprite2D.texture = load("res://assets/outlet/%s_docked.png"%team)
	docked.emit()
	

func held_movement():
	var hold_point = carrier.get_node("plug_hold_point")
	global_position = hold_point.global_position

func ground_movement(delta):
	if velocity.y < 0:
		velocity.y += World.GRAVITY * delta
	else: 
		velocity.y += World.GRAVITY * 1.5 * delta
	var distance = abs(start_position - global_position.x)
	if distance <= arrival_tolerance:
		velocity.x = 0
		global_position.x = start_position
	else:
		velocity.x = sign(start_position - global_position.x) * recoil_speed * delta
	move_and_slide()
