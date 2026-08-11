extends Node2D

var BATTERY_SCENE = load("res://scenes/battery.tscn")

var battery_spawns : Array[Vector2] = [
	Vector2(152,70),
	Vector2(168,184),
	Vector2(80,260),
	Vector2(488,70),
	Vector2(472,184),
	Vector2(560,260),
]

var battery_count := 0

var blue_team : int = 0
var red_team : int = 0

func _ready() -> void:
	$towers/blue_tower.charge.connect(_charge_ship)
	$towers/blue_tower.emptied.connect(_free_battery)
	$towers/red_tower.charge.connect(_charge_ship)
	$towers/red_tower.emptied.connect(_free_battery)

func _process(_delta: float) -> void:
	if battery_count < 2 and $batteries/spawn_timer.is_stopped():
		battery_timer()

func _charge_ship(team):
	if team == "blue":
		blue_team += 1
		$Blue_Score.increase_charge()
		if blue_team == 33:
			print("done")
	elif team == "red":
		red_team += 1
		$Red_Score.increase_charge()
		if red_team == 33:
			print("done")
	
	print("Score- B: ", blue_team, "R: ", red_team )


func battery_timer():
	$batteries/spawn_timer.wait_time = randf_range(1,2)
	$batteries/spawn_timer.start()

func _on_spawn_timer_timeout() -> void:
	spawn_battery()

func spawn_battery():
	if battery_spawns.size() <= 0:
		return
	var new_battery = BATTERY_SCENE.instantiate()
	
	var index = randi_range(0,battery_spawns.size()-1)
	var spawn = battery_spawns[index]
	new_battery.position = spawn
	new_battery.spawn_position = spawn
	battery_spawns.remove_at(index)
	
	$batteries.add_child(new_battery)
	
	battery_count += 1


func _free_battery(battery):
	battery_spawns.append(battery.spawn_position)
	battery.queue_free()
	battery_count -= 1
