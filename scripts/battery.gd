extends Carryable
class_name Battery

# ----- VARIABLES ----- #
#var GRAVITY : float
var MAX_FUEL : int = 3
var BASE_WEIGHT : float = 15
var FUEL_WEIGHT : float = 5
var fuel_level : int = 0

func _ready() -> void:
	#GRAVITY = World.GRAVITY
	z_index = 0
	weight = BASE_WEIGHT
	change_battery_sprite()

func can_fuel():
	return fuel_level < MAX_FUEL

func increase_fuel():
	fuel_level += 1
	change_battery_sprite()
	weight = BASE_WEIGHT + fuel_level * FUEL_WEIGHT

func change_battery_sprite():
	$Sprite2D.texture = load("res://assets/battery"+str(fuel_level)+".png")
