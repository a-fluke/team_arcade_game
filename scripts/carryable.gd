extends CharacterBody2D
class_name Carryable

signal dropped

enum State {
	GROUND,
	HELD,
	PLACED
}

var COLLISION_LAYER : int = 3
var COLLISION_MASK  : int = 1

var spawn_position : Vector2
var state = State.GROUND
var carrier = null
var weight : float = 0

func pickup(player):
	# item on ground
	if state == State.HELD:
		pass
	else:
		if state == State.PLACED:
			carrier.empty()
		state = State.HELD
		carrier = player
		z_index = World.HELD_ITEM_Z


func drop():
	carrier = null
	state = State.GROUND
	velocity = Vector2.ZERO
	dropped.emit(self)
	z_index = World.DROPPED_ITEM_Z

func place(dock_loc,dock):
	position = dock_loc
	state = State.PLACED
	carrier = dock
	velocity = Vector2.ZERO
	z_index = World.PLACED_ITEM_Z

func reject(location):
	position = location
	state = State.GROUND
	z_index = World.DROPPED_ITEM_Z

func _physics_process(delta: float) -> void:
	match state:
		State.GROUND:
			ground_movement(delta)
		State.HELD:
			held_movement()
		State.PLACED:
			pass

func ground_movement(delta):
	if velocity.y < 0:
		velocity.y += World.GRAVITY * delta
	else: 
		velocity.y += World.GRAVITY * 1.5 * delta
	move_and_slide()

func held_movement():
	var hold_point = carrier.get_node("hold_point")
	global_position = hold_point.global_position
