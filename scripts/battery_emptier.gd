extends Dock
class_name Battery_Emptier

signal charge(team)
signal emptied(battery)
@export var team = "red"

func _ready() -> void:
	$Sprite2D.texture = load("res://assets/%s_tower.png"%team)
	docking_location = $battery_placer.global_position
	$fuelTimer.wait_time = 1.0

func accepts(item,player):
	return item is Battery and player.player_info.team == team

func empty():
	state = State.EMPTY
	$fuelTimer.stop()


func _dock(item : Carryable):
	if (state == State.EMPTY or state == State.PARTIAL):
		item.place(docking_location,self)
		state = State.FULL
		docked_item = item
		if item.can_empty():
			$fuelTimer.start()
	else:
		var rejection_loc = Vector2([1,-1].pick_random() * randi_range(10,16),0)
		item.reject(docking_location + rejection_loc)

func _on_fuel_timer_timeout() -> void:
	if docked_item.can_empty():
		var empty = docked_item.reduce_fuel()
		charge.emit(team)
		if not empty:
			$fuelTimer.start()
		else:
			emptied.emit(docked_item)
			state = State.EMPTY
			docked_item = null
			$fuelTimer.stop()
		
