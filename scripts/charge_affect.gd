extends Node2D

signal charge_at_end

@onready var cable: Node2D = get_parent()
@onready var line: Line2D = cable.get_node("Line")
@onready var plug: Carryable = cable.get_node("plug")
@onready var timer: Timer = cable.get_node("chargeTimer")

var charging : bool
var charge_progress : float = 0.0
var CHARGE_SPACING = 0.2
var CHARGE_COUNT := 5

func _process(delta: float) -> void:
	charge_progress += delta / timer.wait_time
	queue_redraw()

func _draw() -> void:
	if not cable.charging:
		return
	
	var progress := 1.0 - (timer.time_left / timer.wait_time)
	
	var cable_length :float = get_cable_length()

	for i in range(CHARGE_COUNT):

		var circle_progress :float = (i * CHARGE_SPACING) + (CHARGE_SPACING*charge_progress)

		# Wrap the circles around
		circle_progress = fmod(circle_progress + 1.0, 1.0)

		var distance := circle_progress * cable_length
		var position := get_position_along_line(distance)

		draw_circle(position, 3.0, Color.YELLOW)


func get_cable_length() -> float:
	var length := 0.0

	for i in range(line.points.size() - 1):
		length += line.points[i].distance_to(line.points[i + 1])

	return length

func get_position_along_line(distance: float) -> Vector2:
	var remaining := distance

	for i in range(line.points.size() - 1):
		var a := line.points[i]
		var b := line.points[i + 1]

		var segment_length := a.distance_to(b)

		if remaining <= segment_length:
			var t := remaining / segment_length
			return a.lerp(b, t)

		remaining -= segment_length
	
	return line.points[-1]
