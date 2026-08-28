extends Dock
class_name BatteryCharger


func _ready() -> void:
	docking_location = $barrel_placer.global_position
	$fuelTimer.wait_time = 1.0

func accepts(item,player):
	return item is Battery

func empty():
	state = State.EMPTY
	$fuelTimer.stop()


func _dock(item : Carryable):
	if (state == State.EMPTY or state == State.PARTIAL):
		item.place(docking_location,self)
		state = State.FULL
		docked_item = item
		if item.can_fuel():
			$fuelTimer.start()
	else:
		var rejection_loc = Vector2([1,-1].pick_random() * randi_range(10,16),0)
		item.reject(docking_location + rejection_loc)

func _on_fuel_timer_timeout() -> void:
	if docked_item.can_fuel():
		docked_item.increase_fuel()
		$fuelTimer.start()
