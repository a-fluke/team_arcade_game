extends Dock
class_name RefuelStation

func _ready() -> void:
	docking_location = $barrel_placer.global_position
	$fuelTimer.wait_time = 1.0

func accepts(item):
	return item is Barrel

func empty():
	state = State.EMPTY
	$fuelTimer.stop()

func _on_area_2d_body_entered(body: Node2D) -> void:
	if accepts(body):
		valid_nearby_items.append(body)
		body.dropped.connect(_dock)

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body in valid_nearby_items:
		valid_nearby_items.erase(body)
		body.dropped.disconnect(_dock)

func _dock(item : Carryable):
	if state == State.EMPTY or state == State.PARTIAL:
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
