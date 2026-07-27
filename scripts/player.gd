extends CharacterBody2D

# ------- VARIABLES ------- #
@export var debug : bool = false
# ------- TIMERS ------- #

var JUMP_BUFFER_TIME : float = 0.1
var COYOTE_TIME : float = 0.1
# ------- CHARACTER ------- #
# --- constants --- #
var GRAVITY : float
const MAX_JUMPS : int = 2
const ACCEL_GROUND : float = 600.0
const DECEL_GROUND : float = 1000.0
const ACCEL_GROUND_TURN : float = 900.0
const ACCEL_AIR : float = 300.0
const ACCEL_AIR_TURN : float = 800.0
const SPEED_GROUND : float = 120.0
const SPEED_AIR : float = 100.0
var JUMP_FORCE_GROUND : float = 280.0
var JUMP_FORCE_AIR : float = 220.0
var HOLD_OFFSET : int
var RANGE_OFFSET : int

# --- states --- #
var coyote_time : float = 0
var jumps_used : int = 0
var was_on_floor : bool = false
var movement_enabled : bool = true
var move_modifier : float = 0.0

var held_item : Carryable = null
var nearby_items : Array[Carryable] = []
var facing : Vector2

# --- inputs --- #
var horizontal_dir : int = 0
var jump_buffer : float = 0
var player_input : Player_Input

func _ready() -> void:
	GRAVITY = World.GRAVITY
	HOLD_OFFSET = $hold_point.position.x
	RANGE_OFFSET = $range.position.x
	facing = Vector2.RIGHT if not $sprite.flip_h else Vector2.LEFT
	if debug:
		debug_setup()


func _physics_process(delta: float) -> void:
	update_buffers(delta)
	update_modifiers()
	handle_input()
	handle_gravity(delta)
	check_jump()
	handle_movement(delta)
	
	flip_player()
	move_and_slide()
	
	update_jump_state()

func _process(delta: float) -> void:
	
	item_interact()
	if debug:
		debug_updates()

# ----- INPUT ----- #
func handle_input():
	if movement_enabled:
		if Input.is_action_just_pressed("jump") or player_input.a_just_pressed():
			jump_buffer =JUMP_BUFFER_TIME
		
		var movement = player_input.left_stick.x
		horizontal_dir = sign(movement) if abs(movement) > 0.2 else 0.0
		
		#horizontal_dir = Input.get_axis("left","right")

# ------ JUMP FUNCTIONS ----- #
func check_jump():
	if jump_buffer > 0 and jumps_used < MAX_JUMPS:
		jump()
		jump_buffer = 0

func jump():
	if jumps_used == 0:
		velocity.y = -lerp(JUMP_FORCE_GROUND,JUMP_FORCE_GROUND*0.75,move_modifier)
	else:
		velocity.y = -lerp(JUMP_FORCE_AIR,JUMP_FORCE_AIR*0.9,move_modifier)
	
	jumps_used += 1

func update_jump_state():
	var on_floor = is_on_floor()
	
	if on_floor:
		jumps_used = 0
		coyote_time = 0
	elif was_on_floor and not on_floor:
		coyote_time = COYOTE_TIME
	
	was_on_floor = on_floor

func update_buffers(delta):
	if jump_buffer > 0:
		jump_buffer -= delta
	if coyote_time > 0:
		coyote_time -= delta
		
		if coyote_time <= 0 and jumps_used == 0:
			jumps_used = 1

# ----- MOVEMENT FUNTIONS ----- #
func handle_gravity(delta):
	#gravity
	if velocity.y < 0:
		velocity.y += GRAVITY * delta
	else:
		velocity.y += GRAVITY * 1.5 * delta

func handle_movement(delta):
	var is_turn = (sign(horizontal_dir) != sign(velocity.x) and velocity.x != 0)
	
	var accel = 0
	var speed = 0
	if not is_on_floor():
		speed = SPEED_AIR
		if is_turn:
			accel = ACCEL_AIR_TURN
		else:
			accel = ACCEL_AIR
	else: 
		speed = SPEED_GROUND
		if horizontal_dir == 0:
			accel = DECEL_GROUND
		elif is_turn:
			accel = ACCEL_GROUND_TURN
		else:
			accel = ACCEL_GROUND
	
	speed = lerp(speed ,speed * 0.7, move_modifier)
	accel = lerp(accel, accel * 0.6, move_modifier)
	velocity.x = \
		move_toward(velocity.x,horizontal_dir*speed,accel * delta)

func get_movement_modifier() -> float:
	var modifier = 0.0
	
	if held_item:
		modifier += clamp(held_item.weight/100, 0.0, 1.0)
	
	return modifier

func update_modifiers():
	move_modifier = get_movement_modifier()

# ----- INTERACTION FUNCS ----- #
func item_interact():
	if Input.is_action_just_pressed("item"):
		if held_item:
			held_item.drop()
			held_item = null
		else:
			var item = find_nearby_item()
			if item:
				item.pickup(self)
				held_item = item

func find_nearby_item() -> Carryable:
	var closest_item = null
	var current_score = -INF
	for item in nearby_items:
		var score = get_interation_score(item)
		if score > current_score:
			closest_item = item
			current_score = score
	return closest_item

func get_interation_score(item):
	var to_item = item.global_position - global_position
	var distance = to_item.length()
	var facing_bonus = 0
	if to_item * facing > Vector2.ZERO:
		facing_bonus = 1000
	return facing_bonus - distance

# ----- ANIMATION FUNCS ----- #
func flip_player():
	if velocity.x < 0: 
		$sprite.flip_h = true
		$hold_point.position.x = -HOLD_OFFSET
		$range.position.x = -RANGE_OFFSET
		facing = Vector2.LEFT
	elif velocity.x > 0:
		$sprite.flip_h = false
		$hold_point.position.x = HOLD_OFFSET
		$range.position.x = RANGE_OFFSET
		facing = Vector2.RIGHT

# ----- UTILITIES ----- #
func debug_setup():
	$OffPlatform.show()

func debug_updates():
	$OffPlatform.text = str($coyoteTime.time_left)

func _on_range_body_entered(body: Node2D) -> void:
	if body is Carryable:
		nearby_items.append(body)

func _on_range_body_exited(body: Node2D) -> void:
	if body is Carryable:
		nearby_items.erase(body)
