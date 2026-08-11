extends Carryable
class_name Battery

# ----- VARIABLES ----- #
#var GRAVITY : float
var MAX_FUEL : int = 3
var BASE_WEIGHT : float = 20
var FUEL_WEIGHT : float = 10
var fuel_level : int = 0

func _ready() -> void:
	#GRAVITY = World.GRAVITY
	z_index = 0
	weight = BASE_WEIGHT
	change_battery_sprite()

func can_fuel():
	return fuel_level < MAX_FUEL

func can_empty():
	return fuel_level > 0

func increase_fuel():
	fuel_level += 1
	change_battery_sprite()
	weight = BASE_WEIGHT + fuel_level * FUEL_WEIGHT

func reduce_fuel() -> bool:
	fuel_level -= 1
	change_battery_sprite()
	weight = BASE_WEIGHT + fuel_level * FUEL_WEIGHT
	if fuel_level == 0:
		return true
	else:
		return false

func change_battery_sprite():
	$Sprite2D.texture = load("res://assets/battery"+str(fuel_level)+".png")
