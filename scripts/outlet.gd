extends Dock
class_name Outlet

signal charge(team)
@export var team = "blue"


func _ready() -> void:
	docking_location = $cable_placer.global_position
	$chargeTimer.wait_time = 1.0
	if team == "red":
		$cable_placer.position.x = -$cable_placer.position.x
		$Area2D.position.x = -$Area2D.position.x
		$Sprite2D.texture = load("res://assets/outlet/red_outlet.png")
		docking_location = $cable_placer.global_position

func _process(_delta: float) -> void:
	if state != State.FULL:
		$chargeTimer.stop()

func accepts(item,player):
	return item is Cable and player.player_info.team == team

func _dock(item : Carryable):
	if (state == State.EMPTY or state == State.PARTIAL):
		item.place(docking_location,self)
		state = State.FULL
		docked_item = item
		#$chargeTimer.start()
	else:
		var rejection_loc = Vector2([1,0].pick_random() * randi_range(10,16),0)
		item.reject(docking_location + rejection_loc)

func charge_at_end():
	charge.emit(team)

#func _on_charge_timer_timeout() -> void:
	#charge.emit(team)
	#$chargeTimer.start()
